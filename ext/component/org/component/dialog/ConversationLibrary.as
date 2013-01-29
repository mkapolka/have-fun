package org.component.dialog 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ConversationLibrary 
	{		
		public static var KEYWORDS : Array;
		public static var DATA : XML;
		
		public function ConversationLibrary() 
		{
			
		}
		
		public static function initialize(data : XML):void
		{
			/*if (DATA == null)
			{
				DATA = data;
			}
			
			if (KEYWORDS == null)
			{
				KEYWORDS = new Array();
				
				for each (var x : XML in DATA.keywords.keyword)
				{
					var topic : String = x.topic;
					var sWords : String = x.words;
					var words : Array = sWords.split(", ");
					
					for each (var s : String in words)
					{
						KEYWORDS[s] = topic;
					}
				}
			}*/
			
			addDialogFile(data);
		}
		
		public static function addDialogFile(data : XML):void
		{
			if (DATA == null)
			{
				DATA = data;
			} else {
				for each (var x : XML in data.children())
				{
					DATA.appendChild(x);
				}
			}
			
			if (KEYWORDS == null)
			{
				KEYWORDS = new Array();
			}
			
			for each (x in DATA.keywords.keyword)
			{
				var topic : String = x.topic;
				var sWords : String = x.words;
				var words : Array = sWords.split(", ");
				
				for each (var s : String in words)
				{
					KEYWORDS[s] = topic;
				}
			}
		}
		
		public static function initialized():Boolean
		{
			return (DATA != null);
		}
		
		public static function buildDialogPartner(template : DialogPartner):DialogPartner
		{			
			for each (x in ConversationLibrary.DATA.topic)
			{
				bdp_recursive(x, template);
			}
			
			for each (var x : XML in ConversationLibrary.DATA.conditional)
			{
				if (template.checkConditional(x.attribute("test")))
				{
					bdp_recursive(x, template);
				}
			}
			
			return template;
		}
		
		private static function bdp_recursive(xml : XML, dialogPartner : DialogPartner):void
		{
			if (xml.name() == "topic")
			{
				var dr : DialogResponse = dialogPartner.createDialogResponse();
				dialogPartner.fillDialogResponse(xml, dr);
				dialogPartner.addDialogResponse(dr);
			}
			
			if (xml.name() == "conditional")
			{
				if (dialogPartner.checkConditional(xml.attribute("test")))
				{
					for each (x in xml.topic)
					{
						bdp_recursive(x, dialogPartner);
					}
					
					for each (var x : XML in xml.conditional)
					{
						bdp_recursive(x, dialogPartner);
					}
				} else {
					var elseList : XMLList = xml.child("else");
					if (elseList.length()	 > 0)
					{
						var ex : XML = elseList[0];
						
						for each (x in ex.topic)
						{
							bdp_recursive(x, dialogPartner);
						}
						
						for each (x in ex.conditional)
						{
							bdp_recursive(x, dialogPartner);
						}
					}
				}
			}
		}
		
	}

}