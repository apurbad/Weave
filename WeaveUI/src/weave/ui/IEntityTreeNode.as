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

	/**
	 * Interface for a node for use with EntityTreeDataDescriptor and EntityTree.
	 * 
	 * @author adufilie 
	 */	
    public interface IEntityTreeNode
    {
		/**
		 * Gets a label for this node.
		 * @return A label to display in the tree.
		 */
		function getLabel():String;
		
		/**
		 * Gets children for this node.
		 * @return A list of children or null if this node has no children
		 */
		function getChildren():ICollectionView;
		
		/**
		 * Checks if this node is a branch.
		 * @return true if this node is a branch
		 */
		function isBranch():Boolean;
		
		/**
		 * Adds a child node.
		 * @param child The child to add.
		 * @param index The new child index.
		 * @return true if successful.
		 */
		function addChildAt(newChild:IEntityTreeNode, index:int):Boolean;
		
		/**
		 * Removes a child node.
		 * @param child The child to remove.
		 * @return true if successful.
		 */
		function removeChild(child:IEntityTreeNode):Boolean;
    }
}
