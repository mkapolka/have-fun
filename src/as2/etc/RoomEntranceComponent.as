package as2.etc 
{
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class RoomEntranceComponent extends Component 
	{
		private static var entrances : Array = new Array();
		
		private var _tagName : String;
		
		public static function getEntrance(name : String):RoomEntranceComponent
		{
			return entrances[name];
		}
		
		public function RoomEntranceComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function initialize():void
		{
			entrances[_tagName] = this;
		}
		
		override public function destroy():void
		{
			entrances[_tagName] = null;
		}
		
		public function get flxObjectComponent():FlxObjectComponent
		{
			return getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
		}
		
		public function get flxObject():FlxObject
		{
			return flxObjectComponent != null?flxObjectComponent.object:null;
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "entranceName"))
			{
				_tagName = xml.entranceName;
			}
		}
		
	}

}