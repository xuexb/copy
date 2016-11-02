/**
 * @file 复制js
 * @author fe.xiaowu@gmail.com
 * @date 20161031
 *
 * @event
 *     copy.success - 复制成功
 *     copy.error - 复制出错
 *     copy.mouseover - 滑入
 *     copy.mouseout - 滑出
 *     copy.mousedown - 按下鼠标
 *     copy.mouseup - 松开鼠标
 *
 * @description
 *     1. as对外暴露的接口:
 *         setText - 设置复制文本
 *         setLinks - 设置链接
 *     2. as里绑定事件, 在用户触发时使用标识来调用js触发事件
 *     3. js对as暴露的接口:
 *         $.fn.copy.FLASHcallback - 事件回调, 使用标识、事件名来触发
 *     4. 逻辑:
 *         1. 实例化
 *         2. 输出dom和swf到页面, 并绑定事件
 *         3. 用户在swf元素上交互时触发事件
 *         4. 用户在点击时触发getText事件, js使用as的接口把最新的文本设置给as, as来复制到粘贴板
 */

(function ($) {
    var expando = 'copy_' + $.now();

    /**
     * 复制主体构造函数
     *
     * @class
     * @param {Object} options 配置对象
     * @param {Element} element 目标元素
     */
    function Copy(options, element) {
        var self = this;

        self.options = options;
        self.$elem = $(element);
        self.id = expando + (Copy.id++);

        Copy.list[self.id] = self;
        self.$elem.data('copy-id', self.id);

        self.append();
    }

    /**
     * 输出dom到页面
     */
    Copy.prototype.append = function () {
        var self = this;
        var id = self.id;
        var path = self.options.path;
        var $elem = self.$elem;
        var width = $elem.outerWidth(true);
        var height = $elem.outerHeight(true);
        var $wrap = $('<div />');
        var flashvars = 'id=' + id + '&width=' + width + '&height=' + height;
        var html;

        $wrap.css({
            position: 'absolute',
            zIndex: 10000,
            width: width,
            height: height
        });

        $wrap.appendTo(document.body);

        if (navigator.userAgent.match(/MSIE/)) {
            // IE gets an OBJECT tag
            html = [
                '<object id="' + id + '" ',
                'classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" ',
                'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" ',
                'style="width:100%;height:100%;vertical-align:top;">',
                    '<param name="allowScriptAccess" value="always" />',
                    '<param name="allowFullScreen" value="false" />',
                    '<param name="movie" value="' + path + '" />',
                    '<param name="loop" value="false" />',
                    '<param name="menu" value="false" />',
                    '<param name="quality" value="best" />',
                    '<param name="bgcolor" value="#ffffff" />',
                    '<param name="flashvars" value="' + flashvars + '"/>',
                    '<param name="wmode" value="transparent"/>',
                '</object>'].join('');
        }
        else {
            html = [
                '<embed id=" ' + id + '" name=" ' + id + ' " style="width:100%;height:100%;vertical-align:top;" ',
                'src=" ' + path + '" ',
                'loop="false" ',
                'menu="false" ',
                'quality="best" ',
                'bgcolor="#ffffff" ',
                'allowScriptAccess="always" ',
                'allowFullScreen="false" ',
                'type="application/x-shockwave-flash" ',
                'pluginspage="http://www.macromedia.com/go/getflashplayer" ',
                'flashvars="' + flashvars + '" ',
                'wmode="transparent" />'
            ].join('');
        }

        $wrap.get(0).innerHTML = html;

        self.flashElement = document.getElementById(self.id);
        self.$wrap = $wrap;

        self.reset();
        self.setLinks();

        $(window).on('resize.' + id, function () {
            self.reset();
        });
    };

    /**
     * 重置元素的位置信息
     *
     * @return {Object} this
     */
    Copy.prototype.reset = function () {
        var offset = this.$elem.offset();
        this.$wrap.css({
            left: offset.left,
            top: offset.top
        });
        return this;
    };

    /**
     * 销毁
     *
     * @return {Object} this
     */

    Copy.prototype.destroy = function () {
        var self = this;
        var id = self.id;

        self.$elem.removeData('copy-id').off('.' + id);
        self.$wrap.remove();
        $(window).off('.' + id);
        delete Copy.list[id];

        for (var key in self) {
            if (self.hasOwnProperty(key)) {
                delete self[key];
            }
        }

        return self;
    };

    /**
     * 设置链接
     *
     * @param {Array} links 链接数据
     * @return {Object} this
     */
    Copy.prototype.setLinks = function (links) {
        var self = this;

        links = links || self.options.links;

        // 如果有链接数据, 并且当前swf有设置链接的接口则调用as代码来设置
        if (links && links.length && self.flashElement && self.flashElement.setLinks) {
            self.flashElement.setLinks(links);
        }

        return self;
    };

    /**
     * 设置文本到当前实例, 主要用来多次初始
     *
     * @param {string} text 文本
     * @return {Object} this
     */
    Copy.prototype.setText = function (text) {
        this.options.text = text;
        return this;
    };

    /**
     * 获取当前最新的文本
     *
     * @return {Object} this
     */
    Copy.prototype.getText = function () {
        var text = this.options.text;

        if ($.isFunctioin(text)) {
            text = text.call(this.$elem.get(0));
        }

        return text;
    };

    /**
     * 缓存列表, 主要把实例以id为key的形式存下来, 方便和swf交互
     *
     * @type {Object}
     */
    Copy.list = {};

    /**
     * 唯一标识
     *
     * @type {Number}
     */
    Copy.id = 1;

    /**
     * 使用标识获取实例对象
     *
     * @param  {string} id 标识
     *
     * @return {Object}    实例
     */
    Copy.get = function (id) {
        return Copy.list[id];
    };

    /**
     * 方法入口
     *
     * @param  {Object} options 配置对应
     *
     * @return {Object}         jQuery对象
     */
    $.fn.copy = function (options) {
        if (!$.isPlainObject(options)) {
            options = $.extend({}, $.fn.copy.defaults, {
                text: options
            });
        }

        return this.each(function (index, val) {
            var id = $(this).data('copy-id');

            // 如果有缓存表示初始过
            if (id) {
                // 如果要销毁
                if (options.text === 'destroy') {
                    return Copy.get(id).destroy();
                }

                // 否则重新设置文本和链接
                return Copy.get(id).setText(options.text).setLinks(options.links).reset();
            }
            if (options.text !== 'destroy') {
                new Copy(options, this);
            }
        });
    };

    /**
     * swf文件的触发回调
     *
     * @param {string} id    标识
     * @param {string} event 事件名
     */
    $.fn.copy.FLASHcallback = function (id, event, data) {
        var api = Copy.get(id);

        if (api) {
            if (event === 'mousedown' && api.flashElement && api.flashElement.setText) {
                api.flashElement.setText(api.getText());
            }
			
			api.$elem.trigger('copy.' + event. data);
        }

        api = null;
    };

    /**
     * 默认参数
     *
     * @type {Object}
     * @param {string} defaults.path swf所在路径
     * @param {string|Function} defaults.text 复制文本
     * @param {Array} defaults.links 右键链接菜单
     * @param {string} defaults.links[].name 菜单名称
     * @param {string} defaults.links[].url 菜单链接
     * @param {boolean} defaults.links[].disabled 是否禁用
     * @param {boolean} defaults.links[].border 是否需要边框
     */
    $.fn.copy.defaults = {
        path: '',
        text: '',
        links: []
    };
})(window.jQuery);
