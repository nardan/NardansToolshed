package nardan.toolshed.workbench.threads 
{
	import flash.events.Event;
	import flash.text.TextField;
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
		private var lastPrimesLength:int = 0;
		private var output:TextField;

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
			
			output =  new TextField();
			output.width = canvas.width;
			output.height =  canvas.height;
			output.multiline = true;
			output.wordWrap = true;
			canvas.rawChildren.addChild(output);
			
			thread =  new PrimesThread();
			thread.addEventListener(ThreadEvent.ITERATE, onIterate);
			thread.addEventListener(ThreadEvent.TERMINATE, onTerminate);
		}
		
		private function onTerminate(e:ThreadEvent):void 
		{
			trace('TestApp::onTerminate thread.primes = ' + thread.primes);
		}
		
		private function onIterate(e:ThreadEvent):void 
		{
			//trace('TestApp::onRunSlice');
			if (lastPrimesLength < thread.primes.length) {
				var str:String = thread.primes.join(", ");
				output.text = str;
				lastPrimesLength = thread.primes.length;
			}
		}
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
	}

	
}