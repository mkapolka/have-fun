package model.graph 
{
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Person extends Node 
	{
		public static const PERSON_TYPE : String = "Person";
		
		private var _friends : Vector.<Connection> = new Vector.<Connection>();
		private var _interests : Vector.<Connection> = new Vector.<Connection>();
		private var _locations : Vector.<Connection> = new Vector.<Connection>();
		private var _nextLocation : Location;
		
		public function Person() 
		{
			type = PERSON_TYPE;
		}
		
		public function hasFriend(friend : Person):Boolean
		{
			return hasConnectionWith(friend);
		}
		
		public function hasInterest(interest : Interest):Boolean
		{
			return hasConnectionWith(interest);
		}
		
		public function hasLocation(location : Location):Boolean
		{
			return hasConnectionWith(location);
		}
		
		public function addFriend(friend : Person, closeness : Number = 1):void
		{
			if (!hasFriend(friend) && !friend.hasFriend(this))
			{
				var c1 : Connection = new Connection();
				c1.name = "Friendship";
				c1.type = "Friendship";
				c1.distance = closeness;
				c1.other = friend;
				c1.atrophyQuotient = 1.1;
				
				var c2 : Connection = new Connection();
				c2.name = "Friendship";
				c2.type = "Friendship";
				c2.distance = closeness;
				c2.other = this;
				c2.atrophyQuotient = 1.1;
				
				addConnection(c1);
				friend.addConnection(c2);
				
				_friends.push(c1);
				friend._friends.push(c2);
				
				_friends.sort(sort_connection_vector_distance);
			}
		}
		
		public function addInterest(interest : Interest, distance : Number = 0):void
		{
			if (!hasInterest(interest))
			{
				var c1 : Connection = new Connection();
				var c2 : Connection = new Connection();
				
				c1.name = "Interest";
				c2.name = "Interest";
				c1.type = "Interest";
				c2.type = "Interest";
				
				c1.distance = 1;
				c2.distance = distance;
				
				c1.other = this;
				c2.other = interest;
				
				c2.atrophyQuotient = 1.1;
				
				interest.addConnection(c1);
				
				_interests.push(c2);
				addConnection(c2);
				
				_interests.sort(sort_connection_vector_distance);
			}
		}
		
		public function addLocation(location : Location, distance : Number = 0):void
		{
			if (!hasLocation(location))
			{
				var c1 : Connection = new Connection();
				var c2 : Connection = new Connection();
				
				c1.name = "Location";
				c2.name = "Location";
				c1.type = "Location";
				c2.type = "Location";
				
				c1.distance = distance;
				c2.distance = 1;
				
				c1.other = location;
				c2.other = this;
				
				_locations.push(c1);
				addConnection(c1);
				
				location.addConnection(c2);
				
				_interests.sort(sort_connection_vector_distance);
			}
		}		
		
		public function removeInterest(interest : Connection):void
		{
			removeConnection(interest);
			interest.other.removeConnectionWith(this);
			
			var i : int = _interests.indexOf(interest);
			
			if (i != -1)
			{
				_interests.splice(i, 1);
			}
		}
		
		public function removeFriendship(friendship : Connection):void
		{
			removeConnection(friendship);
			friendship.other.removeConnectionWith(this);
			
			var i : int = _friends.indexOf(friendship);
			
			if (i != -1)
			{
				_friends.splice(i, 1);
			}
		}
		
		public function removeLocation(location : Connection):void
		{
			removeConnection(location);
			location.other.removeConnectionWith(this);
			
			var i : int = _locations.indexOf(location);
			
			if (i != -1)
			{
				_locations.splice(i, 1);
			}
		}
		
		/**
		 * Gets this person's relatedness to the target, adjusting for their friends' opinion of it
		 * @param	target Which node to test the relatedness for
		 * @param	doOutbound "Outbound" relatedness- i.e. How much do my friends like this thing?
		 * @param	doInbound "Inbound" relatedness- i.e. How much does this node like what I like?
		 * @return 0-1
		 */
		public function getFriendRelatedness(target : Node, doOutbound : Boolean = true, doInbound : Boolean = false):Number
		{
			//The total weight of connections
			var t_cxns : Number = 0;
			//The total distance of all the connections
			var t_dist : Number = 0;
			
			//My Opinion (For stability + prevention of /0 errors)
			t_cxns += 1;
			var c : Connection = getConnectionWith(target);
			t_dist = c != null?c.distance:1;
			
			if (doOutbound)
			{
				for each (var friend : Connection in _friends)
				{
					var fcxn : Connection = friend.other.getConnectionWith(target);
					
					if (fcxn != null)
					{
						//Weight increases w/ friend distance (negative correlation)
						t_cxns += (1 - friend.distance);
						
						//Friend's opinion of target
						t_dist += fcxn.distance * (1 - friend.distance);
					}
				}
			}
			
			if (doInbound)
			{
				var common : Vector.<Node> = getCommonNodes(target);
				if (common.length > 0)
				{
					var tin : int = 0;
					var tcx : Number = 0;
					
					for each (var n : Node in common)
					{
						tin += 1;
						tcx += target.getConnectionWith(n).distance;
					}
					
					t_cxns += 1;
					t_dist += tcx / tin;
				}
			}
			
			return t_dist / t_cxns;
		}
		
		override public function toString():String
		{
			//var s : String = "Last Visited: " + (_nextLocation==null?"None":_nextLocation.name) + "\n";
			//s += super.toString();
			var s : String = name + "\n";
			s += "Last Location: " + (_nextLocation == null?"None":_nextLocation.name) + "\n";
			s += "AFD: " + getAverageFriendDistance() + "\n";
			for each (var c : Connection in connections)
			{
				s += c.type + ": " + c.other.name + " D: " + c.distance.toFixed(2) + " FR: ";
				s += (c.other is Person?getFriendRelatedness(c.other, true, true):getFriendRelatedness(c.other, true, false)).toFixed(2);
				s += "\n";
			}
			
			return s;
		}
		
		
		override public function preUpdate():void
		{
			super.preUpdate();
			
			decideLocation();
		}
		
		override public function update():void
		{
			super.update();
			
			doFriends();
			doInterests();
			doLocation();
		}
		
		public function getAverageFriendDistance():Number
		{
			var n : int = 0;
			var t : Number = 0;
			for each (var c : Connection in _friends)
			{
				t += c.distance;
				n++;
			}
			
			if (n > 0)
			{
				return t / n;
			} else {
				return 1;
			}
		}
		
		private function doFriends():void
		{
			var toremove : Vector.<Connection> = new Vector.<Connection>();
			
			for each (var c : Connection in _friends)
			{
				if (c.distance > .75)
				{
					toremove.push(c);
					continue;
				}
				
				//friendship atrophy
				//c.influenceDistance(c.distance * 1.1);
				
				/*var nv : Number = 0;
				
				if (Math.random() > c.distance)
				{
					//nv = c.distance * .9;
					nv = c.distance;
				} else {
					nv = c.distance * 1.2;
				}
				
				if (nv > 1) nv = 1;
				if (nv < 0) nv = 0;
				c.influenceDistance(nv);*/
			}
			
			for each (c in toremove)
			{
				removeFriendship(c);
			}
		}
		
		private function doInterests():void
		{
			var toremove : Vector.<Connection> = new Vector.<Connection>();
			
			for each (var c : Connection in _interests)
			{
				if (c.distance > .9)
				{
					toremove.push(c);
					continue;
				}
				/*
				//var cn : Number = getRelatedness(c.other) / _friends.length;
				//var cn : Number = getFriendRelatedness(c.other, true, false);
				
				var d : Number = c.distance;
				
				if (Math.random() < (1 / (_interests.indexOf(c) + 1)))
				{
					d = c.distance * .9;
					//c.influenceDistance(c.distance + .1);
				} else {
					d = c.distance * 1.1;
					//c.influenceDistance(c.distance - .1);
				}
				
				if (d < 0) d = 0;
				if (d > 1) d = 1;
				
				c.influenceDistance(d);*/
			}
			
			for each (c in toremove)
			{
				removeInterest(c);
			}
		}
		
		private function decideLocation():void
		{
			var tn : Number = 0;
			
			for each (var c : Connection in _locations)
			{
				tn += (1 - c.distance);
			}
			
			var r : Number = Math.random() * tn;
			
			tn = 0;
			var visiting : Location = null;
			for each (c in _locations)
			{
				tn += (1 - c.distance);
				if (r < tn)
				{
					visiting = (Location)(c.other);
					break;
				}
			}
			
			_nextLocation = visiting;
			
			if (_nextLocation == null)
			{
				if (_locations.length != 0)
				{
					_nextLocation = _locations[0].other as Location;
				} else {
					return;
				}
			}
			
			_nextLocation.addAttendee(this);
		}
		
		private function doLocation():void
		{
			if (_nextLocation == null) return;
			
			//Visit a location
			mingle(_nextLocation.attendees);
			
			var dictionary : Dictionary = new Dictionary();
			
			var highest : Location = null;
			var highest_n : Number = -Infinity;
			//Figure out where your friends are going
			for each (var c : Connection in _friends)
			{
				var p : Person = c.other as Person;
				
				var loc : Location = p._nextLocation;
				
				if (dictionary[loc] == null)
				{
					dictionary[loc] = 1;				
				} else {
					dictionary[loc] += 1;
				}
				
				if (dictionary[loc] > highest_n)
				{
					highest_n = dictionary[loc];
					highest = loc;
				}
			}
			
			if (highest == null)
			{
				if (_locations.length > 0)
				{
					highest = _locations[0].other as Location;
				} else {
					return;
				}
			}
			
			var has_highest : Boolean = false;
			for each (c in _locations)
			{
				if (c.other == highest)
				{
					c.influenceDistance(c.distance * .9);
					//c.influenceDistance(0);
					has_highest = true;
				} else {
					c.influenceDistance(c.distance * 1.1);
					//c.influenceDistance(.99);
				}
				
				if (c.distance > .9)
				{
					//removeLocation(c);
				}
			}
			
			if (!has_highest)
			{
				addLocation(highest, getFriendRelatedness(highest, true, false));
			}
		}
		
		public function mingle(people : Vector.<Person>):void
		{
			for each (var p : Person in people)
			{
				var c : Connection = connections[p];
				if (c != null)
				{
					if (Math.random() > c.distance)
					{
						hangOutWith(p);
					}
				} else {
					if (Math.random() < (1 / people.length))// getFriendRelatedness(p, true, true))
					{
						hangOutWith(p);
					}
				}
			}
		}
		
		public function hangOutWith(person : Person):void
		{
			if (person == this) return;
				
			var c : Connection = getConnectionWith(person);
			
			if (c != null)
			{
				c.influenceDistance(c.distance * .9);
			
				//share interests
				/*for each (var c2 : Connection in person._interests)
				{
					var i : Interest = c2.other as Interest;
					if (!hasInterest(i))
					{
						var fr : Number = getFriendRelatedness(i, true, false);
						if (Math.random() > fr * 1.5)
						{
							addInterest(i, fr * 1.5);
						}
					}
				}*/
				
				//topic of conversation
				if (_interests.length > 0)
				{
					var ci : Connection = _interests[Math.floor(Math.random() * _interests.length)];
					if (!hasConnectionWith(ci.other))
					{
						var fr : Number = getFriendRelatedness(ci.other, true, false);
						addInterest(ci.other as Interest, fr * 1.5);
					}
				}
			} else {
				var ar : Number = getFriendRelatedness(person, true, true);
				//if (Math.random() > ar)
				//{
					addFriend(person, ar);
				//}
			}
		}
		
	}

}