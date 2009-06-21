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
 
package nardan.toolshed.parts.performance.thread 
{
	import flash.events.Event;
	
	/**
	 * <code>ThreadEvent</code>s get fired when a <code>Thread</code> iterates or terminates.
	 * 
	 * <br><b>ThreadEvent ©2009 Alastair Brown. Licensed under the MIT license</b>
	 * 
	 * @author real_nardan@hotmail.com
	 */
	public class ThreadEvent extends Event 
	{
		public static const ITERATE:String = "ThreadEvent.ITERATE";
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