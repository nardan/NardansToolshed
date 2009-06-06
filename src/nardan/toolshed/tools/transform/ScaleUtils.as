package nardan.toolshed.tools.transform
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class ScaleUtils 
	{
		/******************************************
		 * Static Constants & Variables
		 ******************************************/
		public static const ALIGN_TOP:String = "top";
		public static const ALIGN_BOTTOM:String = "bottom";
		public static const ALIGN_LEFT:String = "left";
		public static const ALIGN_RIGHT:String = "right";
		public static const ALIGN_CENTRE:String = "centre";
		/******************************************
		 * Static Methods
		 ******************************************/
		/**
		 * Scales a DisplayObject to fit into a Rectangle whilst maintaining aspect-ratio
		 * @param	clip: DisplayObject(clip to scale)
		 * @param	rect: Rectangle(to fit clip into)
		 * @param	vAlign: String(vertical alignment)
		 * @param	hAlign: String(horizontal alignment)
		 */
		public static function scaleIntoRect(clip:DisplayObject, rect:Rectangle, vAlign:String = "centre", hAlign:String = "centre"):void {
			var clipRatio:Number = clip.width / clip.height;
			var rectRatio:Number = rect.width / rect.height;
			
			if (clipRatio > rectRatio) { // treat as landscape
				clip.width = rect.width;
				clip.height = rect.width / clipRatio;
			}else { // treat as portrait
				clip.height = rect.height;
				clip.width = rect.height * clipRatio;
			}
			
			alignInRectInRect(clip, rect, vAlign, hAlign);
		}
		
		/**
		 * Forces a clip to fill a rectangle
		 * @param	clip
		 * @param	rect
		 */
		public static function fitToRect(clip:DisplayObject, rect:Rectangle):void
		{
			clip.width = rect.width;
			clip.height = rect.height
			alignInRectInRect(clip, rect, ALIGN_TOP, ALIGN_LEFT);
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
		 * @param	vAlign: String(verticl alignment)
		 * @param	hAlign: String (horizontal alignment)
		 */
		public function alignInRect(clip:DisplayObject, rect:Rectangle, vAlign:String = "centre", hAlign:String = "centre"):void
		{
			var tl:Point = clip.getBounds(clip).topLeft;
			
			var topOffset:Number = clip.y - tl.y;
			switch(vAlign.toLowerCase()) {
				case ALIGN_TOP:
					clip.x = rect.x + topOffset;
					break;
				case ALIGN_BOTTOM:
					clip.x = rect.x + topOffset +(rect.height - clip.height);
					break;
				case ALIGN_CENTRE:
				default:
					clip.x = rect.x + topOffset +(rect.height - clip.height) / 2;
			}
			
			var leftOffset:Number = clip.x - tl.x;
			switch(hAlign.toLowerCase()) {
				case ALIGN_LEFT:
					clip.y = rect.y + leftOffset;
					break;
				case ALIGN_RIGHT:
					clip.y = rect.y + leftOffset +(rect.width - clip.width);
					break;
				case ALIGN_CENTRE:
				default:
					clip.y = rect.y + leftOffset +(rect.width - clip.width) / 2;
			}
		}
		/******************************************
		 * Constructor
		 ******************************************/
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