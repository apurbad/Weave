/*
	Weave (Web-based Analysis and Visualization Environment)
	Copyright (C) 2008-2011 University of Massachusetts Lowell
	
	This file is a part of Weave.
	
	Weave is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License, Version 3,
	as published by the Free Software Foundation.
	
	Weave is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with Weave.  If not, see <http://www.gnu.org/licenses/>.
*/
package weave.ui
{
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    
    import weave.api.data.ColumnMetadata;
    import weave.api.data.EntityType;
    import weave.api.reportError;
    import weave.api.services.beans.Entity;
    import weave.api.services.beans.EntityHierarchyInfo;
    import weave.services.EntityCache;

	[RemoteClass]
    public class EntityNode implements IEntityTreeNode
    {
		/**
		 * Dual lookup: (EntityCache -> int) and (int -> EntityCache)
		 */
		private static const $cacheLookup:Dictionary = new Dictionary(true);
		private static var $cacheSerial:int = 0;
		
		public static var debug:Boolean = false;
		
		/**
		 * @param entityCache The entityCache which the Entity belongs to.
		 * @param rootFilterEntityType To be used by root node only.
		 * @param nodeFilterFunction Used for filtering children.
		 */
		public function EntityNode(entityCache:EntityCache = null, rootFilterEntityType:String = null, nodeFilterFunction:Function = null)
		{
			if (entityCache && !$cacheLookup[entityCache])
				$cacheLookup[ $cacheLookup[entityCache] = ++$cacheSerial ] = entityCache;
			
			this._cacheId = $cacheLookup[entityCache];
			this._rootFilterEntityType = rootFilterEntityType;
			if (nodeFilterFunction != null)
				_childCollectionView.filterFunction = nodeFilterFunction;
		}
		
		private var _rootFilterEntityType:String = null;
		
		/**
		 * This primitive value is used in place of a pointer to an EntityCache object
		 * so that this object may be serialized & copied by the Flex framework without losing this information.
		 * @private
		 */		
		public var _cacheId:int = 0;
		
		public var id:int = -1;
		
		public function getEntityCache():EntityCache
		{
			return $cacheLookup[_cacheId];
		}
		
		public function getEntity():Entity
		{
			return getEntityCache().getEntity(id);
		}
		
		// the node can re-use the same children array
		private const _childNodes:Array = [];
		private const _childCollectionView:ICollectionView = new ArrayCollection(_childNodes);
		
		// We cache child nodes to avoid creating unnecessary objects.
		// Each node must have its own child cache (not static) because we can't have the same node in two places in a Tree.
		private const _childNodeCache:Object = {}; // id -> EntityNode
		
		public function getLabel():String
		{
			var branchInfo:EntityHierarchyInfo = getEntityCache().getBranchInfo(id);
			if (branchInfo != null)
				return branchInfo.getLabel(debug);
			
			var entity:Entity = getEntity();
			
			var title:String = entity.publicMetadata[ColumnMetadata.TITLE];
			if (!title)
			{
				var name:String = entity.publicMetadata['name'];
				if (name)
					title = '[name: ' + name + ']';
			}
			
			if (!title)
			{
				if (entity.initialized)
					title = lang("{0}#{1}", entity.getEntityType(), entity.id);
				else
					title = '...';
			}
			
			if (debug)
			{
				if (!title)
					title = '[untitled]';
				
				var entityType:String = entity.getEntityType();
				var childrenStr:String = '';
				if (entityType != EntityType.COLUMN)
					childrenStr = '; ' + getChildren().length + ' children';
				var idStr:String = '(' + entityType + "#" + id + childrenStr + ') ' + debugId(this);
				title = idStr + ' ' + title;
			}
			
			return title;
		}
		
		public function isBranch():Boolean
		{
			// root is a branch
			if (_rootFilterEntityType)
				return true;
			
			if (getEntityCache().getBranchInfo(id))
				return true;
			
			var entity:Entity = getEntityCache().getEntity(id);
			
			// columns are leaf nodes
			if (entity.getEntityType() == EntityType.COLUMN)
				return false;
			
			// treat entities that haven't downloaded yet as leaf nodes
			return entity.childIds != null;
		}
		
		public function getChildren():ICollectionView
		{
			var childIds:Array;
			if (_rootFilterEntityType)
			{
				childIds = getEntityCache().getIdsByType(_rootFilterEntityType);
			}
			else
			{
				var entity:Entity = getEntityCache().getEntity(id);
				childIds = entity.childIds;
				if (entity.getEntityType() == EntityType.COLUMN)
					return null; // leaf node
			}
			
			if (!childIds)
			{
				_childNodes.length = 0;
				return isBranch() ? _childCollectionView : null;
			}
			
			var outputIndex:int = 0;
			for (var i:int = 0; i < childIds.length; i++)
			{
				var childId:int = childIds[i];
				var child:EntityNode = _childNodeCache[childId] as EntityNode;
				if (!child)
				{
					child = new EntityNode(getEntityCache());
					child.id = childId;
					_childNodeCache[childId] = child;
				}
				
				if (child.id != childId)
				{
					reportError("BUG: EntityNode id has changed since it was first cached");
					child.id = childId;
				}
				
				_childNodes[outputIndex] = child;
				outputIndex++;
			}
			_childNodes.length = outputIndex;
			
			return _childCollectionView;
		}
		
		public function addChildAt(child:IEntityTreeNode, index:int):Boolean
		{
			var childNode:EntityNode = child as EntityNode;
			if (childNode)
			{
				// does not support adding children from a different EntityCache
				if (getEntityCache() != childNode.getEntityCache())
					return false;
				getEntityCache().add_child(this.id, childNode.id, index);
				return true;
			}
			return false;
		}
		
		public function removeChild(child:IEntityTreeNode):Boolean
		{
			var childNode:EntityNode = child as EntityNode;
			if (childNode)
			{
				// does not support removing children from a different EntityCache
				if (getEntityCache() != childNode.getEntityCache())
					return false;
				childNode.getEntityCache().remove_child(this.id, childNode.id);
				return true;
			}
			return false;
		}
    }
}
