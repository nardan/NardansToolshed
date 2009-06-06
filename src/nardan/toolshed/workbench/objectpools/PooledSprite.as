package nardan.toolshed.workbench.objectpools 
{
	import flash.display.Sprite;
	import nardan.toolshed.tools.performance.objectpool.IPoolable;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class PooledSprite extends Sprite implements IPoolable
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
		/******************************************
		 * Constructor
		 ******************************************/
		public function PooledSprite() 
		{
			
		}
		
		/******************************************
		 * Getters & Setters
		 ******************************************/
		/******************************************
		 * Public Methods
		 ******************************************/
		/* INTERFACE nardan.toolshed.tools.performance.objectpool.IPoolable */
		
		public function getPrepare():void
		{
			//trace('PooledSprite::getPrepare');
			var col:uint = Math.floor((0xFFFFFF + 1) * Math.random());
			var rad:Number = 25 + Math.random() * 100;
			this.graphics.beginFill(col);
			this.graphics.drawCircle( -rad, -rad, rad);
		}
		
		public function setPrepare():void
		{
			//trace('PooledSprite::setPrepare');
			this.graphics.clear();
		}
		/******************************************
		 * Event Handlers
		 ******************************************/
		/******************************************
		 * Protected * Private Methods
		 ******************************************/
		
	}

	
}