package org.component.flixel 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.Message;
	import org.flixel.FlxCamera;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FlxObjectComponent extends Component 
	{
		public static const HIDE : String = "hide";
		public static const SHOW : String = "show";
		public static const ENABLE : String = "enable";
		public static const DISABLE : String = "disable";
		
		private static var _group : FlxGroup = new FlxGroup();
		private static var _objectComponents : Vector.<FlxObjectComponent> = new Vector.<FlxObjectComponent>();
		private static var _groupInitialized : Boolean = false;
		
		protected var _object : FlxObject;
		protected var _depth : Number;
		
		public function FlxObjectComponent() 
		{
			super();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_group.remove(_object, true);
			_objectComponents.splice(_objectComponents.indexOf(this), 1);
		}
		
		public static function get group():FlxGroup
		{
			return _group;
		}
		
		public static function get objectComponents():Vector.<FlxObjectComponent>
		{
			return _objectComponents;
		}
		
		public static function getObjectsAt(x : Number, y : Number, inScreenSpace : Boolean = false, camera : FlxCamera = null):Vector.<FlxObjectComponent>
		{
			var output : Vector.<FlxObjectComponent> = new Vector.<FlxObjectComponent>();
			
			var p : FlxPoint = new FlxPoint(x, y);
			
			for each (var component : FlxObjectComponent in _objectComponents)
			{
				if (component.object.overlapsPoint(p, inScreenSpace, camera))
				{
					output.push(component);
				}
			}
			
			return output;
		}
		
		public function get object():FlxObject
		{
			return _object;
		}
		
		public function set object(o : FlxObject):void
		{			
			_object = o;
		}
		
		override public function set entity(entity : Entity):void
		{
			_entity = entity;
		}
		
		public function get depth():Number
		{
			return _depth;
		}
		
		public function set depth(n : Number):void
		{
			_depth = n;
			sortObjects();
		}
		
		public static function initializeGroup():void
		{
			if (!_groupInitialized)
			{
				_group = new FlxGroup();
				FlxG.state.add(_group);
				_groupInitialized = true;
			}
		}
		
		public static function deinitializeGroup():void
		{
			if (_group != null)
			{
				if (FlxG.state != null)
				{
					FlxG.state.remove(_group, true);
				}
				
				_group.clear();
				_group = null;// new FlxGroup();
				_groupInitialized = false;
			}
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			if (!_groupInitialized)
			{
				initializeGroup();
			}
			
			addObject();
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == HIDE)
			{
				_object.visible = false;
			}
			
			if (message.type == SHOW)
			{
				_object.visible = true;
			}
			
			if (message.type == DISABLE)
			{
				_object.active = false;
			}
			
			if (message.type == ENABLE)
			{
				_object.active = true;
			}
		}
		
		protected function addObject():void
		{
			_objectComponents.push(this);
			_group.add(_object);
			
			sortObjects();
		}
		
		protected static function sortObjects():void
		{
			_objectComponents.sort(objects_compare);
			
			for (var i : int = 0; i < _objectComponents.length; i++)
			{
				_group.members[i] = _objectComponents[i].object;
			}
		}
		
		private static function objects_compare(A : FlxObjectComponent, B : FlxObjectComponent):int
		{
			if (A._depth > B._depth) return 1;
			if (B._depth > A._depth) return -1;
			return 0;
		}
		
		override public function loadContent(xml : XML):void
		{
			object = new FlxObject(0, 0, 0, 0);
			
			loadPositionData(xml);
		}
		
		protected function loadPositionData(xml : XML):void
		{			
			if (xmlElementExists(xml, "x"))
			{
				_object.x = parseFloat(xml.x);
			}
			
			if (xmlElementExists(xml, "y"))
			{
				_object.y = parseFloat(xml.y);
			}
			
			if (xmlElementExists(xml, "width"))
			{
				_object.width = parseFloat(xml.width);
			}
			
			if (xmlElementExists(xml, "height"))
			{
				_object.height = parseFloat(xml.height);
			}
			
			if (xmlElementExists(xml, "angular_velocity"))
			{
				_object.angularVelocity = parseFloat(xml.angular_velocity);
			}
			
			if (xmlElementExists(xml, "drag_x"))
			{
				_object.drag.x = parseFloat(xml.drag_x);
			}
			
			if (xmlElementExists(xml, "drag_y"))
			{
				_object.drag.y = parseFloat(xml.drag_y);
			}
			
			if (xmlElementExists(xml, "acceleration_y"))
			{
				_object.acceleration.y = parseFloat(xml.acceleration_y);
			}
			
			if (xmlElementExists(xml, "acceleration_x"))
			{
				_object.acceleration.x = parseFloat(xml.acceleration_x);
			}
			
			if (xmlElementExists(xml, "velocity_x"))
			{
				_object.velocity.x = parseFloat(xml.velocity_x);
			}
			
			if (xmlElementExists(xml, "velocity_y"))
			{
				_object.velocity.y = parseFloat(xml.velocity_y);
			}
			
			if (xmlElementExists(xml, "solid"))
			{
				var b : Boolean = extractXMLBoolean(xml.solid);
				
				_object.solid = b;
			}
			
			if (xmlElementExists(xml, "immovable"))
			{
				_object.immovable = extractXMLBoolean(xml.immovable);
			}
			
			if (xmlElementExists(xml, "visible"))
			{
				_object.visible = extractXMLBoolean(xml.visible);
			}
			
			if (xmlElementExists(xml, "depth"))
			{
				_depth = parseFloat(xml.depth);
			}
			
			if (xmlElementExists(xml, "scrollfactor_x"))
			{
				object.scrollFactor.x = parseFloat(xml.scrollfactor_x);
			}
			
			if (xmlElementExists(xml, "scrollfactor_y"))
			{
				object.scrollFactor.y = parseFloat(xml.scrollfactor_y);
			}
			
		}
		
	}

}