package as2.data 
{
	import as2.AS2GameData;
	import org.component.Component;
	/**
	 * If this component is present in a room then the player will receive credit
	 * in the Walking App whenever they walk to this room. 
	 * @author Marek Kapolka
	 */
	public class WalkingEntranceComponent extends Component
	{
		public static const WALKING_TIME : int = 30;
		
		public function WalkingEntranceComponent() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			//WalkingAppData.points += (Math.random() * 50) + 475;
			WalkingAppData.points += WalkingAppData.builtUpPoints;
			if (WalkingAppData.builtUpPoints > 0)
			{
				AS2GameData.dayTime -= WALKING_TIME;
			}
			
			WalkingAppData.builtUpPoints = 0;			
		}
		
	}

}