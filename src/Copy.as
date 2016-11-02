package 
{
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	import flash.system.System;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
    
    /**
     * 复制插件
	 *
     * @author xuexb
	 *
	 * @param width - 元素宽
	 * @param height - 元素高
	 * @param id - 元素标识, 用来通信
	 * @param cb - 回调名称， 默认为 $.fn.copy.FLASHcallback
	 * @param debug - 是否调试模式， 默认为 0
     */
    public class Copy extends Sprite 
    {
		/**
		 * 按钮对象
		 */
        private var button:Sprite;
		
		/**
		 * 当前id标识
		 */
		private var id:String = '';
		
		/**
		 * 当前要复制的文本
		 */
		private var text:String = '';
		
		/**
		 * 回调名称
		 */
		private var callbackName:String = '';
		
		/**
		 * 调试模式
		 */
		private var debug:Number = 0;
		  
        public function Copy():void 
        {
			super();
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
         	Security.allowDomain('*');
			
			var self:Object = this;
			var flashvars:* = Tools.getSwfInfo(self);
			
			id = flashvars.id;
			callbackName = flashvars.cb || '$.fn.copy.FLASHcallback';
			if (flashvars.debug) {
				debug = 1;
			}
			
			// 初始按钮
			button = new Sprite();
			button.buttonMode = true;
			button.useHandCursor = true;
			button.graphics.beginFill(13434624);
			button.graphics.drawRect(0, 0, Math.floor(flashvars.width || 100), Math.floor(flashvars.height || 100));
			//button.alpha = 0;
			addChild(button);
			
			// 绑定事件
			button.addEventListener(MouseEvent.CLICK, clickHandler);
			button.addEventListener(MouseEvent.MOUSE_OVER, function(event:Event) : void
			{
				trigger('mouseover', null);
			});
			button.addEventListener(MouseEvent.MOUSE_OUT, function(event:Event) : void
			{
				trigger('mouseout', null);
			});
			button.addEventListener(MouseEvent.MOUSE_DOWN,function(event:Event) : void
			{
				trigger('mousedown', null);
			});
			button.addEventListener(MouseEvent.MOUSE_UP,function(event:Event) : void
			{
				trigger('mouseup', null);
			});
			
			Tools.createMenu(self, {title:'复制组件', url: 'http://baidu.com'}, {title:'测试', disabled: true, url: 'http://baidu.com'});
			
			// 对外暴露接口
			// ExternalInterface.addCallback("setText", apiSetText);
			// ExternalInterface.addCallback("setLinks", apiSetLinks);
			
			// 触发准备完成
			trigger('ready', null);
        }
		
		private function clickHandler(event:Event) : void
      	{
         	try 
			{
				System.setClipboard(text);
				trigger('success', text);
			} 
			catch (err:Error) 
			{
				trigger('error', '复制失败');
			}
      	}
		
		/**
		 * 对外接口 - 设置右键菜单接口
		 * @param	links
		 */
		private function apiSetLinks(links:Array) : void
		{
			try 
			{
				Tools.createMenu(this, links);
			} 
			catch (err:Error) 
			{
				trigger('error', '创建菜单失败');
			}
		}
		
		/**
		 * 对外接口 - 设置复制文字
		 * @param	links
		 */
		private function apiSetText(str:String) : void
		{
			text = str;
		}
		
		/**
		 * 触发回调
		 * @param	event
		 */
		private function trigger(event:String, data:*) : void
		{
			Tools.console(event, data);
			// ExternalInterface.call(callbackName, id, event, data);
		}
    }
    
}