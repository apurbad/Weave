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
    import mx.collections.ICollectionView;
    import mx.controls.treeClasses.ITreeDataDescriptor;
    
	/**
	 * Tells a Tree control how to work with IEntityTreeNode objects.
	 * 
	 * @author adufilie
	 */
    public class EntityTreeDataDescriptor implements ITreeDataDescriptor
    {
        public function getChildren(node:Object, model:Object = null):ICollectionView
        {
			return (node as IEntityTreeNode).getChildren();
        }
        
		public function hasChildren(node:Object, model:Object = null):Boolean
        {
			var children:ICollectionView = getChildren(node, model);
			return children != null;
        }
        
		public function isBranch(node:Object, model:Object = null):Boolean
        {
			return (node as IEntityTreeNode).isBranch();
        }
		
		/**
		 * A non-op which returns a pointer to the node.
		 * @param node
		 * @param model
		 * @return The node itself. 
		 */		
        public function getData(node:Object, model:Object = null):Object
        {
			return node as IEntityTreeNode;
        }
        
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object = null):Boolean
        {
			var parentNode:IEntityTreeNode = parent as IEntityTreeNode;
			var childNode:IEntityTreeNode = newChild as IEntityTreeNode;
			if (parentNode && childNode)
				return parentNode.addChildAt(childNode, index);
			return false;
        }
        
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object = null):Boolean
        {
			var parentNode:IEntityTreeNode = parent as IEntityTreeNode;
			var childNode:IEntityTreeNode = child as IEntityTreeNode;
			if (parentNode && childNode)
				return parentNode.removeChild(childNode);
			return false;
        }
    }
}
