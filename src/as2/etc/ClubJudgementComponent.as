package as2.etc 
{
	import as2.AS2GameData;
	import as2.AS2SoundManager;
	import as2.data.PersonData;
	import as2.ui.ProgressPopupComponent;
	import org.component.Component;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ClubJudgementComponent extends Component 
	{
		public static const UPVOTE_ICON : int = 11;
		public static const DOWNVOTE_ICON : int = 12;
		
		private var _votes : int = 0;
		private var _karma : int = 0;
		private var _cool : Boolean = false;
		
		public function ClubJudgementComponent() 
		{
			super();
			
			_votes = 20 + Math.floor(Math.random() * 30);
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			AS2GameData.data.club_visited = 1;
			
			var p : PersonData = AS2GameData.playerData;
			var coolness : int = (AS2GameData.date - p.upperClothing.dateBought) + (AS2GameData.date - p.lowerClothing.dateBought);
			_cool = coolness < 3;
			
			FlxG.playMusic(AS2SoundManager.CLUB_MP3, 5);
		}
		
		override public function destroy():void {
			super.destroy();
			
			FlxG.music.stop();
		}
		
		override public function update():void
		{
			super.update();
			
			if (_votes > 0 && Math.random() < 1 / 30)
			{
				if (Math.random() < (_cool?.7:.4))
				{
					_karma += 1;
					ProgressPopupComponent.showSimple("You received an Upvote!", UPVOTE_ICON);
					AS2SoundManager.playSound(AS2SoundManager.POINTS_MP3);
				} else {
					_karma -= 1;
					ProgressPopupComponent.showSimple("You received an Downvote!", DOWNVOTE_ICON);
					AS2SoundManager.playSound(AS2SoundManager.DOWN_MP3);
				}
				
				_votes -= 1;
				
				if (_votes <= 0)
				{
					ProgressPopupComponent.showSimple("Your Score:" + _karma, 1);
					
					if (_karma > 0)
					{
						AS2GameData.playerData.fun += 10 * _karma;
					}
				}
			}
		}
		
	}

}