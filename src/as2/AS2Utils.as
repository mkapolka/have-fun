package as2 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2Utils 
	{
		//Credit: http://edsyrett.wordpress.com/2008/07/26/xmlremovechild/
		public static function deleteNode(node : XML):void
		{
			if (node != null && node.parent() != null)
			{
				delete node.parent().children()[node.childIndex()];
			}
		}
	}

}