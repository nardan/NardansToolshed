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
 
package nardan.toolshed.tools.transform
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A collection of static functions to apply some standard transformation tasks.
	 * 
	 * <br><b>TransformUtils ©2009 Alastair Brown. Licensed under the MIT license</b>
	 * @author real_nardan@hotmail.com
	 */
	public class TransformUtils 
	{
		/* **************************************** *
		 * Static Constants + Variables
		 * **************************************** */
		public static const ALIGN_TOP:Number = 0;
		public static const ALIGN_BOTTOM:Number = 1;
		public static const ALIGN_LEFT:Number = 0;
		public static const ALIGN_RIGHT:Number = 1;
		public static const ALIGN_CENTRE:Number = 0.5;
		
		/* **************************************** *
		 * Static Methods
		 * **************************************** */
		/**
		 * Scales a DisplayObject to fit into a Rectangle whilst maintaining aspect-ratio
		 * @param	clip: DisplayObject(clip to scale)
		 * @param	rect: Rectangle(to fit clip into)
		 * @param	vAlign: String(vertical alignment)
		 * @param	hAlign: String(horizontal alignment)
		 */
		public static function scaleIntoRect(clip:DisplayObject, rect:Rectangle, vAlign:Number = 0.5, hAlign:Number = 0.5):void {
			var clipRatio:Number = clip.width / clip.height;
			
			if (clipRatio > rect.width / rect.height) { // treat as landscape
				clip.width = rect.width;
				clip.height = rect.width / clipRatio;
			}else { // treat as portrait
				clip.height = rect.height;
				clip.width = rect.height * clipRatio;
			}
			
			alignInRect(clip, rect, vAlign, hAlign);
		}
		
		/**
		 * Scales a DisplayObject to fill a Rectangle whilst maintaining aspect-ratio, some parts of the clip map be outside of the rectangle
		 * @param	clip: DisplayObject(clip to scale)
		 * @param	rect: Rectangle(to fit clip into)
		 * @param	vAlign: String(vertical alignment)
		 * @param	hAlign: String(horizontal alignment)
		 */
		public static function scaleFillRect(clip:DisplayObject, rect:Rectangle, vAlign:Number = 0.5, hAlign:Number = 0.5):void {
			var clipRatio:Number = clip.width / clip.height;
			
			if (clipRatio > rect.width / rect.height) { // treat as landscape
				clip.height = rect.height;
				clip.width = rect.height * clipRatio;
				alignInRect(clip, rect, ALIGN_TOP, hAlign);
			}else { // treat as portrait
				clip.width = rect.width;
				clip.height = rect.width / clipRatio;
				alignInRect(clip, rect, vAlign, ALIGN_LEFT);
			}
			
			
		}
		
		/**
		 * Forces a clip to fill a rectangle
		 * @param	clip
		 * @param	rect
		 */
		public static function fillRect(clip:DisplayObject, rect:Rectangle):void
		{
			clip.width = rect.width;
			clip.height = rect.height
			alignInRect(clip, rect, ALIGN_TOP, ALIGN_LEFT);
		}
		
		/**
		 * Checks if clip would fit into a rectangle
		 * @param	clip
		 * @param	rect
		 * @return
		 */
		public static function fitsInRect(clip:DisplayObject, rect:Rectangle):Boolean
		{
			return Boolean(clip.width <= rect.width && clip.height <= rect.height);
		}
		
		/**
		 * Aligns a clip in a rectangle
		 * @param	clip: DisplayObject(clip to align)
		 * @param	rect: Rectangle(to align clip into)
		 * @param	vAlign: Number(verticl alignment)
		 * @param	hAlign: Number (horizontal alignment)
		 * @param	calcTopLeft : Boolean (True:calculate top-left before aligning, False: assume (0,0) top-left)
		 */
		public static function alignInRect(clip:DisplayObject, rect:Rectangle, vAlign:Number = 0.5, hAlign:Number = 0.5, calcTopLeft:Boolean = true):void
		{
			var tl:Point = (calcTopLeft) ? clip.getBounds(clip).topLeft : new Point();
			clip.y = rect.y + clip.y - tl.y + vAlign * (rect.height - clip.height);
			clip.x = rect.x + clip.x - tl.x + hAlign * (rect.width - clip.width);
		}
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
	}
	
}