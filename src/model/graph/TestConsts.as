package model.graph 
{
	/**
	 * A place to put big ol' static arrays like random names and such
	 * @author Marek Kapolka
	 */
	public class TestConsts 
	{
		public static const FIRST_NAMES_MALE : Array = [
			"Mark", "Steve", "Hank", "Robert", "Gerry", "Nick", "Nikhil", "Cody", "Michael", "Chris", "Jessie", "Thomas"
		]
		
		public static const FIRST_NAMES_FEMALE : Array = [
			"Jenene", "Sarah", "Emily", "Daphne", "Fiona", "Amanda", "Katie", "Cathy", "Mary", "Ellen"
		]
		
		public static const LAST_NAMES : Array = [
			"Loveless", "Bond", "Watkins", "Jones", "Smith", "Tailor", "Butcher", "Baker", "Maker", "Gottlieb", "Goldstein"
		]
		
		public static const INTERESTS : Array = [
			"Dancing", "Football", "Baseball", "Soccer", "Horror Movies", "Action Movies", "Chick Flicks", "Cars", "Painting",
			"Computers", "Video Games", "Gambling"
		]
		
		public static const LOCATIONS : Array = [
			"Cafe", "Restaurant", "Art Gallery", "Park", "Work", "Stadium"
		]
		
		public static const MALE : int = 0;
		public static const FEMALE : int = 1;
		
		
		public function TestConsts() 
		{
			
		}
		
		public static function generateName(gender : int):String
		{
			var r : int;
			var output : String = "";
			switch (gender)
			{
				case MALE:
					r = Math.floor(Math.random() * FIRST_NAMES_MALE.length);
					output += FIRST_NAMES_MALE[r];
				break;
				
				case FEMALE:
					r = Math.floor(Math.random() * FIRST_NAMES_FEMALE.length);
					output += FIRST_NAMES_FEMALE[r];
				break;
			}
			
			r = Math.floor(Math.random() * LAST_NAMES.length);
			output += " " + LAST_NAMES[r]
			
			return output;
		}
		
		public static function generatePerson():Person
		{
			var r : int = Math.round(Math.random());
			var p : Person = new Person();
			p.name = generateName(r);
			
			return p;
		}
		
	}

}