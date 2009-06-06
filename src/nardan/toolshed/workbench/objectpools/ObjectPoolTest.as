/**
 * Nardan's Tool-Box
 * Copyright (c) 2009 Alastair Brown real_nardan@hotmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 
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
		
		protected function onEnterFrame(e:Event):void 
		{
			var sp:PooledSprite;
			if (Math.random() > 0.25 || spList.length == 0) {
				//sp = ObjectPoolCache.getInstance().getObject(PooledSprite);
				sp = ObjectPoolCache.getInstance().get(PooledSprite);
				sp.x =  Math.random() * 800;
				sp.y =  Math.random() * 600;
				this.addChild(sp);
				this.spList.push(sp);
			}else {
				sp = spList.splice(Math.floor(spList.length * Math.random()), 1)[0];
				this.removeChild(sp);
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