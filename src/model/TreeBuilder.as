package model
{
	import flash.events.EventDispatcher;

	/**
	 * @author yangyiqiang
	 */
	public class TreeBuilder extends EventDispatcher
	{
		private var _source : *;

		private var _root : TreeNode;

		private var tempNode : TreeNode;

		private function initNode(root : TreeNode, _source : *) : void
		{
			if (!_source) return;
			if (_source["childrens"] is Array)
			{
				var node : TreeNode = new TreeNode(root,_source);
				node.setLable(_source["lable"]);
				for each (var data:* in _source["childrens"])
					initNode(node,data);
			}
			else
			{
				tempNode = new TreeNode(root,_source);
				tempNode.setLable(_source["lable"]);
			}
		}

		/**  
		 * 包含自己在内的所有兄弟集 
		 */
		public function getBrothers(node : TreeNode) : Vector.<TreeNode>
		{
			if (!node) return null;
			if (!node.getParent()) return new Vector.<TreeNode>();
			return node.getParent().getChildren();
		}

		public function getRoot() : TreeNode
		{
			return _root;
		}

		public function generateTree(value : *) : TreeNode
		{
			if (!value) return null;
			_source = value;
			_root = new TreeNode();
			if (_source && _source["childrens"] is Array)
			{
				for each (var data:* in _source["childrens"] )
					initNode(_root,data);
			}
			return _root;
		}

		public function addChild(node : TreeNode) : void
		{
			if (!node.getData()["childrens"]) return;
			for each (var data:* in node.getData()["childrens"] )
				initNode(node,data);
		}

		public function removeChild(node : TreeNode) : void
		{
			if (!node) return ;
			if (!node.getParent()) _root = null;
			node.getParent().removeChild(node);
		}
	}
}
