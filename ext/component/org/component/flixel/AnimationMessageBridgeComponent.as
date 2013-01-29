package org.component.flixel 
{
	import org.component.Component;
	import org.component.flixel.AnimatedFlxSpriteComponent;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AnimationMessageBridgeComponent extends Component 
	{
		
		protected var _links : Array = new Array();
		protected var _afc : AnimatedFlxSpriteComponent;
		
		public function AnimationMessageBridgeComponent() 
		{
			super();
			
			addRequisiteComponent(AnimatedFlxSpriteComponent);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_afc = (AnimatedFlxSpriteComponent)(getSiblingComponent(AnimatedFlxSpriteComponent));
		}
		
		override public function receiveMessage(message : Message):void
		{
			var o : Object = _links[message.type];
			
			if (o != null)
			{
				_afc.sprite.play((String)(o));
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			var links : Array = extractArray(xml.bridges);
			
			for each (var s : String in links)
			{
				var a : Array = s.split(" ");
				
				if (a.length < 2) continue;
				
				_links[a[0]] = a[1];
			}
		}
		
	}

}