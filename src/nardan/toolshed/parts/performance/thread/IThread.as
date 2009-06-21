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
	
	/**
	 * IThread is the Interface of Threads and can be added to the runList using <code>Thread.addToRunList(thread:IThread, posn:int = -1)</code>.
	 * 
	 * <br><b>IThread ©2009 Alastair Brown. Licensed under the MIT license</b>
	 * 
	 * @see Thread
	 * @author real_nardan@hotmail.com
	 */
	public interface IThread 
	{
		/**
		 * runs a single iteration of the thread returns true if the is more
		 * @return
		 */
		function iterate():Boolean;
		
		/**
		 * Called to terminate a thread, often in runIteration() 
		 */
		function terminate():void;
		/**
		 * The active state of a Thread. If True then runIteration will be called
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