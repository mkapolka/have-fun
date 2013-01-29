package as2.etc 
{
	import as2.AS2GameData;
	import as2.character.CharacterNavigationComponent;
	import as2.data.CoffeeAppData;
	import org.component.Component;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CafeAnimationComponent extends Component 
	{
		private var hasCoffee : Boolean = false;
		
		public function CafeAnimationComponent() 
		{
			super();
			
			addRequisiteComponent(CharacterNavigationComponent);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			AS2GameData.hasCoffee = false;
		}
		
		public function get characterNavigationComponent():CharacterNavigationComponent
		{
			return getSiblingComponent(CharacterNavigationComponent) as CharacterNavigationComponent;
		}
		
		override public function update():void
		{
			if (!hasCoffee)
			{
				if (AS2GameData.hasCoffee)
				{
					hasCoffee = true;
					
					var cnc : CharacterNavigationComponent = characterNavigationComponent;
					cnc.walkingMessage = "holdwalk";
					cnc.stoppedMessage = "holdstand";
					
					var m : Message = new Message();
					m.type = "holdstand";
					m.sender = this;
					entity.sendMessage(m);
				}
			}
		}
		
	}

}