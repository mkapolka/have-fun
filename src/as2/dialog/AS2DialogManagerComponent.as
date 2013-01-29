package as2.dialog 
{
	import as2.AS2CursorComponent;
	import as2.AS2GameData;
	import as2.Assignment2State;
	import as2.data.DeodorantAppData;
	import as2.data.GymAppData;
	import as2.data.PersonData;
	import as2.flixel.MaskMessage;
	import as2.RoomManager;
	import as2.SmartphoneButtonComponent;
	import org.component.Component;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogManagerComponent;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogPartner;
	import org.component.dialog.DialogResponse;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2DialogManagerComponent extends DialogManagerComponent 
	{
		public static const HAS_SMARTPHONE_MESSAGE : String = "smartphone";
		public static const NO_SMARTPHONE_MESSAGE : String = "nosmartphone";
		
		public static const FADE_MESSAGE : String = "fade";
		public static const UNFADE_MESSAGE : String = "unfade";
		
		public static const SHADE_NAME : String = "Shade";
		public static const SHADE_SPEED : Number = 1;
		
		private var _open : Boolean = false;
		private var _shadeAlphaTarget : Number = 0;
		private var _storedInterjection : String;
		private var _interjectionsDone : Vector.<String> = new Vector.<String>();
		
		public function AS2DialogManagerComponent() 
		{
			super();
		}
		
		public function sendOpenTrigger():void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = CloseAnimationComponent.OPEN_TRIGGER;
			entity.sendMessage(message);
		}
		
		public function sendCloseTrigger():void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = CloseAnimationComponent.CLOSE_TRIGGER;
			entity.sendMessage(message);
		}
		
		override public function receiveMessage(message : Message):void
		{			
			if (message.type == DialogMessage.CLOSE_DIALOG)
			{
				sendCloseTrigger();
				
				_open = false;
				
				var mouseEntity : Entity = Assignment2State.getMouseEntity();
				(AS2CursorComponent)(mouseEntity.getComponentByType(AS2CursorComponent)).mode = AS2CursorComponent.MODE_GAME;
				
				SmartphoneButtonComponent.setVisibleAndEnabled(true);
				
				_interjectionsDone.splice(0, _interjectionsDone.length);
			}
			
			if (message.type == DialogMessage.OPEN_DIALOG)
			{
				if (!_open)
				{
					sendOpenTrigger();
				}
				
				_open = true;
				
				var smMessage : Message = new Message();
				smMessage.sender = this;
				
				if (AS2GameData.hasSmartphone)
				{
					smMessage.type = HAS_SMARTPHONE_MESSAGE;
				} else {
					smMessage.type = NO_SMARTPHONE_MESSAGE;
				}
				
				entity.sendMessage(smMessage);
				
				mouseEntity = Assignment2State.getMouseEntity();
				(AS2CursorComponent)(mouseEntity.getComponentByType(AS2CursorComponent)).mode = AS2CursorComponent.MODE_DIALOG;
				
				//Smartphone Button
				SmartphoneButtonComponent.setVisibleAndEnabled(false);
			}
			
			if (message.type == RoomManager.ROOM_LEAVE_MESSAGE)
			{
				var shade : Entity = entity.getChildByName(SHADE_NAME);
				var flxo : FlxSpriteComponent = shade.getComponentByType(FlxSpriteComponent) as FlxSpriteComponent;
				flxo.sprite.alpha = 0;
				_shadeAlphaTarget = 0;
				
				var m : Message = new Message();
				m.type = DialogMessage.CLOSE_DIALOG;
				m.sender = this;
				entity.sendMessage(m);
			}
			
			if (message.type == FADE_MESSAGE)
			{
				_shadeAlphaTarget = 1;
			}
			
			if (message.type == UNFADE_MESSAGE)
			{
				_shadeAlphaTarget = 0;
			}
			
			super.receiveMessage(message);
		}
		
		override public function update():void
		{
			super.update();
			
			var shade : Entity = entity.getChildByName(SHADE_NAME);
			var flxo : FlxSpriteComponent = shade.getComponentByType(FlxSpriteComponent) as FlxSpriteComponent;
			
			if (flxo.sprite.alpha != _shadeAlphaTarget)
			{
				var d : Number = FlxG.elapsed * SHADE_SPEED;
				
				var a : Number = flxo.sprite.alpha - _shadeAlphaTarget;
				
				if (Math.abs(a) < d)
				{
					flxo.sprite.alpha = _shadeAlphaTarget;
				} else {
					if (a > 0)
					{
						flxo.sprite.alpha -= d;
					} else {
						flxo.sprite.alpha += d;
					}
				}
			}
			
			flxo.sprite.visible = (flxo.sprite.alpha > 0);
		}
		
		override public function query(query : String):void
		{
			var dr : DialogResponse = _partner.query(query);
			
			if (dr == null) return;
			
			/**
			 * If there is an "opendialog" result, switch the dialog over to someone else
			 * This needs to happen here because if it happens in the DialogResponse it will be
			 * overwritten by the rest of this function
			 */
			var results : Vector.<String> = DialogPartner.parseFunctions(dr.results);
			
			var dont_finish : Boolean = false;
			
			var hide_goodbye : Boolean = false;
			
			for each (var s : String in results)
			{
				var a : Array = s.split(" ");
				
				if (a[0] == "opendialog")
				{
					var odm : DialogMessage = new DialogMessage();
					odm.type = DialogMessage.OPEN_DIALOG;
					var partner : AS2DialogPartner;
					
					//Which partner to use
					switch (a[1])
					{
						case "smartphone":
							partner = new SmartphoneDialogPartner();
						break;
						
						case "character":
							var pd : PersonData = AS2GameData.loadPerson(a[2]);
							partner = new CharacterDialogPartner(pd);
						break;
						
						case "dresser":
							partner = new DresserDialogPartner();
						break;
						
						case "default":
						default:
							partner = new AS2DialogPartner();
							partner.id = a[2];
							partner.name = a[3];
							partner.portraitID = a[4];
						break;
					}
					
					ConversationLibrary.buildDialogPartner(partner);
					odm.partner = partner;
					entity.sendMessage(odm);
					
					dont_finish = true;
					continue;
				}
				
				//usage: query topic_name
				if (a[0] == "query")
				{
					this.query(a[1]);
					dont_finish = true;
					continue;
				}
				
				if (a[0] == "interject")
				{
					if (_interjectionsDone.indexOf(a[1]) == -1)
					{
						_interjectionsDone.push(a[1]);
						
						a.splice(0, 1);
						
						if (doInterjection(query, a))
						{
							dont_finish = true;
						}
						
						continue;
					}
				}
				
				if (a[0] == "interjection_continue")
				{
					this.query(_storedInterjection);
					dont_finish = true;
					continue;
				}
				
				//usage : maskperson person_id
				if (a[0] == "maskperson")
				{
					var person : PersonData = AS2GameData.loadPerson(a[1]);
					var maskMessage : MaskMessage = new MaskMessage();
					maskMessage.type = MaskMessage.SET_FRAME;
					
					if (person.upperClothing != null)
					{
						maskMessage.maskIndex = 0;
						maskMessage.frameIndex = person.upperClothing.texture;
						entity.sendMessage(maskMessage);
					}
					
					if (person.lowerClothing != null)
					{
						maskMessage.maskIndex = 1;
						maskMessage.frameIndex = person.lowerClothing.texture;
						entity.sendMessage(maskMessage);
					}
				}
				
				if (a[0] == "setskin")
				{
					var skinMessage : Message = new Message();
					skinMessage.sender = this;
					switch (a[1])
					{
						case "smartphone":
							skinMessage.type = HAS_SMARTPHONE_MESSAGE;
							entity.sendMessage(skinMessage);
						break;
						
						case "dialog":
							skinMessage.type = NO_SMARTPHONE_MESSAGE;
							entity.sendMessage(skinMessage);
						break;
						
						default:
							throw new Error("Invalid skin type specified to dialog manager");
						break;
					}
					
					sendOpenTrigger();
				}
				
				if (a[0] == "advancetime")
				{
					AS2GameData.dayTime -= parseInt(a[1]);
					if (AS2GameData.dayTime <= 0)
					{
						dont_finish = true;
					}
					
					continue;
				}
				
				if (a[0] == "hidegoodbye")
				{
					hide_goodbye = true;
				}
				
				if (a[0] == "setmask")
				{
					maskMessage = MaskMessage.makeSetMaskMessage(a[1], a[2]);
					entity.sendMessage(maskMessage);
				}
			}
			
			if (doSpecialInterjections(_partner, query))
			{
				_storedInterjection = query;
				dont_finish = true;
			}
			
			if (dont_finish) return;
				
			var out_message : DialogMessage = new DialogMessage();
			out_message.sender = this;
			out_message.type = DialogMessage.SHOW_RESPONSE;
			out_message.response = dr;
			
			entity.sendMessage(out_message);
			
			if (hide_goodbye)
			{
				var m : Message = new Message();
				m.sender = null;
				m.type = GoodbyeOptionComponent.HIDE_CLOSE_TEXT;
				entity.sendMessage(m);
			}
		}
		
		public function doInterjection(oldQuery : String, array : Array):Boolean
		{
			_storedInterjection = oldQuery;
			
			switch (array[0])
			{
				case "smartphone_houseleave_nag":
					if (!DeodorantAppData.usedToday && AS2GameData.currentLocation == "home")
					{
						query("houseleave_nag_deodorant");
						return true;
					}
					
					var p : PersonData = AS2GameData.playerData;
					
					if (p.lowerClothing == AS2GameData.lastLower && p.upperClothing == AS2GameData.lastUpper)
					{
						query("houseleave_nag_clothing");
						return true;
					}
					
					var age : int = (AS2GameData.date - p.lowerClothing.dateBought) + (AS2GameData.date - p.upperClothing.dateBought);
					
					if (age > 5)
					{
						query("houseleave_nag_clotheslame");
						return true;
					}
				break;
				
				case "bro_lifting_nag":
					if (AS2GameData.hasApp("gym") && !GymAppData.workedOutToday())
					{
						query("bro_lifting_nag");
					}
				break;
			}
			
			return false;
		}
		
		public function doSpecialInterjections(partner : DialogPartner, query : String):Boolean
		{
			if (partner is CharacterDialogPartner)
			{
				var cdp : CharacterDialogPartner = partner as CharacterDialogPartner;
				
				/*if (_interjectionsDone.indexOf("naive_end") == -1)
				{
					if (cdp.id == "naive" && parseInt(AS2GameData.data.naive_day) == 4 && query != "greeting" && query != "default" )
					{
						this.query("naive_interjection_breakdown");
						_interjectionsDone.push("naive_end");
						return true;
					}
				}*/
				
			}
			
			return false;
		}
	}

}