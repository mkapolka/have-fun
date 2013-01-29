package org.component.flixel 
{
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.component.Entity;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FlxSpriteComponent extends FlxObjectComponent 
	{
		public static const FACE_RIGHT_MESSAGE : String = "face_right";
		public static const FACE_LEFT_MESSAGE : String = "face_left";
		
		protected var _sprite : FlxSprite;
		protected var _class : Class;
		protected var _spriteWidth : Number;
		protected var _spriteHeight : Number;
		protected var _spriteReverse : Boolean;
		protected var _spriteUnique : Boolean;
		protected var _spriteAnimated : Boolean;
		
		public function FlxSpriteComponent() 
		{
			super();
		}
		
		public function get sprite():FlxSprite
		{
			return _sprite;
		}
		
		public function set sprite(s : FlxSprite):void
		{			
			_sprite = s;
		}
		
		override public function set entity(entity : Entity):void
		{
			_entity = entity;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			
		}
		
		public function get spriteClass():Class
		{
			return _class;
		}
		
		public function get spriteWidth():Number
		{
			return _spriteWidth;
		}
		
		public function get spriteHeight():Number
		{
			return _spriteHeight;
		}
		
		public function get spriteReverse():Boolean
		{
			return _spriteReverse;
		}
		
		public function get spriteUnique():Boolean
		{
			return _spriteUnique;
		}
		
		public function get spriteAnimated():Boolean
		{
			return _spriteAnimated;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == FACE_LEFT_MESSAGE)
			{
				sprite.facing = FlxObject.LEFT;
			}
			
			if (message.type == FACE_RIGHT_MESSAGE)
			{
				sprite.facing = FlxObject.RIGHT;
			}
		}
		
		public function resetSprite():void
		{
			if (_class != null)
			{
				sprite.loadGraphic(_class, _spriteAnimated, _spriteReverse, _spriteWidth, _spriteHeight, _spriteUnique);
			} else {
				trace("FlxSpriteComponent.resetSprite() FAILED: No sprite class loaded.");
			}
		}
		
		protected function initializeSprite(simpleClass : Class = null):void
		{
			sprite = new FlxSprite(0, 0, null);
			if (simpleClass != null)
			{
				sprite.loadGraphic(simpleClass, _spriteAnimated, _spriteReverse, _spriteWidth, _spriteHeight, _spriteUnique);
				_class = simpleClass;
			}
			
			object = sprite;
		}
		
		protected function getSpriteClass(xml : XML):Class
		{
			return SpriteLibrary.getSpriteClass((String)(xml.spriteID));
		}
		
		protected function loadColorData(color : String):void
		{
			var u : uint = parseInt(color);
			_sprite.color = u;
			_sprite.alpha = ColorUtils.ARGBtoAlpha(u);
		}
		
		protected function loadScaleData(xml : XML):void
		{
			if (xmlElementExists(xml, "width"))
			{
				var sw : Number = parseFloat(xml.width);
				_sprite.scale.x = sw / _sprite.width;
				_sprite.offset.x = (_sprite.width - Math.abs(sw)) / 2;
			}
			
			if (xmlElementExists(xml, "height"))
			{
				var sh : Number = parseFloat(xml.height);
				_sprite.scale.y = sh / _sprite.height;
				_sprite.offset.y = (_sprite.height - Math.abs(sh)) / 2;
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			var spriteClass : Class = getSpriteClass(xml);
			_class = spriteClass;
			
			if (xmlElementExists(xml, "unique"))
			{
				_spriteUnique = extractXMLBoolean(xml.unique);
			}
			
			if (xmlElementExists(xml, "reverse"))
			{
				_spriteReverse = extractXMLBoolean(xml.reverse);
			}
			
			_spriteAnimated = false;
			_spriteWidth = 0;
			_spriteHeight = 0;
			
			initializeSprite(spriteClass);
			
			loadScaleData(xml);
			
			loadPositionData(xml);
			
			if (xmlElementExists(xml, "color"))
			{
				loadColorData(xml.color);
			}
		}
		
	}

}