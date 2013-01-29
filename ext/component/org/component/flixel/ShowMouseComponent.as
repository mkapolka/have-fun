package org.component.flixel 
{
	import flash.ui.Mouse;
	import org.component.Component;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ShowMouseComponent extends Component 
	{		
		public function ShowMouseComponent() 
		{
			super();
		}
		
		private function hideSystemMouse():void
		{
			Mouse.hide();
		}
		
		private function showSystemMouse():void
		{
			Mouse.show();
		}
		
		private function hideFlixelMouse():void
		{
			FlxG.mouse.hide();
		}
		
		private function showFlixelMouse(c : Class):void
		{
			FlxG.mouse.show(c);
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			var systemMouse : Boolean = false;
			var showMouse : Boolean = false;
			var flixelMouseClass : Class = null;
			
			if (xmlElementExists(xml, "systemMouse"))
			{
				systemMouse = extractXMLBoolean(xml.systemMouse);
			}
			
			if (xmlElementExists(xml, "showMouse"))
			{
				showMouse = extractXMLBoolean(xml.showMouse);
			}
			
			if (xmlElementExists(xml, "flixelMouseClass"))
			{
				if (xml.flixelMouseClass != "")
				{
					flixelMouseClass = SpriteLibrary.getSpriteClass(xml.flixelMouseClass);
				}
			}
			
			if (systemMouse)
			{
				if (showMouse)
				{
					showSystemMouse();
					hideFlixelMouse();
				} else {
					hideSystemMouse();
					hideFlixelMouse();
				}
			} else {
				if (showMouse)
				{
					showFlixelMouse(flixelMouseClass);
					hideSystemMouse();
				} else {
					hideFlixelMouse();
					hideSystemMouse();
				}
			}
		}
		
	}

}