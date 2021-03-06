﻿/**
 * Nardan's Tool-Box
 * Copyright (c) 2010 Alastair Brown alastair@codecharmer.comm
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
	 * IPoolable is an optional interface for objects in an <code>ObjectPool</code> 
	 * 
	 * May be useful when pooling objects.
	 * These functions get called by ObjectPool
	 * 
	 * prepareGet(): Gets called when being retrieved from it's pool 
	 * prepareSet(): Gets called when returned to it's pool
	 * 
	 * <p><b>IPoolable ©2009 Alastair Brown. Licensed under the MIT license</b></p>
	 * 
	 * @author alastairr@codecharmer.comom
	 * @see ObjectPool
	 * @version 1.0
	 */
	public interface IPoolable 
	{
		/**
		 * Gets called when an IPoolable object is retrieved from an ObjectPool
		 */
		function prepareGet():void;
		/**
		 * Gets called when an IPoolable object is returned to an ObjectPool
		 */
		function prepareSet():void;
	}
	
}