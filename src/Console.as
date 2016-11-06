package
{
    
    import flash.external.ExternalInterface;
    
    /**
     * 打印调试信息
     * @author xuexb <fe.xiaowu@gmail.com>
     */
    public class Console
    {
        
        public function Console()
        {
        }
        
        /**
         * 输出错误信息
         * @param ...args
         * @return Console
         */
        public static function error(...args:Array):Object
        {
            return print('console.error', args);
        }
        
        /**
         * 输出普通信息
         * @param ...args
         * @return Console
         */
        public static function log(...args:Array):Object
        {
            return print('console.log', args);
        }
        
        /**
         * 输出警告信息
         * @param ...args
         * @return Console
         */
        public static function warn(...args:Array):Object
        {
            return print('console.warn', args);
        }
        
        /**
         * 打印
         * @param command
         * @param ...args
         * @return Console
         */
        private static function print(command:String, data:Array):Object
        {
            try
            {
                if (data.length === 1) {
                    ExternalInterface.call(command, data[0]);
                }
                else if (data.length === 2) {
                    ExternalInterface.call(command, data[0], data[1]);
                }
                else {
                    ExternalInterface.call(command, JSON.stringify(data, null, 2));
                }
            }
            catch (error:Error)
            {
                trace(JSON.stringify(data, null, 2));
            }
            
            return Console;
        }
    }

}