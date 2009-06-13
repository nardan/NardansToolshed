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
 
package nardan.toolshed.parts.performance.objectpool 
{
	
	/**
	 * May be useful when pooling objects.
	 * These functions get called by ObjectPool
	 * 
	 * getPrepare(): Gets called when being retrieved from it's pool 
	 * setPrepare(): Gets called when returned to it's pool
	 * 
	 * @author real_nardan@hotmail.com
	 * @see nardan.toolshed.tools.performance.objectpool.ObjectPool
	 */
	public interface IPoolable 
	{
		/**
		 * Gets called when an IPoolable object is retrieved from an ObjectPool
		 */
		function getPrepare():void;
		/**
		 * Gets called when an IPoolable object is returned to an ObjectPool
		 */
		function setPrepare():void;
	}
	
}