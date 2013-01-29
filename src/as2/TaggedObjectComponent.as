package as2 
{
	import org.component.Component;
	import org.component.Entity;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class TaggedObjectComponent extends Component 
	{
		public static var TAGGED_OBJECTS : Vector.<TaggedObjectComponent> = new Vector.<TaggedObjectComponent>();
		
		private var _tag : String;
		
		public static function addTaggedObject(object : TaggedObjectComponent):void
		{
			TAGGED_OBJECTS.push(object);
		}
		
		public static function getObjectByTag(tag : String):Entity
		{
			for each (var toc : TaggedObjectComponent in TAGGED_OBJECTS)
			{
				if (toc.tag == tag)
				{
					return toc.entity;
				}
			}
			
			return null;
		}
		
		public static function removeTaggedObject(toc : TaggedObjectComponent):void
		{
			TAGGED_OBJECTS.splice(TAGGED_OBJECTS.indexOf(toc), 1);
		}
		
		public function TaggedObjectComponent()
		{
			super();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			removeTaggedObject(this);
		}
		
		public function get tag():String
		{
			return _tag;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			addTaggedObject(this);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "tagID"))
			{
				_tag = xml.tagID;
			}
		}
		
	}

}