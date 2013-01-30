package org.component.flixel 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AnimatedFlxSpriteComponent extends FlxSpriteComponent 
	{
		protected var _frameRate : int;
		protected var _loop : Boolean;
		protected var _startingAnimation : String;
		
		public function AnimatedFlxSpriteComponent() 
		{
			super();
		}
		
		private function animationCallback(aniName : String, frameNumber : int, frameIndex : int):void
		{
			
		}
		
		override public function resetSprite():void
		{
			sprite.loadGraphic(_class, true, _spriteReverse, _spriteWidth, _spriteHeight, _spriteUnique);
			sprite.play(_startingAnimation, true);
		}
		
		override public function loadContent(xml : XML):void
		{
			initializeSprite();
			
			var spriteClass : Class = getSpriteClass(xml);
			_class = spriteClass;
			
			if (xmlElementExists(xml, "spriteWidth"))
			{
				_spriteWidth = parseFloat(xml.spriteWidth);
			}
			
			if (xmlElementExists(xml, "spriteHeight"))
			{
				_spriteHeight = parseFloat(xml.spriteHeight);
			}
			
			if (xmlElementExists(xml, "reverseSprite"))
			{
				_spriteReverse = stringToBool(xml.reverseSprite);
			}
			
			if (xmlElementExists(xml, "unique"))
			{
				_spriteUnique = stringToBool(xml.unique);
			}
			
			_frameRate = xml.frameRate;
			_loop = stringToBool(xml.loop);
			
			if (spriteClass == null)
			{
				trace("No sprite found for id: " + xml.spriteID + " in component " + name);
				return;
			}
			
			sprite.loadGraphic(spriteClass, true, _spriteReverse, _spriteWidth, _spriteHeight, _spriteUnique);
			
			//load animations
			var animations : Array = extractArray(xml.animations);
			
			for (var i : int = 0; i < animations.length; i++)
			{
				var animation : String = animations[i];
				var parts : Array = animation.split(" ");
				
				var looped : Boolean = true;
				
				var frames : Array = new Array();
				
				for (var j : int = 1; j < parts.length; j++)
				{
					if (parts[j] == "noloop")
					{
						looped = false;
						continue;
					}
					
					if (parts[j] == "loop")
					{
						looped = true;
						continue;
					}
					
					if (parts[j] == "fr")
					{
						_frameRate = parts[j + 1];
						j++;
						continue;
					}
					
					frames.push(parseInt(parts[j]));
				}
				
				if (parts.length <= 1) continue;
				
				sprite.addAnimation(parts[0], frames, _frameRate, looped);
				//sprite.addAnimationCallback(animationCallback);
			}
			
			loadScaleData(xml);
			loadPositionData(xml);
			
			
			if (xmlElementExists(xml, "startingAnimation"))
			{
				_startingAnimation = xml.startingAnimation;
				sprite.play(_startingAnimation);
			}
		}
		
	}

}