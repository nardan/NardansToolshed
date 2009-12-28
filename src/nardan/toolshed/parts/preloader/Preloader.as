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

package nardan.toolshed.parts.preloader
{
	/**
	 * A singleton implementation of PreloadGroup
	 * 
	 * <br/><b>Preloader ©2009 Alastair Brown. Licensed under the MIT license</b>
	 * 
	 * @see PreloadGroup
	 * @author real_nardan@hotmail.com
	 * 
	 */
	public final class Preloader extends PreloadGroup
	{
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		/**
		 * The name of the group 
		 */
		public static const NAME:String = "PRELOADER";
		private static var instance:Preloader = null;
		
		/* **************************************** *
		* Static Methods
		* **************************************** */
		
		/**
		 * Implementation of singleton design-pattern 
		 * @return 
		 * 
		 */
		public static function getInstance():Preloader
		{
			if(instance ==  null){
				instance =  new Preloader(new SingletonEnforcer());
			}
			
			return instance;
		}
		/* **************************************** *
		* Properties
		* **************************************** */
		/* **************************************** *
		* Constructor
		* **************************************** */
		/**
		 * @private 
		 * @param enforcer
		 * 
		 */
		public function Preloader(enforcer:SingletonEnforcer)
		{
			super(NAME);
		}
	}
}
class SingletonEnforcer { };