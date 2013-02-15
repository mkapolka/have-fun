package as2.data 
{
	import as2.AS2GameData;
	import as2.AS2SoundManager;
	import as2.AS2Utils;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	/**
	 * Data construct for dealing with information regarding invidividual characters
	 * within the game
	 * @author Marek Kapolka
	 */
	public class PersonData 
	{
		public var _data : XML;
		
		public function PersonData(data : XML) 
		{
			_data = data;
		}
		
		public function get data():XML
		{
			return _data;
		}
		
		public function get name():String
		{
			return _data.name;
		}
		
		public function set name(s : String):void
		{
			_data.name = s;
		}
		
		public function get id():String
		{
			return _data.id;
		}
		
		public function set id(s : String):void
		{
			_data.id = s;
		}
		
		public function get type():String
		{
			return _data.type;
		}
		
		public function set type(s : String):void
		{
			_data.type = s;
		}
		
		public function get portraitID():int
		{
			return parseInt(_data.portrait_id);
		}
		
		public function set portraitID(i : int):void
		{
			_data.portrait_id = i;
		}
		
		public function get money():int
		{
			return parseInt(_data.money);
		}
		
		public function set money(i : int):void
		{
			_data.money = i;
		}
		
		public function get fun():int
		{
			return parseInt(_data.fun);
		}
		
		/**
		 * Sets the amount of "Fun" this person has. It is assumed that this method will only be
		 * called on the player's person object, as the other people's "fun" values are not
		 * calculated.
		 */
		public function set fun(n : int):void
		{			
			var oldfun : int = parseInt(_data.fun);
			
			_data.fun = n;
			
			var d : int = _data.fun - oldfun;
			AS2GameData.funToday += d;
			
			var p1 : Number = (oldfun - prevFunTNL) / (funTNL - prevFunTNL);
			var p2 : Number = (n - prevFunTNL) / (funTNL - prevFunTNL);
			
			ProgressPopupComponent.showProgressBar("Gained " + d + " Fun!", 1, p1, p2);
			AS2SoundManager.playSound(AS2SoundManager.POINTS_MP3);
			
			if (fun >= funTNL)
			{
				funLevel++;
				funTNL += funGap;
				funGap += 100;
				ProgressPopupComponent.showSimple("Level Up! Current Level: " + funLevel, 1);
				AS2SoundManager.playSound(AS2SoundManager.LEVEL_UP_MP3);
			}
		}
		
		public function get funLevel():int
		{
			return parseInt(_data.fun_level);
		}
		
		public function set funLevel(value : int):void
		{
			_data.fun_level = value;
		}
		
		public function get prevFunTNL():int
		{
			return funTNL - (funGap - 100);
		}
		
		public function get funTNL():int
		{
			return parseInt(_data.fun_tnl);
		}
		
		public function set funTNL(value : int):void
		{
			_data.fun_tnl = value;
		}
		
		/**
		 * Returns the difference in fun required to be at this person's current level
		 * from their next level.
		 */
		public function get funGap():int
		{
			return parseInt(_data.fun_gap);
		}
		
		public function set funGap(value : int):void
		{
			_data.fun_gap = value;
		}
		
		public function get level():int
		{
			return Math.ceil(Math.log(fun));
		}
		
		/**
		 * The player's familiarity with this person.
		 */
		public function get rapport():int
		{
			return parseInt(_data.rapport);
		}
		
		public function set rapport(n : int):void
		{
			_data.rapport = n.toString();
		}
		
		public function get items():XMLList
		{
			return _data.items;
		}
		
		/**
		 * Returns the default conversation topics that should be included in all of this
		 * person's conversation branches.
		 */
		public function get defaultConversationTopics():Array
		{
			if (_data.elements("default_convo").length() > 0)
			{
				return (String)(_data.default_convo).split(", ");
			} else {
				return new Array();
			}
		}
		
		/**
		 * A person's "wardrobe" is the collection of all the clothing they own.
		 * NPCs have their clothing randomly generated at the beginning of each day
		 * so they don't make use of this. This is only for the Player.
		 */
		public function get wardrobe():Vector.<Clothing>
		{
			var output : Vector.<Clothing> = new Vector.<Clothing>();
			
			for each (var x : XML in _data.wardrobe.clothing)
			{
				var clothing : Clothing = new Clothing(x);
				output.push(clothing);
			}
			
			return output;
		}
		
		//Add and remove clothing from the wardrobe
		public function addClothingToWardrobe(article : Clothing):void
		{
			var xml : XML = new XML(article.data);
			_data.wardrobe.appendChild(xml);
		}
		
		public function removeClothingFromWardrobe(article : Clothing):void
		{
			for each (var x : XML in _data.wardrobe.clothing)
			{
				if (x == article.data)
				{
					AS2Utils.deleteNode(x);
					return;
				}
			}
		}
		
		public function get clothing():Vector.<Clothing>
		{
			var output : Vector.<Clothing> = new Vector.<Clothing>();
			
			for each (var x : XML in clothingXML.clothing)
			{
				var cloth : Clothing = new Clothing(x);
				output.push(cloth);
			}
			
			return output;
		}
		
		public function get upperClothing():Clothing
		{
			return getClothing(Clothing.SLOT_TOP);
		}
		
		public function get lowerClothing():Clothing
		{
			return getClothing(Clothing.SLOT_BOTTOM);
		}
		
		public function getClothing(slot : uint):Clothing
		{
			for each (var x : XML in clothingXML.clothing)
			{
				var cloth : Clothing = new Clothing(x);
				
				if (cloth.slot == slot)
				{
					return cloth;
				}
			}
			
			return null;
		}
		
		public function doffClothing(slot : uint, moveToWardrobe : Boolean):void
		{
			for each (var x : XML in clothingXML.clothing)
			{
				var c : Clothing = new Clothing(x);
				if (c.slot == slot)
				{
					if (moveToWardrobe)
					{
						var copied : XML = new XML(x);
						wardrobeXML.appendChild(copied);
					}
					
					AS2Utils.deleteNode(x);
				}
			}
		}
		
		public function wearClothing(clothing : Clothing):void
		{
			var inSlot : Clothing = getClothing(clothing.slot);
			if (inSlot != null)
			{
				doffClothing(clothing.slot, true);
			}
			
			clothingXML.appendChild(clothing.data);
		}
		
		public function get clothingXML():XMLList
		{
			return _data.clothing;
		}
		
		public function get wardrobeXML():XMLList
		{
			return _data.wardrobe;
		}
		
		public function get suggestTopics():Boolean
		{
			var st : XMLList = _data.suggest_topics;
			if (st.length() == 0) return true; // suggest topics by default
			
			return parseInt(_data.suggest_topics) > 0;
		}
		
		public function set suggestTopics(b : Boolean):void
		{
			_data.suggest_topics = b?"1":"0";
		}
	}

}
