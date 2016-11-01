package 
{
	import flash.display.LoaderInfo;
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class Tools
	{
		
		/**
		 * 获取swf信息
		 * @param {object} obj 实例
		 * @return {object} 参数对象
		 */
		public static function getSwfInfo(obj:Object):Object
		{
			return LoaderInfo(obj.root.loaderInfo).parameters || {};
		}
		
		/**
		 * 判断是否为数组[] || new Array
		 * @param {*} arr 判断是否为数组
		 * @return {Boolean}
		 */
		public static function isArray(arr:* = ''):Boolean
		{
			return Tools.isType(arr, 'Array');
		}
		
		/**
		 * 判断是否为方法
		 * @param {*} arr 判断是否为方法
		 * @return {Boolean}
		 */
		public static function isFunction(fn:* = ''):Boolean
		{
			return typeof fn === 'function';
		}
		
		/**
		 * 判断是否为布尔
		 * @param {*} bol 判断是否为布尔
		 * @return {Boolean}
		 */
		public static function isBoolean(bol:* = ''):Boolean
		{
			return typeof bol === 'boolean';
		}
		
		/**
		 * 判断是否为数字
		 * @param {*} arr 判断是否为数字
		 * @return {Boolean}
		 */
		public static function isNumber(num:* = ''):Boolean
		{
			return typeof num === 'number';
		}
		
		/**
		 * 判断是否为数字
		 * @param {*} str 判断是否为字符串
		 * @return {Boolean}
		 */
		public static function isString(str:* = ''):Boolean
		{
			return typeof str === 'string';
		}
		
		
		
		/**
		 * 判断是否为对象{} || new Object
		 * @param {*} obj 判断是否为对象
		 * @return {Boolean}
		 */
		public static function isEmptyObject(obj:*):Boolean
		{
			var key:String;
			
			if (!Tools.isObject(obj)) {
				return false;
			}
			
			for (key in obj) {
				return false;
			}
			
			return true;
		}
		
		
		/**
		 * 判断是否为对象{} || new Object
		 * @param {*} obj 判断是否为对象
		 * @return {Boolean}
		 */
		public static function isObject(obj:*):Boolean
		{
			return Tools.isType(obj, 'Object');
		}
		
		/**
		 * 内部使用判断主入口
		 * @param {*} 目标对象
		 * @param {string} type 类型
		 * @return {Boolean}
		 */
		private static function isType(obj:*, type:String):Boolean
		{
			return {}.toString.call(obj) == "[object " + type + "]";
		}
		
		/**
		 * 输出控制台信息
		 * @description 兼容web+flash player, 方便调试
		 * @param {string} str 要输出的信息
		 * @return Tools对象
		 */
		public static function console(data:*):Object
		{
			try
			{
				ExternalInterface.call("console.log", data);
			}
			catch (error:Error)
			{
				trace(Tools.isObject(data) ? (data) : data);
			}
			
			return Tools;
		}
		
		/**
		 * 创建右键菜单
		 * @param {obj} object flash实例对象
		 * @param {array} data 右键数据
		 * @return Tools对象
		 *
		 * @demo
		 * 	1, Tools.create_menu(this);
		 * 	2, Tools.create_menu(this, {title:'复制组件', url: '/'});
		 * 	3, Tools.create_menu(this, {title:'复制组件', disabled: true}, {title:'复制组件', url: '/'});
		 */
		public static function createMenu(obj:Object, ... args:Array):Object
		{
			// 菜单对象
			var Menu:ContextMenu = obj.contextMenu = new ContextMenu();
			Menu.hideBuiltInItems();
			
			// 右键数据
			var data:Array = [];
			
			// 如果有数据则追加
			if (args && args.length)
			{
				// 包子哥指正,谢谢, js里不data不行... 插不了
				data.push.apply(data, args);
			}
			
			// 追加系统标识
			// data.push({url: "http://easywed.cn/?rel=flash", title: "易结网", line: data.length ? true : false}, {title: '版本: v1.0.0', disabled: true});
			
			// 循环创建菜单
			data.forEach(function(val:Object, index:int, arr:Array):void
				{
					var item:ContextMenuItem = new ContextMenuItem(val.title, !!val.line, !val.disabled);
					
					if (!val.disabled && val.url)
					{ 
						// 如果有打开的页面地址且为
						item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void
						{
							navigateToURL(new URLRequest(val.url), "_blank");
						});
					}
					
					Menu.customItems.push(item);
					
					item = null;
				});
			
			data = null;
			
			return Tools;
		}
	}
}