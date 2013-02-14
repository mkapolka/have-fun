package as2.dialog 
{
	import as2.AS2GameData;
	import as2.AS2TitleScreen;
	import as2.Assignment2State;
	import as2.data.AmazonAppData;
	import as2.data.Clothing;
	import as2.data.CoffeeAppData;
	import as2.data.DeodorantAppData;
	import as2.data.FourSquareAppData;
	import as2.data.GymAppData;
	import as2.data.QuestAppData;
	import as2.data.WalkingAppData;
	import as2.etc.CountdownComponent;
	import as2.etc.NaiveComponent;
	import as2.etc.QuestIconComponent;
	import as2.RoomManager;
	import as2.TaggedObjectComponent;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogManagerComponent;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogPartner;
	import org.component.dialog.DialogResponse;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2DialogPartner extends DialogPartner 
	{
		public static const INPUT_HASHCODE : String = "#input";
		public static const LOCATIONS_HASHCODE : String = "#locations";
		
		protected var _portraitID : uint = 0;
		protected var _name : String = "";
		
		public function AS2DialogPartner() 
		{
			super();
		}
		
		public function get portraitID():uint 
		{
			return _portraitID;
		}
		
		public function set portraitID(id : uint):void
		{
			_portraitID = id;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(s : String):void
		{
			_name = s;
		}
		
		protected function get dialogManager():Entity
		{
			return TaggedObjectComponent.getObjectByTag(Assignment2State.DIALOG_TAG);
		}
		
		protected function sendUpdatePartnerMessage():void
		{
			var target : Entity = dialogManager;
			
			if (target != null)
			{
				var message : DialogMessage = new DialogMessage();
				message.type = DialogMessage.UPDATE_PARTNER;
				message.partner = this;
				
				target.sendMessage(message);
			}
		}
		
		protected function sendCloseDialogMessage():void
		{
			var target : Entity = dialogManager;
			
			if (target != null)
			{
				var message : DialogMessage = new DialogMessage();
				message.sender = null;
				message.type = DialogMessage.CLOSE_DIALOG;
				
				target.sendMessage(message);
			}
			
			target = Assignment2State.getPlayerEntity();
			
			if (target != null)
			{
				var standMessage : Message = new Message();
				standMessage.sender = null;
				standMessage.type = "stop";
				
				target.sendMessage(standMessage);
			}
		}
		
		override protected function filterResponseText(text : String):String
		{
			var array : Array = text.split(" ");
			var output : String = "";
			
			for (var i : int = 0; i < array.length; i++)
			{
				var s : String = array[i];
				if (s.length > 0 && s.charAt(0) == "#")
				{
					output += filterHashCode(s);
				} else {
					output += s;
				}
				
				if (i != array.length - 1)
				{
					output += " ";
				}
			}
			
			return output;
		}
		
		protected function filterHashCode(code : String):String
		{
			switch (code)
			{
				case "#money":
					return "$" + (AS2GameData.playerData.money / 100).toFixed(2);
				break;
				
				case "#next_dove_award":
					return DeodorantAppData.nextDoveAward.toString();
				break;
				
				case "#next_secret_award":
					return DeodorantAppData.nextSecretAward.toString();
				break;
				
				case "#fun_today":
					return AS2GameData.funToday.toString();
				break;
				
				case "#high_score":
					return AS2GameData.funHighScore.toString();
				break;
				
				case "#clothes_ordered":
					var output : String = "";
					
					//for each (var x : XML in AS2GameData.packages.clothing)
					for (var i : int = 0; i < AS2GameData.packages[0].clothing.length(); i++)
					{
						var c : XML = AS2GameData.packages[0].clothing[i];
						output += c.name;
						
						if (i != AS2GameData.packages[0].clothing.length() - 1)
						{
							output += ", and your ";
						}
					}
					
					return output;
				break;
			}
			
			var cad : String = CoffeeAppData.filterHashCode(code);
			if (cad != null) return cad;
			
			cad = FourSquareAppData.filterHashCode(code);
			if (cad != null) return cad;
			
			cad = WalkingAppData.filterHashCode(code);
			if (cad != null) return cad;
			
			cad = GymAppData.filterHashCode(code);
			if (cad != null) return cad;
			
			cad = AmazonAppData.filterHashCode(code);
			if (cad != null) return cad;
			
			return code;
		}
		
		override protected function doResults(functions : Vector.<String>):void
		{
			super.doResults(functions);
			
			for each (var s : String in functions)
			{
				var a : Array = s.split(" ");
				
				switch (a[0])
				{
					case "setname":
						var s2 : String = "";
					
						for (var i : int = 1; i < a.length; i++)
						{
							s2  += a[i];
							
							s2 += (i == a.length - 1)?"":" ";
						}
						
						_name = s2;
						
						sendUpdatePartnerMessage();
					break;
					
					case "closedialog":
						sendCloseDialogMessage();
					break;
					
					case "room":
						if (a.length < 2) continue;
						var tti : int = RoomManager.NONE;
						var target_room : String = a[1];
						
						if (a.length > 2)
						{
							var transition_type : String = a[2];
							transition_type = transition_type.toLowerCase();
							
							switch (transition_type)
							{
								case "none":
									tti = RoomManager.NONE;
								break;
								
								case "fade":
									tti = RoomManager.FADE;
								break;
							}
						}
						
						RoomManager.transition(target_room, tti);
					break;
					
					case "addmoney":
						AS2GameData.playerData.money += parseInt(a[1]);
					break;
					
					case "removemoney":
						AS2GameData.playerData.money -= parseInt(a[1]);
					break;
					
					case "addapp":
						if (a.length < 2)
						{
							trace("Invalid dialog result: addapp");
							continue;
						}
						
						AS2GameData.addApp(a[1]);
					break;
					
					case "setid":
						if (a.length < 2)
						{
							trace("Invalid parameters on dialog result: setid");
							continue;
						} else {
							id = a[1];
							rebuildDialog();
						}
					break;
					
					case "rebuild":
						rebuildDialog();
					break;
					
					case "query":
						var dm : DialogManagerComponent = dialogManager.getComponentByType(DialogManagerComponent) as DialogManagerComponent;
						dm.query(a[1]);
					break;
					
					case "givesmartphone":
						AS2GameData.hasSmartphone = true;
					break;
					
					case "setportrait":
						_portraitID = parseInt(a[1]);
						sendUpdatePartnerMessage();
					break;
					
					case "addlocation":
						AS2GameData.addLocation(a[1]);
						ProgressPopupComponent.showSimple("Location Added: " + a[1], 1);
					break;
					
					case "addtime":
						AS2GameData.date++;
					break;
					
					case "sleep":
						//AS2GameData.date++;
						AS2GameData.progressDay();
						RoomManager.transition(RoomManager.NEWDAY_KEY, RoomManager.FADE);
					break;
					
					case "fade":
						var fm : Message = new Message();
						fm.type = AS2DialogManagerComponent.FADE_MESSAGE;
						dialogManager.sendMessage(fm);
					break;
					
					case "unfade":
						fm = new Message();
						fm.type = AS2DialogManagerComponent.UNFADE_MESSAGE;
						dialogManager.sendMessage(fm);
					break;
					
					case "sleep_nofun":
						if (parseInt(AS2GameData.data.sleep_fun_streak) > 0)
						{
							ProgressPopupComponent.showSimple("Fun Day Streak Ended!", 0);
						}
						
						AS2GameData.data.sleep_fun_streak = 0;
					break;
					
					case "sleep_hadfun":	
						AS2GameData.data.sleep_fun_streak = parseInt(AS2GameData.data.sleep_fun_streak) + 1;
						if (parseInt(AS2GameData.data.sleep_fun_streak) > 1)
						{
							ProgressPopupComponent.showSimple(AS2GameData.data.sleep_fun_streak + " Fun Days in a row!", 1);
						}
						
						AS2GameData.playerData.fun += 50 * parseInt(AS2GameData.data.sleep_fun_streak);
					break;
					
					case "data":
						var varname : String = a[1];
						var operand : String = a[2];
						
						switch (operand)
						{
							case "=":
								AS2GameData.data[varname] = a[3];
							break;
							
							case "+=":
								AS2GameData.data[varname] += a[3];
							break;
							
							case "-=":
								AS2GameData.data[varname] += a[3];
							break;
							
							case "*=":
								AS2GameData.data[varname] *= a[3];
							break;
							
							case "/=":
								AS2GameData.data[varname] /= a[3];
							break;
						}
					break;
					
					case "fun":						
						switch (a[1])
						{
							case "+=":
								AS2GameData.playerData.fun += parseInt(a[2]);
							break;
						
							
							case "-=":
								AS2GameData.playerData.fun -= parseInt(a[2]);
							break;
						}
					break;
				
					case "givequest":
					case "addquest":
						var name : String = "";
						
						for (i = 2; i < a.length; i++)
						{
							name += a[i];
							
							if (i != a.length - 1)
							{
								name += " ";
							}
						}
						
						QuestAppData.addQuest(a[1], name);
						rebuildDialog();
					break;
					
					case "popup":
						var icon : uint = parseInt(a[1]);
						var message : String = "";
						for (i = 2; i < a.length; i++)
						{
							message += a[i];
							if (i != a.length - 1)
							{
								message += " ";
							}
						}
						ProgressPopupComponent.showSimple(message, icon);
					break;
					
					case "completequest":
						QuestAppData.completeQuest(a[1]);
						rebuildDialog();
					break;
					
					case "removequest":
						QuestAppData.removeQuest(a[1]);
						rebuildDialog();
					break;
					
					case "stopclock":
						CountdownComponent.paused = true;
					break;
					
					case "startclock":
						CountdownComponent.paused = false;
					break;
					
					case "givepackages":
						AS2GameData.givePackages();
					break;
					
					/*case "hidegoodbye":
						var m : Message = new Message();
						m.sender = null;
						m.type = GoodbyeOptionComponent.HIDE_CLOSE_TEXT;
						dialogManager.sendMessage(m);
					break;*/
					
					case "showgoodbye":
						var m : Message = new Message();
						m.sender = null;
						m.type = GoodbyeOptionComponent.SHOW_CLOSE_TEXT;
						dialogManager.sendMessage(m);
					break;

					case "exit":
						NaiveComponent.hide();
					break;
					
					case "touch_questlist":
						QuestIconComponent.touch();
					break;
					
					//APP RESULTS
					
					case "coffee":
						a.splice(0,1);
						CoffeeAppData.doResults(a);
					break;
					
					case "deodorant":
						a.splice(0, 1);
						DeodorantAppData.doResults(a);
					break;
					
					case "foursquare":
						a.splice(0, 1);
						FourSquareAppData.doResults(a);
					break;
					
					case "walking":
						a.splice(0, 1);
						WalkingAppData.doResults(a);
					break;
					
					case "gym":
						a.splice(0, 1);
						GymAppData.doResults(a);
					break;
					
					case "amazon":
						a.splice(0, 1);
						AmazonAppData.doResults(a);
					break;
				}
			}
		}
		
		protected function rebuildDialog():void
		{
			clearKeywords();
			ConversationLibrary.buildDialogPartner(this);
		}
		
		override public function checkConditional(conditional : String):Boolean
		{
			if (super.checkConditional(conditional) == true) return true;
			
			var a : Array = conditional.split(" ");
			
			switch (a[0])
			{
				case "name":
					switch (a[1])
					{
						case "==":
							return a[2] == name;
						break;
						
						case "!=":
							return a[2] != name;
						break;
					}
				break;
				
				case "hasapp":
					return AS2GameData.hasApp(a[1]);
				break;
				
				case "noapp":
					return !AS2GameData.hasApp(a[1]);
				break;
				
				case "$":
					switch (a[1])
					{
						case ">":
							return AS2GameData.playerData.money > parseInt(a[2]);
						break;
						
						case ">=":
							return AS2GameData.playerData.money >= parseInt(a[2]);
						break;
						
						case "!>=":
							return AS2GameData.playerData.money <= parseInt(a[2]);
						break;
						
						case "!>":
							return AS2GameData.playerData.money < parseInt(a[2]);
						break;
					}
				break;
				
				case "location":
					switch (a[1])
					{
						case "==":
							return AS2GameData.currentLocation == a[2];
						break;
						
						case "!=":
							return AS2GameData.currentLocation != a[2];
						break;
					}
				break;
				
				case "hassmartphone":
					return AS2GameData.hasSmartphone;
				break;
				
				case "nosmartphone":
					return !AS2GameData.hasSmartphone;
				break;
				
				case "data":
					var varname : String = a[1];
					
					var array : XML = AS2GameData.data;
					
					switch (a[2])
					{
						case "==":
							return AS2GameData.data[varname] == a[3];
						break;
						
						case "!=":
							return AS2GameData.data[varname] != a[3];
						break;
						
						//Going to assume the following operands will be used on numbers
						// (Will convert to Number for more compatability)
						
						case ">":
							return parseFloat(AS2GameData.data[varname]) > parseFloat(a[3]);
						break;
						
						case "!>":
							return parseFloat(AS2GameData.data[varname]) < parseFloat(a[3]);
						break;
						
						case ">=":
							return parseFloat(AS2GameData.data[varname]) >= parseFloat(a[3]);
						break;
						
						case "!>=":
							return parseFloat(AS2GameData.data[varname]) <= parseFloat(a[3]);
						break;
					}
				break;
				
				case "mailman":
					return (!AS2GameData.hasSmartphone || AS2GameData.hasPackages);
				break;
				
				case "beat_high_score":
					return AS2GameData.funToday > AS2GameData.funHighScore;
				break;
				
				//App Conditionals
				case "coffee":
					a.splice(0,1);
					return CoffeeAppData.checkConditional(a);
				break;
				
				case "foursquare":
					a.splice(0, 1);
					return FourSquareAppData.checkConditional(a);
				break;
				
				case "deodorant":
					a.splice(0, 1);
					return DeodorantAppData.checkConditional(a);
				break;
				
				case "gym":
					a.splice(0, 1);
					return GymAppData.checkConditional(a);
				break;
			}
			
			return false;
		}
		
		override public function createDialogResponse():DialogResponse
		{
			return new AS2DialogResponse();
		}
		
		override public function fillDialogResponse(xml : XML, dr : DialogResponse = null):DialogResponse
		{
			var output : DialogResponse = super.fillDialogResponse(xml, dr);
			
			var as2dr : AS2DialogResponse = (AS2DialogResponse)(output);
			as2dr.portrait = parseInt(xml.portrait);
			
			return as2dr;
		}
		
		override public function expandMetaOptions(response : DialogResponse):void
		{
			if (response is AS2DialogResponse)
			{
				var as2dr : AS2DialogResponse = response as AS2DialogResponse;
				
				for (var i : int = 0; i < as2dr.options.length; i++)
				{
					if (as2dr.options[i] == INPUT_HASHCODE)
					{
						as2dr.input = true;
						as2dr.options.splice(i, 1);
						i--;
						continue;
					}
					
					if (as2dr.options[i] == LOCATIONS_HASHCODE)
					{
						as2dr.options.splice(i, 1);
						i--;
						
						var knownLocations : XMLList = AS2GameData.knownLocations;
						
						for each (var x : String in knownLocations)
						{
							if (x != AS2GameData.currentLocation)
							{
								as2dr.options.push(x);
								i++;
								var buffer : String = as2dr.options[i];
								as2dr.options[i] = as2dr.options[as2dr.options.length - 1];
								as2dr.options[as2dr.options.length - 1] = buffer;
							}
						}
						
						continue;
					}
				}
				
				GymAppData.expandMetaOptions(response);
			}
		}
		
	}

}
