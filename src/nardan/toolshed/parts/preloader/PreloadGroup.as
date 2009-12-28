/** 
 * Nardan's Tool-Box
 * Copyright (c) 2009 Alastair Brown real_nardan@hotmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package nardan.toolshed.parts.preloader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	/**
	 * A class that listens to items being loaded and gives a progress based of contributing weights.
	 * 
	 * <br/><b>PreloadGroup ©2009 Alastair Brown. Licensed under the MIT license</b>
	 * 
	 * @author real_nardan@hotmail.com
	 * 
	 */
	public class PreloadGroup extends EventDispatcher
	{
		
		/**
		 * Dispatched when the loadRatio changes. 
		 * 
		 * @see Event#CHANGED
		 * @eventType flash.events.Event.CHANGED
		 */
		[Event("Event.CHANGED", type = "flash.events.Event")]
		
		/**
		 * Dispatched when the group has finished loading. 
		 * 
		 * @see Event#COMPLETE
		 * @eventType flash.events.Event.COMPLETE
		 */
		[Event("Event.COMPLETE", type = "flash.events.Event")]
		
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		/* **************************************** *
		* Static Methods
		* **************************************** */
		/* **************************************** *
		* Properties
		* **************************************** */
		/** @private */
		protected var items:Dictionary = new Dictionary(true);
		/** @private */
		protected var groups:Object = {};
		/** @private */
		protected var _name:String = "";
		/** @private */
		protected var _weight:Number = 1;
		/** @private */
		protected var _loadedItemsWeight:Number = 0;
		/** @private */
		protected var _invalidateTotals:Boolean = false;
		/** @private */
		protected var _loadRatio:Number = 0;
		
		/* **************************************** *
		* Constructor
		* **************************************** */
		/**
		 * Constructor
		 * 
		 * @param name String: Name of group
		 * @param weight Number: Weight of group
		 * 
		 */
		public function PreloadGroup(name:String, weight:Number = 1)
		{
			super(null);
			this._name =  name;
			this._weight =  weight;
		}
		
		/* **************************************** *
		* Getters + Setters
		* **************************************** */
		/**
		 * Gets the current ratio of how much is loaded 
		 * @return Number
		 * 
		 */
		public function get loadRatio():Number
		{
			if(_invalidateTotals) calculateTotals();
			return _loadRatio;
		}

		/**
		 * Gets the name of the group 
		 * @return String
		 * 
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Gets the weight of the group, used for calculating how much the group provides to the total load. 
		 * @return Number 0 <= X <= 1
		 * 
		 */
		public function get weight():Number
		{
			return _weight;
		}
		
		/* **************************************** *
		* Public Methods
		* **************************************** */
		
		/**
		 * Destroys the group and removes any refereneces / event listeners 
		 * 
		 */
		public function destroy():void
		{
			//items
			for(var item:Object in items)
			{
				listenToItem(item as IEventDispatcher, false);
				delete items[item];
			}
			
			//groups
			for each(var group:PreloadGroup in groups)
			{
				group.destroy();
				listenToGroup(group, false);
			}
			groups = {};
			
			_loadedItemsWeight = 0;
			_loadRatio = 0;
		}
		
		
		/**
		 * Creates a sub-group 
		 * @param name String: Name of sub-group.
		 * @param weight Number: Weight of sub-group.
		 * 
		 * @return 
		 * 
		 */
		public function createGroup(name:String, weight:Number = 1):PreloadGroup
		{
			if(groups[name] || name == "") return groups[name];
			
			var group:PreloadGroup =  new PreloadGroup(name, weight);
			groups[name] = group;
			listenToGroup(group, true);
			_invalidateTotals =  true;
			return group;
			
		}
		
		
		/**
		 * Gets the sub-group of the specifed name. 
		 *  
		 * @param name
		 * @return 
		 * 
		 */
		public function getGroup(name:String):PreloadGroup
		{
			return groups[name];
		}
		
		/**
		 * Gets all sub-groups (recursive) with the specifed name
		 *  
		 * @param name
		 * @return 
		 * 
		 */
		public function getGroupsByName(name:String):Array
		{
			var array:Array;
			getGroupsByNameRecursive(this, name, array);
			return array;
		}
		
		
		/**
		 * Adds an item to be listened to for ProgressEvent.PROGRESS &amp; Event.COMPLETE
		 *  
		 * @param item IEventDispatcher
		 * @param weight Number: Weight of item
		 * 
		 */
		public function addItem(item:IEventDispatcher, weight:Number = 1):void
		{
			items[item] = {weight:weight, loadRatio:0};
			listenToItem(item, true);
			_invalidateTotals =  true;
		}
		
		/* **************************************** *
		* Event Handlers
		* **************************************** */
		/**
		 * Gets called when a group finishes it loading
		 *  
		 * @param event
		 * 
		 */
		protected function groupCompleteHandler(event:Event):void
		{
			var group:PreloadGroup = event.target as PreloadGroup;
			//listenToGroup(group, false);
			calculateTotals();
		}
		
		/**
		 * Gets called when a group's loadRatio changes
		 *  
		 * @param event
		 * 
		 */
		protected function groupChangeHandler(event:Event):void
		{
			_invalidateTotals =  true;
			//calculateTotals();
		}
		
		/**
		 * Gets called when the item has completed loading
		 *  
		 * @param event
		 * 
		 */
		protected function itemCompleteHandler(event:Event):void
		{
			var item:IEventDispatcher = event.target as IEventDispatcher;
			listenToItem(item, false);
			var itemObject:Object = items[item];
			_loadedItemsWeight += itemObject.weight;
			delete items[item];
			calculateTotals();
		}
		
		/**
		 * Gets called when an item's progress changes
		 * 
		 * @param event
		 * 
		 */
		protected function itemProgressHandler(event:ProgressEvent):void
		{
			trace(event);
			var item:IEventDispatcher = event.target as IEventDispatcher;
			var itemObject:Object = items[item];
			itemObject.loadRatio = event.bytesLoaded/event.bytesTotal;
			_invalidateTotals =  true;
		}
		/* **************************************** *
		* Protected + Private Methods
		* **************************************** */
		
		/**
		 * Used by <code>getGroupsByName</code>
		 * 
		 * @see getGroupsByName
		 * 
		 * @param parentGroup
		 * @param name
		 * @param array
		 * 
		 */
		private function getGroupsByNameRecursive(parentGroup:PreloadGroup, name:String, array:Array):void
		{
			var key:String;
			var grp:PreloadGroup
			for(key in parentGroup.groups)
			{
				grp = groups[key];
				if(key == name)
				{
					array.push(grp);
				}
				getGroupsByNameRecursive(grp, name, array);
			}
		}
		
		
		/**
		 * Listens/ unlistens to a group 
		 * @param group
		 * @param state
		 * 
		 */
		protected function listenToGroup(group:PreloadGroup, state:Boolean): void
		{
			if(state)
			{
				group.addEventListener(Event.CHANGE, groupChangeHandler);
				group.addEventListener(Event.COMPLETE, groupCompleteHandler);
			}
			else
			{
				group.removeEventListener(Event.CHANGE, groupChangeHandler);
				group.removeEventListener(Event.COMPLETE, groupCompleteHandler);
			}
		}
		
		/**
		 * Listens/unlistens to an item
		 *  
		 * @param item
		 * @param state
		 * 
		 */
		protected function listenToItem(item:IEventDispatcher, state:Boolean):void
		{
			if(state)
			{
				item.addEventListener(Event.COMPLETE, itemCompleteHandler);
				item.addEventListener(ProgressEvent.PROGRESS, itemProgressHandler);
			}else{
				item.removeEventListener(Event.COMPLETE, itemCompleteHandler);
				item.removeEventListener(ProgressEvent.PROGRESS, itemProgressHandler);
			}
		}
		
		
		/**
		 * Calculates the total of the loadRatio 
		 * 
		 */
		protected function calculateTotals():void
		{
			var totalWeight:Number =  _loadedItemsWeight;
			var totalLoadedWeight:Number = _loadedItemsWeight;
			
			//items
			for each(var itemObject:Object in items)
			{
				totalLoadedWeight += itemObject.weight * itemObject.loadRatio;
				totalWeight += itemObject.weight;	
			}
			
			//groups
			for each(var group:PreloadGroup in groups)
			{
				totalLoadedWeight += group.weight * group.loadRatio;
				totalWeight += group.weight;
			}
			
			this._loadRatio = totalLoadedWeight/totalWeight;
			
			
			_invalidateTotals =  false;
			
			if(this.loadRatio == 1)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
	}
}