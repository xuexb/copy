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
     * 设置文本到当前实例, 主要用来多次初始
     *
     * @param {Object} str this
     * @return {Object} this
     */
    Copy.prototype.setText = function (str) {
        this.options.str = str;
        return this;
    };

    /**
     * 获取当前最新的文本
     *
     * @param {Object} str this
     * @return {Object} this
     */
    Copy.prototype.getText = function () {
        var str = this.options.str;

        if ($.isFunctioin(str)) {
            str = str.call(this.$elem.get(0));
        }

        return str;
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
                str: options
            });
        }

        return this.each(function (index, val) {
            var id = $(this).data('copy-id');

            // 如果有缓存表示初始过
            if (id) {
                // 如果要销毁
                if (options.str === 'destroy') {
                    return Copy.get(id).destroy();
                }

                return Copy.get(id).setText(options.str).reset();
            }
            if (options.str !== 'destroy') {
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
    $.fn.copy.FLASHcallback = function (id, event) {
        var api = Copy.get(id);

        if (api) {
            if (event === 'getText' && api.flashElement && api.flashElement.setText) {
                api.flashElement.setText(api.getText());
            }
            else {
                api.$elem.trigger('copy.' + event);
            }
        }

        api = null;
    };

    /**
     * 默认参数
     *
     * @type {Object}
     * @param {string} defaults.path swf所在路径
     */
    $.fn.copy.defaults = {
        path: '',
        str: ''
    };
})(window.jQuery);