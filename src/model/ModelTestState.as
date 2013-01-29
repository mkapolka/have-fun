package model 
{
	import model.vis.ParameterSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ModelTestState extends FlxState 
	{
		public var demographicContexts : Array = [ "Mothers", "Sons", "Daughters" ];
		public var institutionContexts : Array = [ "Starbucks", "Peets", "Tullys" ];
		public var network : Network;
		
		public function ModelTestState() 
		{
			super();
		}
		
		private function makeDParameter(name : String):Parameter
		{
			var output : Parameter = new Parameter(demographicContexts);
			output.name = name;
			network.addParameter(output);
			return output;
		}
		
		private function makeIParameter(name : String):Parameter
		{
			var output : Parameter = new Parameter(institutionContexts);
			output.name = name;
			network.addParameter(output);
			return output;
		}
		
		private function makeIDParameter(name : String):Parameter
		{
			var output : Parameter = new Parameter(institutionContexts, demographicContexts);
			output.name = name;
			network.addParameter(output);
			return output;
		}
		
		private function makeDeltaRelationship(parent : Parameter, child : Parameter, mode : uint, coefficient : Number = 1):void
		{
			var dr : DeltaRelationship = new DeltaRelationship(parent, child, mode, coefficient);
			parent.relationships.push(dr);
			network.addRelationship(dr);
		}
		
		private function makeStreamRelationship(parent : Parameter, child : Parameter, mode : uint, coefficient : Number = 1):void
		{
			var sr : StreamRelationship = new StreamRelationship(parent, child, mode, coefficient);
			parent.relationships.push(sr);
			network.addRelationship(sr);
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFFFFFFF;
			setupNetwork();
			
			setupSprites();
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				network.tick();
			}
		}
		
		private function setupSprites():void 
		{
			for each (var p : Parameter in network.parameters)
			{
				var ps : ParameterSprite = new ParameterSprite(p);
				ps.x = Math.random() * FlxG.width;
				ps.y = Math.random() * FlxG.height;
				FlxG.stage.addChild(ps);
			}
		}
		
		private function populateParameter(parameter : Parameter, min : Number, max : Number):void
		{
			for each (var v : Value in parameter.values)
			{
				var r : Number = min + Math.random() * (max - min);
				v.value = r;
			}
		}
		
		private function setupNetwork():void
		{
			network = new Network();
			
			var gameDesigners : Parameter = makeIParameter("Game Designers");
			var streetTeam : Parameter = makeIParameter("Street Team");
			var engineers : Parameter = makeIParameter("Engineers");
			
			populateParameter(gameDesigners, 0, 1);
			populateParameter(streetTeam, 0, 1);
			populateParameter(engineers, 0, 1);
			
			var researchCorprus : Parameter = makeIParameter("Research Corprus");
			var marketPenetration : Parameter = makeIParameter("Market Penetration");
			
			var gameNovelty : Parameter = makeIDParameter("Game Novelty");
			var gameLoyalty : Parameter = makeIDParameter("Game Loyalty");
			var gameNumbers : Parameter = makeIDParameter("Game Players");
			var gameInterest : Parameter = makeIDParameter("Game Interest");
			
			//Relationships
			makeDeltaRelationship(streetTeam, marketPenetration, SimpleRelationship.MODE_MERGE);
			makeStreamRelationship(engineers, researchCorprus, SimpleRelationship.MODE_MERGE);
			makeStreamRelationship(gameDesigners, gameNovelty, SimpleRelationship.MODE_MERGE);
			
			network.initialize();
		}
		
	}

}