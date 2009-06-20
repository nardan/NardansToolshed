package nardan.toolshed.parts.performance.thread 
{
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public interface IThread 
	{
		/**
		 * runs a single slice of the thread returns true if the is more
		 * @return
		 */
		function runSlice():Boolean;
		
		/**
		 * Called to terminate a thread, often in runSlice() 
		 */
		function kill():void;
		/**
		 * The active state of a Thread. If True then runSlice will be called
		 */
		function get active():Boolean;
		function set active(value:Boolean):void;
		/**
		 * Maximum time allocated to running the Thread's runSlice() iterations each "RunTick"
		 */
		function get maxTime():uint;
		/**
		 * Maximum iterations of runSlice() each "RunTick"
		 */
		function get maxIterations():uint;
	}
	
}