package as2.ui 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxSpriteComponent;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ProgressBarComponent extends FlxSpriteComponent 
	{		
		private var _progressBarSprite : ProgressBarSprite;
		private var _width : int;
		
		public function ProgressBarComponent() 
		{
			super();
		}
		
		override protected function initializeSprite(simpleClass : Class = null):void
		{
			_progressBarSprite = new ProgressBarSprite(_width);
			sprite = _progressBarSprite;
			object = sprite;
		}
		
		override public function update():void
		{
			
		}
		
		override public function loadContent(xml : XML):void
		{
			if (xmlElementExists(xml, "width"))
			{
				_width = (int)(parseFloat(xml.width));
			}
			
			initializeSprite();
			
			loadPositionData(xml);
			
			if (xmlElementExists(xml, "color"))
			{
				loadColorData(xml.color);
			}
			
			if (xmlElementExists(xml, "progress"))
			{
				_progressBarSprite.progress = parseFloat(xml.progress);
				_progressBarSprite.initialProgress = _progressBarSprite.progress;
			}
			
			if (xmlElementExists(xml, "targetProgress"))
			{
				_progressBarSprite.targetProgress = parseFloat(xml.targetProgress);
			}
			
			
		}
		
	}

}