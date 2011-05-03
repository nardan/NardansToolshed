/**
 * Nardan's Tool-Box
 * Copyright (c) 2010 Alastair Brown alastair@codecharmer.com
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
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A collection of static functions to apply some standard transformation tasks.
	 * 
	 * <br/><b>TransformUtils ©2011 Alastair Brown. Licensed under the MIT license</b>
	 * @author alastair@codecharmer.com
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
		
		public static const DEG_TO_RAD:Number =  Math.PI / 180;
		public static const RAD_TO_DEG:Number =  180 /  Math.PI;
		
		/* **************************************** *
		 * Static Methods
		 * **************************************** */
		/**
		 * Scales an Object to fit into a Rectangle whilst maintaining aspect-ratio
		 * @param	clip: left typeless so it can apply to DisplayObject or Rectangle.
		 * @param	rect: Rectangle(to fit clip into)
		 * @param	vAlign: String(vertical alignment)
		 * @param	hAlign: String(horizontal alignment)
		 */
		public static function scaleIntoRect(clip:*, rect:Rectangle, vAlign:Number = 0.5, hAlign:Number = 0.5):void {
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
		 * Scales an Object to fill a Rectangle whilst maintaining aspect-ratio, some parts of the clip map be outside of the rectangle
		 * @param	clip: left typeless so it can apply to DisplayObject or Rectangle.
		 * @param	rect: Rectangle(to fit clip into)
		 * @param	vAlign: String(vertical alignment)
		 * @param	hAlign: String(horizontal alignment)
		 */
		public static function scaleFillRect(clip:*, rect:Rectangle, vAlign:Number = 0.5, hAlign:Number = 0.5):void {
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
		 * @param	clip: left typeless so it can apply to DisplayObject or Rectangle.
		 * @param	rect: Rectangle(to fit clip into)
		 */
		public static function fillRect(clip:*, rect:Rectangle):void
		{
			clip.width = rect.width;
			clip.height = rect.height
			alignInRect(clip, rect, ALIGN_TOP, ALIGN_LEFT);
		}
		
		/**
		 * Checks if clip would fit into a rectangle
		 * @param	clip: left typeless so it can apply to DisplayObject or Rectangle.
		 * @param	rect: Rectangle(to fit clip into)
		 * @return
		 */
		public static function fitsInRect(clip:*, rect:Rectangle):Boolean
		{
			return Boolean(clip.width <= rect.width && clip.height <= rect.height);
		}
		
		/**
		 * Aligns a clip in a rectangle
		 * @param	clip: left typeless so it can apply to DisplayObject or Rectangle.
		 * @param	rect: Rectangle(to align clip into)
		 * @param	vAlign: Number(vertical alignment)
		 * @param	hAlign: Number (horizontal alignment)
		 * @param	calcTopLeft : Boolean (True:calculate top-left before aligning, False: assume (0,0) top-left)
		 */
		public static function alignInRect(clip:*, rect:Rectangle, vAlign:Number = 0.5, hAlign:Number = 0.5, calcTopLeft:Boolean = true):void
		{
			var tl:Point = (calcTopLeft && clip.getBounds) ? clip.getBounds(clip.parent).topLeft : new Point();
			clip.y = rect.y + clip.y - tl.y + vAlign * (rect.height - clip.height);
			clip.x = rect.x + clip.x - tl.x + hAlign * (rect.width - clip.width);
		}
		
		
		/**
		 * Rotates a <code>clip</code> around a point in it's own coordinate space, by a given <code>angle</code>.
		 *  
		 * @param clip : The DisplayObject to rotate.
		 * @param angle : The angle to rotate the <code>clip</code> by in radians.
		 * @param point : The point to rotate around.
		 * 
		 */
		public static function rotateAroundInternalPoint(clip:DisplayObject, angle:Number, point:Point):void
		{
			var coords:DisplayObjectContainer =  (clip is DisplayObjectContainer) ? (clip as DisplayObjectContainer) : clip.parent;
			rotateAroundExternalPoint(clip, angle, point, coords);
		}
		
		/**
		 * Rotates a <code>clip</code> around a point in <code>coords</code>'s coordinate space, by a given <code>angle</code>.
		 * 
		 * @param clip : The DisplayObject to rotate.
		 * @param angle : The angle to rotate the <code>clip</code> by in radians.
		 * @param point : The point to rotate around.
		 * @param coords: The local coordinate space of <code>point</code>.
		 * 
		 */
		public static function rotateAroundExternalPoint(clip:DisplayObject, angle:Number, point:Point, coords:DisplayObjectContainer):void
		{
			if(coords != clip.parent) point = clip.parent.globalToLocal(coords.localToGlobal(point));
			var m:Matrix = clip.transform.matrix;
			//m.transformPoint(point);
			m.translate(-point.x, -point.y);
			m.rotate(angle);
			m.translate(point.x, point.y);
			clip.transform.matrix =  m;
		}
		
		/**
		 * Rotates a <code>clip</code> around a point in it's own coordinate space, to a given <code>angle</code>.
		 * 
		 * @param clip : The DisplayObject to rotate.
		 * @param angle : The angle to rotate the <code>clip</code> to in radians.
		 * @param point : The point to rotate around.
		 * 
		 */
		public static function setAngleAroundInternalPoint(clip:DisplayObject, angle:Number, point:Point):void
		{
			var coords:DisplayObjectContainer =  (clip is DisplayObjectContainer) ? (clip as DisplayObjectContainer) : clip.parent;
			setAngleAroundExternalPoint(clip, angle, point, coords);
		}
		
		/**
		 * Rotates a <code>clip</code> around a point in <code>coords</code>'s coordinate space, to a given <code>angle</code>.
		 * 
		 * @param clip : The DisplayObject to rotate.
		 * @param angle : The angle to rotate the <code>clip</code> to in radians.
		 * @param point : The point to rotate around.
		 * @param coords: The local coordinate space of <code>point</code>.
		 * 
		 */
		public static function setAngleAroundExternalPoint(clip:DisplayObject, angle:Number, point:Point, coords:DisplayObjectContainer):void
		{
			if(coords != clip.parent) point = clip.parent.globalToLocal(coords.localToGlobal(point));
			var m:Matrix = clip.transform.matrix;
			var ang:Number = clip.rotation * DEG_TO_RAD;
			angle = angle - ang;
			rotateAroundExternalPoint(clip, angle, point, clip.parent);
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