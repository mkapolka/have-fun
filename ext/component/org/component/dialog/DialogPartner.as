package org.component.dialog 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogPartner 
	{
		public var keywords : Array = new Array();
		public var id : String = null;
		
		protected var _defaultKeyword : String = "default";
		protected var _currentRespone : DialogResponse = null;
		
		public function DialogPartner()
		{
			
		}
		
		public function get defaultKeyword():String
		{
			return _defaultKeyword;
		}
		
		public function clearKeywords():void
		{
			keywords = new Array();
		}
		
		public function peekQuery(topic : String):DialogResponse
		{			
			var keyword : String = ConversationLibrary.KEYWORDS[topic.toLowerCase()];
			
			if (keyword == null) keyword = topic;
			
			var response : DialogResponse = keywords[keyword.toLowerCase()];
			//first, check if there are any responses that match the currently displayed options
			if (response == null && _currentRespone != null)
			{
				for each (var s : String in _currentRespone.options)
				{
					var parts : Array = s.split("|");
					if (parts.length > 0 && parts[0].toLowerCase() == topic.toLowerCase())
					{
						response = (parts.length == 1)?keywords[parts[0].toLowerCase()]:keywords[parts[1].toLowerCase()];
					}
				}
			}
			//Then go with the default response
			if (response == null) response = keywords[defaultKeyword];
			
			return response;
		}
		
		public function query(topic : String):DialogResponse
		{
			var response : DialogResponse = peekQuery(topic);
			response.text = filterResponseText(response.text);
			//expandMetaOptions(response);
			
			if (response.results != null)
			{
				var functions : Vector.<String> = parseFunctions(response.results);
				
				doResults(functions);
			}
			
			_currentRespone = response;
			return response;
		}
		
		public function queryDynamic(topic : String):DialogResponse
		{
			var keyword : String = ConversationLibrary.KEYWORDS[topic.toLowerCase()];
			
			if (keyword == null) keyword = topic.toLowerCase();
			
			var response : DialogResponse = createDialogResponse();			
			var qdrObject : Object = new Object();
			qdrObject.response = response;
			qdrObject.priority = 0;
			qdrObject.updated = false;
			qdr(ConversationLibrary.DATA, keyword, qdrObject, 0);
			
			if (!qdrObject.updated)
			{
				qdr(ConversationLibrary.DATA, _defaultKeyword, qdrObject, 0);
			}
			
			response = qdrObject.response;
			response.text = filterResponseText(response.text);
			
			if (response.results != null)
			{
				var functions : Vector.<String> = parseFunctions(response.results);
				doResults(functions);
			}
			
			return qdrObject.response;
		}
		
		private function qdr(xml : XML, query : String, object : Object, priority : int):void
		{
			for each (var x : XML in xml.elements())
			{
				if (x.name() == "topic")
				{
					if (x.attribute("name") == query)
					{
						if (priority >= object.priority)
						{
							fillDialogResponse(x, object.response);
							object.priority = priority;
							object.updated = true;
						}
					}
				}
				
				if (x.name() == "conditional")
				{
					if (checkConditional(x.attribute("test")))
					{
						var np : int = priority;
						if (x.attribute("priority") != null && x.attribute("priority") != "")
						{
							np = parseInt(x.attribute("priority"));
						}
						
						if (np >= priority)
						{
							qdr(x, query, object, np);
						}
					}
				}
			}
		}
		
		protected function filterResponseText(input : String):String
		{
			return input;
		}
		
		protected function doResults(functions : Vector.<String>):void
		{			
			for each (var s : String in functions)
			{
				var params : Array = s.split(" ");
				
				if (params.length == 0) continue;
				
				if (params[0] == "connect")
				{
					var out : String = params[params.length - 1];
					var key : String = "";
					
					for (var i : int = 1; i < params.length - 1; i++)
					{
						key += params[i];
						
						if (i < params.length - 2)
						{
							key += " ";
						}
					}
					
					key = key.toLowerCase();
					
					keywords[key] = keywords[out];
					continue;
				}
				
				if (params[0] == "disconnect")
				{
					keywords[params[1]] = null;
				}
			}
		}
		
		/*public function conditionalOperands(conditional : String):Boolean
		{
			var conditionals : Vector.<String> = new Vector.<String>();
			
			//Check parentheses
			var openParen : Boolean = false;
			var cc : String = "";
			for (var i : int = 0; i < conditional.length; i++)
			{
				if (!openParen)
				{
					if (conditional.charAt(i) == "(")
					{
						openParen = true;
						if (cc != "")
						{
							conditionals.push(cc);
							cc = "";
						}
					} else {
						cc += conditional.charAt(i);
					}
				} else {
					if (conditional.charAt(i) == ")")
					{
						openParen = false;
						
						if (cc != "")
						{
							conditionals.push(cc);
							cc = "";
						}
					} else {
						cc += conditional.charAt(i);
					}
				}
			}
			
			//Check operands
			for each (var con : String in conditionals)
			{
				for (i = 0; i < con.length; i++)
				{
					
				}
			}
		}*/
		
		public function checkConditional(conditional : String):Boolean
		{
			var a : Array = conditional.split(" ");
			
			if (a.length > 0)
			{
				if (a[0] == "id")
				{
					return id == a[1];
				}
			}
			
			return false;
		}
		
		public function expandMetaOptions(array : DialogResponse):void
		{
			//
		}
		
		public function createDialogResponse():DialogResponse
		{
			return new DialogResponse();
		}
		
		public function fillDialogResponse(topic : XML, response : DialogResponse = null ):DialogResponse
		{
			if (response == null)
			{
				response = createDialogResponse();
			}
			
			response.name = topic.attribute("name");
			response.text = topic.response;
			
			var sOptions : String = topic.options;
			var options : Array = sOptions.split(", ");
			
			if (options.length == 1 && options[0] == "") options = new Array();
			
			var vs : Vector.<String> = new Vector.<String>();
			for each (var s : String in options)
			{
				vs.push(s);
			}
			
			response.options = vs;
			
			expandMetaOptions(response);
			
			//Strip whitespace out of result
			var result : String = topic.result;
			result = result.replace("\n", "");
			result = result.replace("\t", "");
			result = result.replace("  ", " ");
			
			response.results = result;
			
			return response;
		}
		
		public function addDialogResponse(response : DialogResponse):void
		{
			keywords[response.name] = response;
		}
		
		public static function parseFunctions(s : String):Vector.<String>
		{
			var out : Vector.<String> = new Vector.<String>();
			
			var cs : String = "";
			for (var i : int = 0; i < s.length; i++)
			{
				if (s.charAt(i) == "[") continue;
				if (s.charAt(i) == "]")
				{
					out.push(cs);
					cs = new String();
					continue;
				}
				
				cs += s.charAt(i);
			}
			
			return out;
		}
		
	}

}