package org.component.flixel 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import org.component.Component;
	import org.component.EntityManager;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Anchor extends Component 
	{
		public static const DEG_TO_RAD : Number = 0.0174532925;
		
		private var _id : String;
		private var _xoffset : Number;
		private var _yoffset : Number;
		
		public function Anchor(xoffset : Number = 0, yoffset : Number = 0, id : String = "") 
		{
			super();
			
			_xoffset = xoffset;
			_yoffset = yoffset;
		}
		
		public function get xOffset():Number 
		{
			return _xoffset;
		}
		
		public function get yOffset():Number
		{
			return _yoffset;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function getWorldPoint(object : FlxObject):FlxPoint
		{
			if (object is FlxSprite)
			{
				return getWorldPointSprite((FlxSprite)(object));
			} else {
				return getWorldPointObject(object);
			}
		}
		
		public function getWorldPointSprite(sprite : FlxSprite):FlxPoint
		{
			var point : FlxPoint = getOffsetSprite(sprite);
			point.x += sprite.x;
			point.y += sprite.y;
			
			return point;
		}
		
		public function getWorldPointObject(object : FlxObject):FlxPoint
		{
			var output : FlxPoint = new FlxPoint(0, 0);
			var offset : FlxPoint = getOffset(object);
			
			output.x = object.x + offset.x;
			output.y = object.y + offset.y;
			
			return output;
		}
		
		public function getOffset(object : FlxObject):FlxPoint 
		{
			if (object is FlxSprite)
			{
				return getOffsetSprite((FlxSprite)(object));
			} else {
				return getOffsetObject(object);
			}
		}
		
		public function getOffsetObject(object : FlxObject):FlxPoint
		{
			var xo : Number = _xoffset * object.width;
			var yo : Number = _yoffset * object.height;
			return new FlxPoint(xo, yo);
		}
		
		public function getOffsetSprite(sprite : FlxSprite):FlxPoint
		{
			var matrix : Matrix = new Matrix();
			
			matrix.translate( -sprite.origin.x, -sprite.origin.y);
			matrix.scale(sprite.scale.x, sprite.scale.y);
			matrix.rotate(sprite.angle * DEG_TO_RAD);
			matrix.translate(sprite.origin.x - sprite.offset.x, sprite.origin.y - sprite.offset.y);
			
			var xo : Number = (_xoffset * sprite.frameWidth);
			var yo : Number = (_yoffset * sprite.frameHeight);
			
			var point : Point = new Point(xo, yo);
			
			point = matrix.transformPoint(point);
			
			//point.x -= sprite.origin.x;
			//point.y -= sprite.origin.y;
			
			return new FlxPoint(point.x, point.y);
		}
		
		public function moveObjectViaAnchor(x : Number, y : Number, object : FlxObject):void
		{
			var offset : FlxPoint = getOffset(object);
			
			object.x = x - offset.x;
			object.y = y - offset.y;
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "id"))
			{
				_id = xml.id;
			}
			
			if (xmlElementExists(xml, "xOffset"))
			{
				_xoffset = parseFloat(xml.xOffset);
			}
			
			if (xmlElementExists(xml, "yOffset"))
			{
				_yoffset = parseFloat(xml.yOffset);
			}
		}
		
	}

}