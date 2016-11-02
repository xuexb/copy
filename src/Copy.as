package 
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    /**
     * ...
     * @author xuexb
     */
    public class Copy extends Sprite 
    {
        
        public function Copy():void 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            // entry point
            Tools.console({a: 1}, 2, 3);
        }
        
    }
    
}