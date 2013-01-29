package as2.dialog 
{
	import as2.AS2GameData;
	import as2.data.CoffeeAppData;
	import as2.data.PersonData;
	import org.component.dialog.DialogResponse;
	/**
	 * DialogPartner for handling Character based conversations
	 * and associated functions
	 * @author Marek Kapolka
	 */
	public class CharacterDialogPartner extends AS2DialogPartner 
	{
		public static const NODEFAULTS_HASHCODE : String = "#nodefault";
		public static const NOINPUT_HASHCODE : String = "#noinput";
		
		private var _character : PersonData;
		
		public function CharacterDialogPartner(pd : PersonData ) 
		{
			super();
			
			_character = pd;
		}
		
		override public function query(topic : String):DialogResponse
		{
			if (CoffeeAppData.hasCoffee)
			{
				CoffeeAppData.talk(_character.id);
			}
			
			return super.query(topic);
		}
		
		override public function checkConditional(conditional : String):Boolean
		{
			if (super.checkConditional(conditional)) return true;
			
			var a : Array = conditional.split(" ");
			if (a.length == 0) return false;
			
			switch (a[0])
			{
				case "type":
					return checkType(a);
				break;
				
				case "rapport":
					switch (a[1])
					{
						case ">":
							return _character.rapport > parseInt(a[2]);
						break;
						
						case ">=":
							return _character.rapport >= parseInt(a[2]);
						break;
						
						case "!>":
							return _character.rapport < parseInt(a[2]);
						break;
						
						case "!>=":
							return _character.rapport <= parseInt(a[2]);
						break;
					}
				break;
			}
			
			return false;
		}
		
		private function checkType(ci : Array):Boolean
		{
			switch (ci[1])
			{
				case "==":
					return _character.type == ci[2];
				break;
				
				case "!=":
					return _character.type != ci[2];
				break;
			}
			
			return false;
		}
		
		override protected function doResults(results : Vector.<String>):void
		{
			for each (var s : String in results)
			{
				var a : Array = s.split(" ");
				
				if (a.length == 0) continue;
				
				switch (a[0])
				{
					case "addrapport":
						_character.rapport += parseInt(a[1]);
					break;
					
					case "removerapport":
						_character.rapport -= parseInt(a[1]);
					break;
				}
			}
			
			super.doResults(results);
		}
		
		override public function expandMetaOptions(response : DialogResponse):void
		{
			super.expandMetaOptions(response);
			
			var as2dr : AS2DialogResponse = response as AS2DialogResponse;
			as2dr.input = true;
			
			//var defaults : Boolean = _character.suggestTopics;
			var defaults : Boolean = true;
			
			for (var i : int = 0; i < as2dr.options.length; i++)
			{
				var s : String = as2dr.options[i];
				
				switch (s)
				{
					case NOINPUT_HASHCODE:
						as2dr.options.splice(i, 1);
						i--;
						as2dr.input = false;
					break;
					
					case NODEFAULTS_HASHCODE:
						as2dr.options.splice(i, 1);
						i--;
						defaults = false;
					break;
				}
			}
			
			if (defaults)
			{
				var topics : Array = _character.defaultConversationTopics;
						
				for each (var t : String in topics)
				{
					if (response.name != t && response.options.indexOf(t) == -1)
					{
						response.options.push(t);
					}
				}
			}
			
			//Always make "bye" last
			var bi : int = -1;
			for (i = 0; i < as2dr.options.length; i++ )
			{
				if (as2dr.options[i] == "bye") bi = i;
			}
			
			if (bi != -1)
			{
				var buffer : String = as2dr.options[as2dr.options.length - 1];
				as2dr.options[as2dr.options.length - 1] = as2dr.options[bi];
				as2dr.options[bi] = buffer;
			}
		}
		
	}

}