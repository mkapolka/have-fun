package model.graph 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.ObjectInput;
	import model.vis.NodeSprite;
	import org.flixel.FlxState;
	import model.graph.*;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SocialGraphTest extends Sprite 
	{
		public static const PERSON_COLOR : uint = 0xCE6764;
		public static const INTEREST_COLOR : uint = 0x85A7CF;
		public static const LOCATION_COLOR : uint = 0x66F55F;
		public static const SELECTED_COLOR : uint = 0xE6C16F;
		
		public static const NUM_PEOPLE : int = 50;
		
		public var graph : Graph;
		public var nodeDictionary : Dictionary = new Dictionary();
		public var textDisplay : TextField;
		public var infoText : TextField;
		
		public var people : Vector.<Person> = new Vector.<Person>();
		public var interests : Vector.<Interest> = new Vector.<Interest>();
		
		private var _mouseDown : Boolean = false;
		private var _mousePoint : Point = new Point();
		private var _mouseOver : Object = null;
		private var _draggedObject : Object = null;
		
		private var _selectedObjects : Vector.<Object> = new Vector.<Object>();
		private var _shiftPressed : Boolean = false;
		
		public function SocialGraphTest() 
		{
			graph = new Graph();
			
			initialize();
			addEventListener(Event.ENTER_FRAME, onRender);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			stage.quality = StageQuality.LOW;
		}
		
		public function initialize():void
		{
			addPeople(NUM_PEOPLE);
			addInterests();
			addLocations();
			
			//Initialize text field
			textDisplay = new TextField();
			textDisplay.text = "Test";
			textDisplay.x = 0;
			textDisplay.y = stage.stageHeight - textDisplay.textHeight;
			textDisplay.width = stage.stageWidth;
			textDisplay.type = TextFieldType.DYNAMIC;
			textDisplay.selectable = false;
			textDisplay.height = 10000;
			addChild(textDisplay);
			
			//Initialize info text (upper left)
			infoText = new TextField();
			infoText.text = "Test";
			infoText.x = 0;
			infoText.y = 0;
			infoText.width = stage.stageWidth;
			infoText.type = TextFieldType.DYNAMIC;
			infoText.selectable = false;
			infoText.height = 10000;
			//addChild(infoText);
		}
		
		private function setDisplayText(s : String):void
		{
			textDisplay.text = s;
		}
		
		private function updateInfoText():void
		{
			
		}
		
		public function addPeople(n : int):void
		{			
			for (var i : int = 0; i < n; i++)
			{
				var p : Person = new Person();
				p.name = TestConsts.generateName(Math.random() > .5?TestConsts.FEMALE:TestConsts.MALE);
				//graph.addNode(p);
				addNode(p);
				people.push(p);
			}
			
			for each (p in people)
			{
				var n : int = Math.ceil(Math.random() * 5);
				for (i = 0; i < n; i++)
				{
					var r : int = Math.floor(Math.random() * people.length);
					if (people[r] != p)
					{
						p.addFriend(people[r], Math.random());
					}
				}
			}
			
			testDuplicateFriends();
		}
		
		public function addInterests():void
		{
			for each (var s : String in TestConsts.INTERESTS)
			{
				var interest : Interest = new Interest();
				interest.name = s;
				
				var n : int = Math.floor(Math.random() * people.length);
				
				for (var i : int = 0; i < n; i++)
				{
					var r : int = Math.floor(Math.random() * people.length);
					var person : Person = people[r];
					
					person.addInterest(interest, Math.random());
				}
				
				addNode(interest);
			}
		}
		
		public function addLocations():void
		{
			var locs : Vector.<Location> = new Vector.<Location>();
			
			for each (var s : String in TestConsts.LOCATIONS)
			{
				var location : Location = new Location();
				location.name = s;
				
				locs.push(location);
				
				addNode(location);
			}
			
			for each (var p : Person in people)
			{
				var n : int = Math.floor(Math.random() * locs.length)
				p.addLocation(locs[n]);
			}
		}
		
		
		private function testDuplicateFriends():void
		{
			for each (var n : Node in graph.nodes)
			{
				var v : Vector.<Node> = new Vector.<Node>();
				
				for each (var c : Connection in n.connections)
				{
					if (v.indexOf(c.other) != -1)
					{
						trace("DUPLICATE FRIEND ENTRY DETECTED")
					} else {
						v.push(c.other);
					}
					
				}
			}
		}
		
		public function addNode(n : Node):void
		{
			graph.addNode(n);
			var o : Object = new Object();
			o.x = Math.random() * stage.stageWidth;
			o.y = Math.random() * stage.stageHeight;
			o.node = n;
			nodeDictionary[n] = o;
		}
		
		public function onKeyPressed(ke : KeyboardEvent ):void
		{
			if (ke.keyCode == Keyboard.SPACE)
			{
				tick();
			}
			
			if (ke.keyCode == Keyboard.SHIFT)
			{
				_shiftPressed = true;
			}
			
			if (ke.keyCode == 65)// 'a'
			{
				attractCommonNodes();
			}
			
			if (ke.keyCode == 77)//'m'
			{
				doMingle();
			}
			
			if (ke.keyCode == 67)// 'c'
			{
				if (_mouseOver != null)
				{
					var n : Node = _mouseOver.node as Node;
					
					for each (var o : Object in _selectedObjects)
					{
						if (o != _mouseOver)
						{
							connectNodes(n, o.node as Node);
						}
					}
					
					updateDistances();
				}
			}
		}
		
		public function doMingle():void
		{
			var pv : Vector.<Person> = new Vector.<Person>();
			
			for each (var o : Object in _selectedObjects)
			{
				if (o.node is Person)
				{
					pv.push(o.node as Person);
				}
			}
			
			for each (var p : Person in pv)
			{
				p.mingle(pv);
			}
		}
		
		public function onKeyReleased(ke : KeyboardEvent):void
		{
			if (ke.keyCode == Keyboard.SHIFT)
			{
				_shiftPressed = false;
			}
		}
		
		public function onMousePressed(me : MouseEvent):void
		{
			_mouseDown = true;
			_mousePoint.x = stage.mouseX;
			_mousePoint.y = stage.mouseY;
			
			if (_mouseOver != null)
			{
				_draggedObject = _mouseOver;
				
				if (_shiftPressed)
				{
					toggleObjectSelected(_mouseOver);
					updateDistances();
				}
			} else {
				if (_shiftPressed)
				{
					deselectAll();
					updateDistances();
				}
			}
		}
		
		public function onMouseReleased(me : MouseEvent):void
		{
			_mouseDown = false;
			_draggedObject = null;
		}
		
		public function onMouseWheel(me : MouseEvent):void
		{
			if (me.delta > 0)
			{
				zoom(1.1);
			} else {
				zoom(.9);
			}
		}
		
		public function toggleObjectSelected(object : Object):void
		{
			if (_selectedObjects.indexOf(object) == -1)
			{
				selectObject(object);
			} else {
				deselectObject(object);
			}
		}
		
		public function selectObject(object : Object):void
		{
			if (_selectedObjects.indexOf(object) == -1)
			{
				_selectedObjects.push(object);
			}
		}
		
		public function deselectObject(object : Object):void
		{
			var i : int = _selectedObjects.indexOf(object);
			
			if (i != -1)
			{
				_selectedObjects.splice(i, 1);
			}
		}
		
		public function deselectAll():void
		{
			_selectedObjects.splice(0, _selectedObjects.length);
		}
		
		public function isSelected(object : Object):Boolean
		{
			return _selectedObjects.indexOf(object) != -1;
		}
		
		public function getCommonObjects(objects : Vector.<Object>):Vector.<Object>
		{
			var output : Vector.<Object> = new Vector.<Object>();
			var b : Vector.<Node> = new Vector.<Node>();
			
			for each (var o : Object in objects)
			{
				b.push(o.node);
			}
			
			b = Node.getCommonNodes(b);
			
			for each (var n : Node in b)
			{
				output.push(nodeDictionary[n]);
			}
			
			return output;
		}
		
		private function zoom(factor : Number ):void
		{
			var matrix : Matrix = new Matrix();
			
			//Where the scaling will be centered
			var ax : Number = 0;
			var ay : Number = 0;
			
			ax = stage.mouseX;
			ay = stage.mouseY;
			
			matrix.translate( -ax, -ay);
			matrix.scale(factor, factor);
			matrix.translate(ax, ay);
			
			var p : Point = new Point();
			
			for each (var o : Object in nodeDictionary)
			{
				p.x = o.x;
				p.y = o.y;
				
				p = matrix.transformPoint(p);
				
				o.x = p.x;
				o.y = p.y;
			}
		}
		
		public function tick():void
		{
			graph.update();
			updateDistances();
		}
		
		public function connectNodes(n1 : Node, n2 : Node):void
		{
			if (n1 is Person)
			{
				var p1 : Person = n1 as Person;
				if (n2 is Person)
				{
					p1.addFriend(n2 as Person, p1.getFriendRelatedness(n2, true, true));
				}
				
				if (n2 is Interest)
				{
					p1.addInterest(n2 as Interest, p1.getFriendRelatedness(n2));
				}
				
				if (n2 is Location)
				{
					p1.addLocation(n2 as Location, p1.getFriendRelatedness(n2));
				}
			}
		}
		
		public function adjustDistance(n1 : Node, n2 : Node, amount : Number):void
		{
			var c : Connection = n1.getConnectionWith(n2);
			
			if (c != null)
			{
				c.distance *= amount;
			}
		}
		
		private function clenchNodes():void
		{
			var i : int = 0;
			for each (var n : Node in graph.nodes)
			{
				i++;
				if (n.connections.length == 0) continue;
				
				var o : Object = nodeDictionary[n];
				
				var tx : Number = 0;// o.x;
				var ty : Number = 0;// o.y;
				
				for each (var c : Connection in n.connections)
				{
					var o2 : Object = nodeDictionary[c.other];
					
					if (o2 != null)
					{
						tx += o2.x;
						ty += o2.y;
					}
				}
				
				//stability factor
				//tx += stage.stageWidth * 2;
				//ty += stage.stageHeight * 2;
				
				if (i % 5 == 0)
				{
					tx += stage.stageWidth * 2;
					ty += stage.stageHeight * 2;
					
					tx /= n.connections.length + 4;
					ty /= n.connections.length + 4;
				} else {
					tx /= n.connections.length;// + 4;
					ty /= n.connections.length;// + 4;
				}
				
				
				o.x = tx;
				o.y = ty;
			}
		}
		
		private function attractCommonNodes():void
		{
			var sn : Vector.<Node> = new Vector.<Node>();
			
			var cx : Number = 0;
			var cy : Number = 0;
			
			for each (var o : Object in _selectedObjects)
			{
				sn.push(o.node);
				cx += o.x;
				cy += o.y;
			}
			
			cx /= _selectedObjects.length;
			cy /= _selectedObjects.length;
			
			var nodes : Vector.<Node> = Node.getCommonNodes(sn);
			
			for each (var n : Node in nodes)
			{
				o = nodeDictionary[n];
				o.x = cx + (Math.random() * 100 - 50);
				o.y = cy + (Math.random() * 100 - 50);
			}
		}
		
		public function onRender(e : Event):void
		{			
			_mouseOver = null;
			
			textDisplay.x = stage.mouseX;
			textDisplay.y = stage.mouseY;
			
			var n : Boolean = false;
			
			//Get highlighted node info
			//update moused over node
			for each (var o : Object in nodeDictionary)
			{
				var dx : Number = o.x - stage.mouseX;
				var dy : Number = o.y - stage.mouseY;
				
				if (dx * dx + dy * dy < 200)
				{
					setDisplayText(o.node.toString());
					_mouseOver = o;
					n = true;
				}
			}
			
			textDisplay.visible = n;
			
			if (_mouseDown)
			{
				dx = stage.mouseX - _mousePoint.x;
				dy = stage.mouseY - _mousePoint.y;
				
				if (_draggedObject == null)
				{
					for each (o in nodeDictionary)
					{
						o.x += dx;
						o.y += dy;
					}
				} else {
					_draggedObject.x += dx;
					_draggedObject.y += dy;
				}
				
				_mousePoint.x = stage.mouseX;
				_mousePoint.y = stage.mouseY;
			}
			
			//breadthFirstPlacement();
			//randomPlacement();
			
			drawNodes();
		}
		
		private function updateDistances():void
		{
			if (_selectedObjects.length == 0)
			{
				for each (var n : Node in graph.nodes)
				{
					var o : Object = nodeDictionary[n];
					o.distance = 0;
				}
			} else {				
				for each (o in nodeDictionary)
				{
					o.distance = 100;
				}
				
				var common : Vector.<Object> = getCommonObjects(_selectedObjects);
				
				for each (o in common)
				{
					o.distance = 0;
				}
				
				for each (o in _selectedObjects)
				{
					o.distance = 0;
				}
			}
		}
		
		private function drawNodes():void
		{
			graphics.clear();
			graphics.beginFill(0, 1);
			graphics.lineStyle(1, 0, 1);
			
			//draw connections before drawing nodes
			for each (var o : Object in nodeDictionary)
			{
				var d1 : Boolean = (o.distance > 1 || o.distance == -1);
				
				for each (var c : Connection in o.node.connections)
				{
					var o2 : Object = nodeDictionary[c.other];
					var d2 : Boolean = (o2.distance > 1 || o2.distance == -1);
					
					var r : int = Math.ceil(0xFF * c.distance);
					if (r > 0xFF) r = 0xFF;
					if (r < 0) r = 0;
					r <<= 16;
					var col : int = 0xFF000000 | r;
					
					var a : Number = 0;
					
					if (d1 || d2)
					{
						a = .01;
					} else {
						a = 1;
					}
					
					graphics.lineStyle((1 - c.distance) * 3, col, a);
					
					if (o2 != null)
					{
						graphics.moveTo(o.x, o.y);
						graphics.lineTo(o2.x, o2.y);
						graphics.endFill();
					}
				}
			}
			
			for each (o in nodeDictionary)
			{				
				d1 = (o.distance > 1 || o.distance == -1);
				
				a = 1;
				
				if (d1)
				{
					a = .1;
				} else {
					a = 1;
				}
				
				if (isSelected(o))
				{
					graphics.lineStyle(2, SELECTED_COLOR, 1);
				} else {
					graphics.lineStyle(1, 0, 0);
				}
				
				if (o.node is Person)
				{
					graphics.beginFill(PERSON_COLOR, a);
					
					graphics.drawRect(o.x, o.y, 10, 10);
				}
				
				if (o.node is Interest)
				{
					graphics.beginFill(INTEREST_COLOR, a);
					
					graphics.drawCircle(o.x, o.y, 5);
				}
				
				if (o.node is Location)
				{
					graphics.beginFill(LOCATION_COLOR, a);
					
					graphics.drawRect(o.x, o.y, 15, 15);
				}
				
				graphics.endFill();
			}
		}
		
	}

}