package nardan.toolshed.workbench.threads 
{
	import flash.events.Event;
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.containers.VDividedBox;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import nardan.toolshed.parts.performance.thread.ThreadEvent;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class TestApp extends Application
	{
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		/* **************************************** *
		 * Static Methods
		 * **************************************** */
		/* **************************************** *
		 * Properties
		* **************************************** */
		public var vBox:VDividedBox;
		public var controlsBox:Box;
		public var canvas:Canvas;
		private var thread:PrimesThread;

		/* **************************************** *
		 * Constructor
		 * **************************************** */
		public function TestApp() 
		{
			super();
			this.frameRate = 31;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		private function onCreationComplete(e:FlexEvent):void 
		{
			trace('TestApp::onCreationComplete');
			thread =  new PrimesThread();
			thread.addEventListener(ThreadEvent.RUN_SLICE, onRunSlice);
			thread.addEventListener(ThreadEvent.TERMINATE, onTerminate);
		}
		
		private function onTerminate(e:ThreadEvent):void 
		{
			trace('TestApp::onTerminate thread.primes = ' + thread.primes);
		}
		
		private function onRunSlice(e:ThreadEvent):void 
		{
			//trace('TestApp::onRunSlice');
		}
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
	}

	
}