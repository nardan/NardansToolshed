package nardan.toolshed.workbench.transform 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VDividedBox;
	import mx.controls.sliderClasses.Slider;
	import mx.events.FlexEvent;
	
	import nardan.toolshed.tools.transform.TransformUtils;
	
	import spark.components.Application;
	
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
		[Embed(source='1508849_efd4_625x1000.jpg')]
		public var imageExample:Class;
		
		public var vBox:VDividedBox;
		public var canvas:Canvas;
		public var controlsBox:Box;
		private var sp:Sprite;
		private var tgt:Sprite;
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
			
			sp =  new Sprite();
			tgt =  new Sprite();
			bmp =  new imageExample() as Bitmap;
			bmp.smoothing = true;
			tgt.addChild(bmp);
			
			bmp.x =  bmp.width*-0.5;
			bmp.y =  bmp.height*-0.5;
			
			canvas.rawChildren.addChild(tgt);
			canvas.rawChildren.addChild(sp);
			
//			rect = new Rectangle(50, 50, 300, 200);
			rect = new Rectangle(50, 50, 200, 300);
		
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
			
			tgt.x = tgt.y = 0; 
			tgt.scaleX = tgt.scaleY = 1;
			TransformUtils.scaleIntoRect(tgt, rect, vAlign.value, hAlign.value);
		}
		
	}

	
}