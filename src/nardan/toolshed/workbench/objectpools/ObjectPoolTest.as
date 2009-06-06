package nardan.toolshed.workbench.objectpools 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import nardan.toolshed.tools.performance.objectpool.ObjectPoolCache;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class ObjectPoolTest extends MovieClip
	{
		
		/******************************************
		* Static Constants & Variables
		******************************************/
		/******************************************
		 * Static Methods
		 ******************************************/
		/******************************************
		 * Properties
		******************************************/
		private var spList:Vector.<PooledSprite>;
		
		/******************************************
		 * Constructor
		 ******************************************/
		public function ObjectPoolTest() 
		{
			trace('ObjectPoolTest::ObjectPoolTest');
			spList = new Vector.<PooledSprite>();
			ObjectPoolCache.getInstance().initPool(PooledSprite, 10);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var sp:PooledSprite;
			if (Math.random() > 0.25) {
				//sp = ObjectPoolCache.getInstance().getObject(PooledSprite);
				sp = ObjectPoolCache.getInstance().get(PooledSprite);
				sp.x =  Math.random() * 500;
				sp.y =  Math.random() * 450;
				this.addChild(sp);
				this.spList.push(sp);
			}else {
				sp = spList.splice(Math.floor(spList.length * Math.random()), 1)[0];
				this.removeChild(sp);
				//ObjectPoolCache.getInstance().setObject(sp);
				ObjectPoolCache.getInstance().set(sp);
			}
		}
		/******************************************
		 * Getters & Setters
		 ******************************************/
		/******************************************
		 * Public Methods
		 ******************************************/
		/******************************************
		 * Event Handlers
		 ******************************************/
		/******************************************
		 * Protected * Private Methods
		 ******************************************/
		
	}

	
}