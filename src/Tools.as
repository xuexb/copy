package 
{
    import flash.display.LoaderInfo;
    import flash.events.ContextMenuEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    public class Tools
    {
        
        /**
         * 获取swf信息
         *
         * @param {Object} obj 实例
         * @return {Object} 参数对象
         */
        public static function getSwfInfo(obj:Object):Object
        {
            return LoaderInfo(obj.root.loaderInfo).parameters || {};
        }
        
        /**
         * 判断是否为数组
         *
         * @param {*} arr 目标数据
         * @return {boolean}
         */
        public static function isArray(arr:* = ''):Boolean
        {
            return Tools.isType(arr, 'Array');
        }
        
        /**
         * 判断是否为函数
         *
         * @param {*} arr 目标数据
         * @return {boolean}
         */
        public static function isFunction(fn:* = ''):Boolean
        {
            return typeof fn === 'function';
        }
        
        /**
         * 判断是否为布尔值
         *
         * @param {*} bol 目标数据
         * @return {boolean}
         */
        public static function isBoolean(bol:* = ''):Boolean
        {
            return typeof bol === 'boolean';
        }
        
        /**
         * 判断是否为数字
         *
         * @param {*} arr 目标数据
         * @return {boolean}
         */
        public static function isNumber(num:* = ''):Boolean
        {
            return typeof num === 'number';
        }
        
        /**
         * 判断是否为字符串
         *
         * @param {*} str 目标数据
         * @return {boolean}
         */
        public static function isString(str:* = ''):Boolean
        {
            return typeof str === 'string';
        }

        /**
         * 判断是否为空对象
         *
         * @param {*} obj 数据对象
         * @return {boolean}
         */
        public static function isEmptyObject(obj:*):Boolean
        {
            if (!Tools.isObject(obj)) {
                return false;
            }
            
            for (var key:String in obj) {
                return false;
            }
            
            return true;
        }

        /**
         * 判断是否为对象
         *
         * @param {*} obj 数据对象
         * @return {boolean}
         */
        public static function isObject(obj:*):Boolean
        {
            return Tools.isType(obj, 'Object');
        }
        
        /**
         * 内部使用判断主入口
         *
         * @param {*} 数据对象
         * @param {string} type 类型
         * @return {boolean}
         */
        private static function isType(obj:*, type:String):Boolean
        {
            return {}.toString.call(obj) == "[object " + type + "]";
        }
        
        /**
         * 创建右键菜单
         *
         * @param {obj} object flash实例对象
         * @param {array} data 右键数据
         * @return {Object} Tools对象
         *
         * @example
         *  1, Tools.createMenu(this);
         *  2, Tools.createMenu(this, {name:'复制组件', url: '/'});
         *  3, Tools.createMenu(this, [ {name:'复制组件', url: '/'}, {name:'复制组件', url: '/'} ]);
         *  4, Tools.createMenu(this, {name:'复制组件', disabled: true}, {name:'复制组件', url: '/'});
         */
        public static function createMenu(obj:Object, ...args:Array):Object
        {
            // 菜单对象
            var Menu:ContextMenu = obj.contextMenu = new ContextMenu();
            Menu.hideBuiltInItems();
            
            // 右键数据
            var data:Array = [];
            
            // 如果有数据则追加
            if (args && args.length)
            {
                // 如果第二个参数就传了个数组，那么直接使用，否则认为是对象
                if (Tools.isArray(args[0])) {
                    data = data.concat(args[0]);
                }
                else
                {
                    // 包子哥指正,谢谢, js里不data不行... 插不了
                    data.push.apply(data, args);
                }
            }
            
            // 循环创建菜单
            data.forEach(function(val:Object, index:int, arr:Array):void
            {
                var item:ContextMenuItem = new ContextMenuItem(val.name, !!val.line, !val.disabled);
                
                if (!val.disabled && val.url)
                { 
                    // 如果有打开的页面地址且为
                    item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void
                    {
                        navigateToURL(new URLRequest(val.url), "_blank");
                    });
                }
                
                Menu.customItems.push(item);
            });
            
            return Tools;
        }
    }
}