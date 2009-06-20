package nardan.toolshed.parts.performance.thread 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class ThreadEvent extends Event 
	{
		public static const RUN_SLICE:String = "ThreadEvent.RUN_SLICE";
		public static const TERMINATE:String = "ThreadEvent.TERMINATE";
		
		
		public function ThreadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		/** @private */
		public override function clone():Event 
		{ 
			return new ThreadEvent(type, bubbles, cancelable);
		}
		
		/** @private */
		public override function toString():String 
		{ 
			return formatToString("ThreadEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}