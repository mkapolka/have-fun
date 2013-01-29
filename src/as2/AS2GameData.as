package as2 
{
	import as2.data.AmazonAppData;
	import as2.data.Clothing;
	import as2.data.FourSquareAppData;
	import as2.data.Item;
	import as2.data.PersonData;
	import as2.dialog.AS2DialogManagerComponent;
	import as2.dialog.AS2DialogPartner;
	import as2.dialog.SmartphoneDialogPartner;
	import as2.ui.ProgressPopupComponent;
	import model.Value;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogMessage;
	import org.component.Entity;
	import org.component.Message;
	/**
	 * Stores the session specific data about the game state
	 * in one place so that we can save and load it conveniently
	 * @author Marek Kapolka
	 */
	public class AS2GameData 
	{
		[Embed(source = "../../res/data.xml", mimeType = "application/octet-stream")]
		public static const DATA_XML : Class;
		
		public static const PLAYER_DATA_ID : String = "player";
		//public static const TIME_IN_DAY : Number = 180; // 5 minutes in seconds
		public static const TIME_IN_DAY : Number = 180;
		
		private static var _data : XML;
		private static var _dayTime : Number = TIME_IN_DAY;
		
		private static var _lastUpper : Clothing;
		private static var _lastLower : Clothing;
		
		public function AS2GameData() 
		{
			
		}
		
		public static function initialize():void
		{			
			_data = new XML(new DATA_XML());
			
			AmazonAppData.generateOffers();
		}
		
		public static function get data():XML
		{
			return _data;
		}
		
		public static function get people():XMLList
		{
			return _data.people;
		}
		
		public static function get apps():XMLList
		{
			return _data.apps.app;
		}
		
		public static function set dayTime(value : Number):void
		{
			_dayTime = value;
			
			if (_dayTime <= 0)
			{
				_dayTime = 0;
				
				//Send close dialog first
				var message : DialogMessage = new DialogMessage();
				message.type = DialogMessage.CLOSE_DIALOG;
				
				var dialogManager : Entity = Assignment2State.getDialogEntity();
				dialogManager.sendMessage(message);
				
				//Send open dialog
				
				message.type = DialogMessage.OPEN_DIALOG;
				message.partner = new AS2DialogPartner();
				message.partner.id = "goodnight";
				ConversationLibrary.buildDialogPartner(message.partner);
				
				dialogManager.sendMessage(message);
				
				message.type = DialogMessage.QUERY;
				message.message = "goodnight";
				
				dialogManager.sendMessage(message);
			}
		}
		
		public static function get dayTime():Number
		{
			return _dayTime;
		}
		
		public static function progressDay():void
		{
			date++;
			_dayTime = TIME_IN_DAY;
			
			if (AS2GameData.funHighScore < AS2GameData.funToday)
			{
				AS2GameData.funHighScore = AS2GameData.funToday;
			}
			AS2GameData.funToday = 0;
			
			//Main character progression variables
			if (parseInt(_data.naive_progress) > 0)
			{
				_data.naive_day = parseInt(_data.naive_day) + 1;
				_data.naive_progress = 0;
			}
			
			if (parseInt(_data.bro_progress) > 0)
			{
				_data.bro_day = parseInt(_data.bro_day) + 1; 
				_data.bro_progress = 0;
			}
			
			if (parseInt(_data.cynic_progress) > 0)
			{
				_data.cynic_day = parseInt(_data.cynic_day) + 1; 
				_data.cynic_progress = 0;
			}
			
			if (parseInt(_data.hacker_progress) > 0)
			{
				_data.hacker_day = parseInt(_data.hacker_day) + 1; 
				_data.hacker_progress = 0;
			}
			
			//Main Character Clothing
			var linda : PersonData = loadPerson("naive");
			genClothing(linda.upperClothing, data.naive_upper_clothing_slots, true);
			genClothing(linda.lowerClothing, data.naive_lower_clothing_slots, false);
			
			var bro : PersonData = loadPerson("bro");
			genClothing(bro.upperClothing, data.bro_upper_clothing_slots, true);
			genClothing(bro.lowerClothing, data.bro_lower_clothing_slots, false);
			
			var cynic : PersonData = loadPerson("cynic");
			genClothing(cynic.upperClothing, data.cynic_upper_clothing_slots, true);
			genClothing(cynic.lowerClothing, data.cynic_lower_clothing_slots, false);
			
			//Foursquare check-ins
			FourSquareAppData.addLocationPoints("starbucks", "bro", 10);
			FourSquareAppData.addLocationPoints("starbucks", "cynic", 10);
			
			//Level ups- do it a lazy way
			if (Math.random() < .25)
			{
				bro.funLevel += 1;
			}
			
			if (Math.random() < .25)
			{
				cynic.funLevel += 1;
			}
			
			if (Math.random() < .25)
			{
				linda.funLevel += 1;
			}
			
			AmazonAppData.generateOffers();
			
			_lastUpper = playerData.upperClothing;
			_lastLower = playerData.lowerClothing;
		}
		
		public static function genClothing(piece : Clothing, slots : XMLList, upper : Boolean):void
		{
			piece.id = "" + (Math.random() * int.MAX_VALUE);
			piece.name = upper?Clothing.getRandomNameShirt():Clothing.getRandomNamePants();
			var slots_a : Array = (String)(slots[0]).split(", ");
			piece.texture = parseInt(slots_a[Math.floor(Math.random() * slots_a.length)]);
			piece.slot = upper?0:1;
		}
		
		public static function get date():int
		{
			return parseInt(_data.date);
		}
		
		public static function set date(n : int):void
		{
			_data.date = n;
		}
		
		public static function get lastUpper():Clothing
		{
			return _lastUpper;
		}
		
		public static function get lastLower():Clothing
		{
			return _lastLower;
		}
		
		public static function get funToday():int
		{
			return parseInt(_data.fun_today);
		}
		
		public static function set funToday(value : int):void
		{
			_data.fun_today = value;
		}
		
		public static function get funHighScore():int
		{
			return parseInt(_data.fun_high_score);
		}
		
		public static function set funHighScore(value : int):void
		{
			_data.fun_high_score = value;
		}
		
		public static function hasApp(appName : String):Boolean
		{			
			for each (var app : XML in _data.apps.app)
			{
				if (app.id == appName)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function addApp(appName : String):void
		{
			if (hasApp(appName)) return;
			
			var appDefaults : XMLList = _data.app_data.app;
			
			for each (var x : XML in appDefaults)
			{
				if (x.id == appName)
				{
					_data.apps.appendChild(x);
					
					//Popup
					ProgressPopupComponent.showSimple("New App Available: " + x.name, 2);
					
					return;
				}
			}
			
			trace("Couldn't find app with name \"" + appName + "\"");
		}
		
		public static function getApp(appName : String):XML
		{
			for each (var x : XML in apps)
			{
				if (x.id == appName)
				{
					return x;
				}
			}
			
			return null;
		}
		
		public static function get packages():XMLList
		{
			return _data.packages;
		}
		
		public static function get hasPackages():Boolean
		{
			for each (var xml : XML in _data.packages[0].clothing)
			{
				var c : Clothing = new Clothing(xml);
				
				if (c.toBeDelivered == AS2GameData.date)
				{
					return true;
				}
			}
			//return _data.packages["clothing"].length() > 0;
			
			return false;
		}
		
		public static function givePackages():void
		{
			var player : PersonData = playerData;
			
			for each (var xml : XML in packages[0].clothing)
			{
				var c : Clothing = new Clothing(xml);
				if (c.toBeDelivered == AS2GameData.date)
				{
					player.addClothingToWardrobe(c);
					ProgressPopupComponent.showSimple("Gained " + c.name + "!", AmazonAppData.ICON_ID);
				}
			}
			
			for each (xml in packages[0].clothing)
			{
				AS2Utils.deleteNode(xml);
			}
		}
		
		public static function orderClothing(clothing : Clothing):void
		{
			packages.appendChild(clothing.data);
		}
		
		public static function get knownLocations():XMLList
		{
			return _data.known_locations.location;
		}
		
		public static function hasLocation(s : String):Boolean
		{
			for each (var x : String in _data.known_locations.location)
			{
				if (x == s)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function addLocation(s : String):void
		{
			if (!hasLocation(s))
			{
				var x : XML = new XML("<location>" + s + "</location>");
				_data.known_locations.appendChild(x);
			}
		}
		
		public static function get currentLocation():String
		{
			return _data.current_location;
		}
		
		public static function set currentLocation(s : String):void
		{
			_data.current_location = s;
		}
		
		public static function get playerData():PersonData
		{
			for each (var p : XML in _data.people.person)
			{
				if (p.id == "player")
				{
					return new PersonData(p);
				}
			}
			
			return null;
		}
		
		public static function get playerXML():XML
		{
			for each (var p : XML in _data.people.person)
			{
				if (p.id == "player")
				{
					return p;
				}
			}
			
			return null;
		}
		
		public static function get hasSmartphone():Boolean
		{
			var s : String = _data.has_smartphone;
			return (s == "0"?false:true);
		}
		
		public static function set hasSmartphone(b : Boolean):void
		{
			_data.has_smartphone = b?"1":"0";
		}
		
		public static function get hasCoffee():Boolean
		{
			var s : String = _data.has_coffee;
			return (s == "0"?false:true);
		}
		
		public static function set hasCoffee(b : Boolean):void
		{
			_data.has_coffee = b?"1":"0";
		}
		
		public static function loadPerson(id : String):PersonData
		{
			for each (var px : XML in _data.people.person)
			{
				if (px.id == id)
				{
					return new PersonData(px);
				}
			}
			
			return null;
		}
		
		public static function topics():Array
		{
			var s : String = _data.topics;
			return s.split(", ");
		}
	}

}
