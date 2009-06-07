package nardan.toolshed.workbench.transform 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.containers.VDividedBox;
	import mx.controls.Button;
	import mx.controls.sliderClasses.Slider;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import nardan.toolshed.tools.transform.TransformUtils;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class TestApp extends Application
	{
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		/***************************************** *
		 * Static Methods
		 * **************************************** */
		/* **************************************** *
		 * Properties
		* **************************************** */
		[Embed(source = '../../../../../lib/1508849_efd4_625x1000.jpg')]
		public var imageExample:Class;
		
		public var vBox:VDividedBox;
		private var sp:Sprite;
		private var bmp:Bitmap;
		private var rect:Rectangle;
		
		public var vAlign:Slider;
		public var hAlign:Slider;
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
			
			var can:Canvas = vBox.getChildByName("canvas") as Canvas;
			sp =  new Sprite();
			bmp =  new imageExample() as Bitmap;
			bmp.smoothing = true;
			
			can.rawChildren.addChild(bmp);
			can.rawChildren.addChild(sp);
			
			rect = new Rectangle(50, 50, 300, 200);
			
			
			
			var controlsBox:Box = vBox.getChildByName("controlsBox") as Box;
			vAlign = controlsBox.getChildByName("vAlign") as Slider;
			hAlign = controlsBox.getChildByName("hAlign") as Slider;
			
			applyRectangle();
		}
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
		protected function applyRectangle():void
		{
			sp.graphics.clear();
			sp.graphics.lineStyle(1, 0xFF0000);
			sp.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			bmp.x = bmp.y = 0; 
			bmp.scaleX = bmp.scaleY = 1;
			TransformUtils.scaleIntoRect(bmp, rect, vAlign.value, hAlign.value);
		}
		
	}

	
}