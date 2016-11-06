package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.system.Security;
    import flash.system.System;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.utils.setTimeout;
    
    [SWF(width = 100, height = 100, frameRate = 30)];
    
    /**
     * 复制插件
     *
     * @author xuexb
     *
     * @param id - 元素标识, 用来通信
     * @param cb - 回调名称， 默认为 console.log
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
        private var text:String = 'fe.xiaowu@gmail.com';
        
        /**
         * 回调名称
         */
        private var callbackName:String = '';
        
        /**
         * 调试模式
         */
        private var debug:uint = 0;
        
        public function Copy():void
        {
            super();
            
            stage.scaleMode = StageScaleMode.NO_BORDER;
            Security.allowDomain('*');
            
            var self:Object = this;
            var flashvars:* = Tools.getSwfInfo(self);
            
            id = flashvars.id;
            callbackName = flashvars.cb || 'console.log';
            if (flashvars.debug)
            {
                debug = 1;
            }
            
            // 初始按钮
            button = new Sprite();
            addChild(button);
            button.buttonMode = true;
            button.useHandCursor = true;
            button.graphics.beginFill(0xFF0000);
            button.graphics.drawRect(0, 0, Math.floor(100), Math.floor(100));
            button.alpha = debug ? 0.3 : 0;
            button.graphics.endFill();
            
            // 绑定事件
            button.addEventListener(MouseEvent.CLICK, clickHandler);
            button.addEventListener(MouseEvent.MOUSE_OVER, function(event:Event):void
            {
                trigger('mouseover', null);
            });
            button.addEventListener(MouseEvent.MOUSE_OUT, function(event:Event):void
            {
                trigger('mouseout', null);
            });
            button.addEventListener(MouseEvent.MOUSE_DOWN, function(event:Event):void
            {
                trigger('mousedown', null);
            });
            button.addEventListener(MouseEvent.MOUSE_UP, function(event:Event):void
            {
                trigger('mouseup', null);
            });
            
            // 对外暴露接口
            try
            {
                ExternalInterface.addCallback('setText', apiSetText);
                ExternalInterface.addCallback('setLinks', apiSetLinks);
            }
            catch (err:Error)
            {
            }
            
            // 触发准备完成
            trigger('ready', null);
        }
        
        /**
         * 点击回调
         * @param   event
         */
        private function clickHandler(event:Event):void
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
         * 触发回调
         * @param   event
         */
        private function trigger(event:String, text:*):void
        {
            try
            {
                ExternalInterface.call(callbackName, id, event, {callback: callbackName, id: id, event: event, text: text});
            }
            catch (err:Error)
            {
                Console.error({callbackName: callbackName, id: id, event: event, text: text});
            }
            
            // 如果是调试模式
            if (debug)
            {
                Console.log({callbackName: callbackName, id: id, event: event, text: text});
            }
        }
        
        /**
         * 对外接口 - 设置右键菜单接口
         * @param   links
         */
        private function apiSetLinks(links:Array):void
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
         * @param   links
         */
        private function apiSetText(str:String):void
        {
            text = str;
        }
    }

}