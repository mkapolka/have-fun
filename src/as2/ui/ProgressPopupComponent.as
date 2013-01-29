package as2.ui 
{
	import as2.flixel.AS2FlxTextComponent;
	import as2.RoomManager;
	import org.component.Component;
	import org.component.Entity;
	import org.component.EntityManager;
	import org.component.flixel.AnimatedFlxSpriteComponent;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.component.Template;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ProgressPopupComponent extends Component 
	{
		public static const NO_ICON : uint = 0;
		public static const FACEBOOK_ICON : uint = 1;
		public static const EXCLAMATION_ICON : uint = 2;
		
		public static const ICON_NAME : String = "Icon";
		public static const TITLE_NAME : String = "Title";
		public static const PROGRESS_NAME : String = "ProgressBar";
		public static const TEMPLATE_NAME : String = "popup";
		public static const SPAWNER_TAG : String = "progressSpawner";
		
		public static const SIMPLE_TEMPLATE_NAME : String = "simple_popup";
		
		public static const VISIBLE_TIME : Number = 7;
		public static const PADDING : Number = 10;
		
		private var _iconSprite : AnimatedFlxSpriteComponent;
		
		private var _initialY : Number = 0;
		private var _targetY : Number = 0;
		
		private var _life : Number = VISIBLE_TIME;
		
		private static var _progressBars : Vector.<Entity> = new Vector.<Entity>();
		
		private static function addProgressBar(entity : Entity):void
		{
			_progressBars.push(entity);
		}
		
		private static function removeProgressBar(entity : Entity):void
		{
			var i : int = _progressBars.indexOf(entity);
			if (i != -1)
			{
				_progressBars.splice(i, 1);
			}
		}
		
		public static function showProgressBar(title : String, titleIcon : uint, progress : Number, maxProgress : Number):void
		{
			var popup : Entity = Template.createEntityViaTemplate(TEMPLATE_NAME, true);
			
			var ppc : ProgressPopupComponent = popup.getComponentByType(ProgressPopupComponent) as ProgressPopupComponent;
			var object : FlxObject = ppc.flxObject;
			ppc.setIcon(titleIcon);
			ppc.setTitle(title);
			
			ppc.progressBar.initialProgress = progress;
			ppc.progressBar.targetProgress = maxProgress;
			ppc.progressBar.progress = progress;
			
			if (object != null)
			{
				object.x = PADDING;
				object.y = FlxG.height + object.height;
				
				updatePopupTargets();
			}
		}
		
		public static function showSimple(title : String, titleIcon : uint):void
		{
			var popup : Entity = Template.createEntityViaTemplate(SIMPLE_TEMPLATE_NAME, true);
			
			var ppc : ProgressPopupComponent = popup.getComponentByType(ProgressPopupComponent) as ProgressPopupComponent;
			ppc.setIcon(titleIcon);
			ppc.setTitle(title);
			
			var object : FlxObject = ppc.flxObject;
			if (object != null)
			{
				object.x = PADDING;
				object.y = FlxG.height + object.height;
				updatePopupTargets();
			}
		}
		
		public static function updatePopupTargets():void
		{
			for (var i : int = 0; i < _progressBars.length; i++)
			{
				var entity : Entity = _progressBars[_progressBars.length - i - 1];
				var ppc : ProgressPopupComponent = (ProgressPopupComponent)(entity.getComponentByType(ProgressPopupComponent));
				var object : FlxObject = ppc.flxObject;
				ppc._targetY = FlxG.height - (object.height * (i + 1)) - (PADDING * (i + 1));
			}
		}
		
		public function ProgressPopupComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function destroy():void 
		{
			removeProgressBar(entity);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_initialY = flxObject.y;
			
			addProgressBar(entity);
		}
		
		override public function resolve():void
		{
			_iconSprite = entity.getChildByName(ICON_NAME).getComponentByType(AnimatedFlxSpriteComponent) as AnimatedFlxSpriteComponent;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == RoomManager.ROOM_LEAVE_MESSAGE)
			{
				var hide : Message = new Message();
				hide.sender = this;
				hide.type = FlxObjectComponent.HIDE;
				
				entity.sendMessage(hide);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var o : FlxObject = flxObject;
			if (o != null && o.y != _targetY)
			{
				var dy : Number = o.y - _targetY;
				//dy /= 2;
				dy *= FlxG.elapsed * 5;
				
				o.y -= dy;
			}
			
			_life -= FlxG.elapsed;
			
			if (_life < 0)
			{
				entity.destroy();
			}
		}
		
		public function get flxObjectComponent():FlxObjectComponent
		{
			return getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
		}
		
		public function get flxObject():FlxObject
		{
			var c : FlxObjectComponent = flxObjectComponent;
			
			return c != null?c.object:null;
		}
		
		public function get icon():AnimatedFlxSpriteComponent
		{
			var child : Entity = entity.getChildByName(ICON_NAME);
			
			if (child != null)
			{
				return child.getComponentByType(AnimatedFlxSpriteComponent) as AnimatedFlxSpriteComponent;
			} else {
				return null;
			}
		}
		
		public function setIcon(index : uint):void
		{
			var icon : AnimatedFlxSpriteComponent = icon;
			
			icon.sprite.frame = index;
			icon.sprite.dirty = true;
		}
		
		public function get titleTextComponent():FlxTextComponent
		{
			var child : Entity = entity.getChildByName(TITLE_NAME);
			
			if (child != null)
			{
				return child.getComponentByType(FlxTextComponent) as FlxTextComponent;
			} else {
				return null;
			}
		}
		
		public function setTitle(s : String):void
		{
			var text : FlxTextComponent = titleTextComponent;
			
			if (text != null)
			{
				text.setText(s);
			}
		}
		
		public function get progressBarComponent():ProgressBarComponent
		{
			var child : Entity = entity.getChildByName(PROGRESS_NAME);
			
			if (child != null)
			{
				return child.getComponentByType(ProgressBarComponent) as ProgressBarComponent;
			} else {
				return null;
			}
		}
		
		public function get progressBar():ProgressBarSprite
		{
			var comp : ProgressBarComponent = progressBarComponent;
			
			if (comp != null)
			{
				return comp.sprite as ProgressBarSprite;
			} else {
				return null;
			}
		}
		
	}

}