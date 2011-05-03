/**
 * Nardan's Tool-Box
 * Copyright (c) 2011 Alastair Brown alastair@codecharmer.com
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

package nardan.toolshed.tools
{
	/**
	 * A collection of static functions to use on lists (Arrays & Vectors).
	 * 
	 * <br/><b>ListUtils ©2011 Alastair Brown. Licensed under the MIT license</b>
	 * @author alastair@codecharmer.com
	 */
	public class ListUtils
	{
		
		public static function insertIntoSorted(list:*, item:*, compareFunction:Function):void
		{
			
			try{
				//list[0];
				list.length;
			}catch(e:*){
				throw new Error("ListUtils: list not suitable"); 
			}
			
			if(list.length == 0){
				list[0] = item;
				return;
			}
			
			var min:uint = 0;
			var max:uint = list.length -1;
			var pivot:uint = (max + min) >> 1;
			
			var p0:Number =  compareFunction(item, list[min]);
			if(p0 <= 0)
			{
				list.splice(min, 0, item);
				return;
			}
			var p1:Number =  compareFunction(item, list[max]);
			if(p1 >= 0){
				list[list.length] =  item;
				return;
			}
			
			var found:Boolean = false;
			while(max-min > 1){
				p0 = compareFunction(item, list[pivot-1]);
				p1 = compareFunction(item, list[pivot]);
				if(p0 == 0 || p1 == 0)
				{
					found = true;
					break;
				}else if(p0 > 0 && p1 < 0){
					found = true;
					break;
				}
				
				if(p0 < 0){
					max = pivot;
				}else{
					min = pivot;
				}
				
				pivot = max + min >> 1;
			}
			
			if(!found){
				pivot += 1;
			}
			
			list.splice(pivot, 0, item);
		}
	}
}