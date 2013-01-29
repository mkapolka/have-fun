package as2.flixel 
{
	import as2.character.CharacterComponent;
	import as2.data.Clothing;
	import org.component.flixel.SpriteLibrary;
	import org.component.Message;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class PersonMaskComponent extends MaskComponent 
	{
		public static const TOP_MASK_COLOR : uint = 0xFFFF0000;
		public static const BOTTOM_MASK_COLOR : uint = 0xFF0000FF;
		
		public static const DEFAULT_MASK_WIDTH : uint = 100;
		public static const DEFAULT_MASK_HEIGHT :  uint = 100;
		public static const DEFAULT_MASK_ID : String = "test_pattern";
		
		public static const UPDATE_MASK_MESSAGE : String = "update_mask";
		
		public function PersonMaskComponent() 
		{
			super();
			
			addRequisiteComponent(CharacterComponent);
		}
		
		public function get characterComponent():CharacterComponent
		{
			return getSiblingComponent(CharacterComponent) as CharacterComponent;
		}
		
		override public function initialize():void
		{
			super.initialize();
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			updateClothes();
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == UPDATE_MASK_MESSAGE)
			{
				updateClothes();
			}
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function updateClothes():void
		{
			var cc : CharacterComponent = characterComponent;
			
			if (cc != null)
			{
				var clothingTop : Clothing = cc.data.upperClothing;
				if (clothingTop != null)
				{
					_masks[0].frame = clothingTop.texture;
				}
				
				var clothingBottom : Clothing = cc.data.lowerClothing;
				if (clothingBottom != null)
				{
					_masks[1].frame = clothingBottom.texture;
				}
			}
			
			//calcFrame();
			_dirty = true;
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			//Load that, the ignore it
			_masks[0].color = TOP_MASK_COLOR;
			_masks[1].color = BOTTOM_MASK_COLOR;
			
			_maskWidth = DEFAULT_MASK_WIDTH;
			_maskHeight = DEFAULT_MASK_HEIGHT;
			_maskClass = SpriteLibrary.getSpriteClass(DEFAULT_MASK_ID);
		}
		
	}

}