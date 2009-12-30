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
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * Dispatched when the loadRatio or completeRatio changes. 
	 * 
	 * @see Event#CHANGE
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event("change", type="flash.events.Event")]
	
	/**
	 * Dispatched when the group has finished loading. 
	 * 
	 * @see Event#COMPLETE
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event("complete", type="flash.events.Event")]
	
	/**
	 * A class that listens to items being loaded and gives a progress based of contributing weights.
	 * 
	 * <p><b>PreloadGroup ©2009 Alastair Brown. Licensed under the MIT license</b></p>
	 * 
	 * 
	 * @author real_nardan@hotmail.com
	 * @version 1.0
	 * 
	 * @example var group:PreloadGroup = new PreloadGroup("group name");
	 * var subGroup:PreloadGroup = group.createGroup("sub group", 2);
	 * 
	 * group.addEventListener(Event.COMPLETE, loaderCompleteHandler);
	 * group.addEventListener(Event.CHANGE, loaderChangeHandler);
	 * 
	 * subGroup.preload("images/someimage.gif");
	 * 
	 */
	public class PreloadGroup extends EventDispatcher
	{
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
		private var items:Dictionary = new Dictionary(true);
		/** @private */
		private var groups:Object = {};
		/** @private */
		private var _name:String = "";
		/** @private */
		private var _weight:Number = 1;
		/** @private */
		private var _loadedItemsWeight:Number = 0;
		/** @private */
		private var _completedItemsWeight:Number = 0;
		/** @private */
		private var _invalidateTotals:Boolean = false;
		/** @private */
		private var _loadRatio:Number = 0;
		/** @private */
		private var _completeRatio:Number = 0;
		
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
			if(weight < 0) throw new Error("weight must be >= 0");
			this._name =  name;
			this._weight =  weight;
		}
		
		/* **************************************** *
		* Getters + Setters
		* **************************************** */
		/**
		 * Gets the ratio of completed weight to total weight. This does include weights on items that have failed to load.
		 * 
		 * @see loadRatio
		 * @return Number
		 * 
		 */
		public function get completeRatio():Number
		{
			if(_invalidateTotals) calculateTotals();
			return _completeRatio;
		}
	
		/**
		 * Gets the ratio of laoded weight to total weight. This does not include and weights of items that have failed to load.
		 * @see completeRatio 
		 * @return 
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
			_completedItemsWeight = 0;
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
			if(weight < 0) throw new Error("weight must be >= 0");
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
			if(weight < 0) throw new Error("weight must be >= 0");
			items[item] = {weight:weight, loadRatio:0};
			listenToItem(item, true);
			_invalidateTotals =  true;
		}
		
		/**
		 * Preloads an object and the provided URI
		 *  
		 * @param uri
		 * @param weight
		 * 
		 */
		public function preload(uri:String, weight:Number = 1):void
		{
			var loader:URLLoader =  new URLLoader();
			addItem(loader, weight);
			var request:URLRequest =  new URLRequest(uri);
			loader.load(request);
		}
		
		override public function toString():String
		{
			return "[object PreloadGroup name=\""+name+"\"]";
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
		private function groupCompleteHandler(event:Event):void
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
		private function groupChangeHandler(event:Event):void
		{
			//trace("groupChangeHandler "+this);
			_invalidateTotals =  true;
			calculateTotals();
		}
		
		/**
		 * Gets called when the item has completed loading
		 *  
		 * @param event
		 * 
		 */
		private function itemCompleteHandler(event:Event):void
		{
			var item:IEventDispatcher = event.target as IEventDispatcher;
			//trace("itemCompleteHandler "+item);
			listenToItem(item, false);
			var itemObject:Object = items[item];
			_loadedItemsWeight += itemObject.weight;
			_completedItemsWeight += itemObject.weight;
			delete items[item];
			calculateTotals();
		}
		
		/**
		 * Gets called when the item has errored when loading
		 *  
		 * @param event
		 * 
		 */
		private function itemErrorHandler(event:IOErrorEvent):void
		{
			var item:IEventDispatcher = event.target as IEventDispatcher;
			//trace("itemErrorHandler "+item);
			listenToItem(item, false);
			var itemObject:Object = items[item];
			_completedItemsWeight += itemObject.weight;
			delete items[item];
			calculateTotals();
		}
		
		/**
		 * Gets called when an item's progress changes
		 * 
		 * @param event
		 * 
		 */
		private function itemProgressHandler(event:ProgressEvent):void
		{
			//trace(event);
			var item:IEventDispatcher = event.target as IEventDispatcher;
			var itemObject:Object = items[item];
			itemObject.loadRatio = event.bytesLoaded/event.bytesTotal;
			_invalidateTotals =  true;
			calculateTotals();
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
		private function listenToGroup(group:PreloadGroup, state:Boolean): void
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
		private function listenToItem(item:IEventDispatcher, state:Boolean):void
		{
			if(state)
			{
				item.addEventListener(Event.COMPLETE, itemCompleteHandler);
				item.addEventListener(ProgressEvent.PROGRESS, itemProgressHandler);
				item.addEventListener(IOErrorEvent.IO_ERROR, itemErrorHandler);
			}else{
				item.removeEventListener(Event.COMPLETE, itemCompleteHandler);
				item.removeEventListener(ProgressEvent.PROGRESS, itemProgressHandler);
				item.removeEventListener(IOErrorEvent.IO_ERROR, itemErrorHandler);
			}
		}
		
		
		/**
		 * Calculates the total of the loadRatio 
		 * 
		 */
		private function calculateTotals():void
		{
			var totalWeight:Number =  _completedItemsWeight;
			var totalLoadedWeight:Number = _loadedItemsWeight;
			var totalCompletedWeight:Number = _completedItemsWeight;
			var ratioWeight:Number;
			
			//items
			for each(var itemObject:Object in items)
			{
				if(itemObject.weight > 0)
				{
					totalLoadedWeight += itemObject.weight * itemObject.loadRatio;
					totalWeight += itemObject.weight;
				}
			}
			
			//groups
			for each(var group:PreloadGroup in groups)
			{
				if(group.weight > 0)
				{
					totalLoadedWeight += group.weight * group.loadRatio;
					totalCompletedWeight += group.weight * group.completeRatio;
					totalWeight += group.weight;
				}
			}
			
			this._loadRatio = totalLoadedWeight/totalWeight;
			this._completeRatio = totalCompletedWeight/totalWeight;
			_invalidateTotals =  false;
			
			//trace("calculateTotals ", this, _loadRatio, _completeRatio, totalWeight);
			if(this.completeRatio == 1)
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