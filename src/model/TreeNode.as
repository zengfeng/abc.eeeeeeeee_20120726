package model
{
	import gameui.cell.TreeCell;
	import flash.events.EventDispatcher;

	/**
	 * @author yangyiqiang
	 */
	public class TreeNode extends EventDispatcher
	{
		private var _id : int = 0;

		private var _data : Object;

		private var _targe : TreeCell;

		private var  _parent : TreeNode;

		private var   _children : Vector.<TreeNode>;

		private var  _isOpen : Boolean = false;

		private var _lable : String = "";

		public function TreeNode(parent : TreeNode = null, data : *=null)
		{
			_children = new Vector.<TreeNode>();
			if (!parent) return;
			_parent = parent;
			_data = data;
			_parent.addChild(this);
			_id = parent.id * 1000 + _parent.getChildren().length;
		}

		public function hasChildren() : Boolean
		{
			return _children.length != 0;
		}

		public function containChildData(value : Object) : Boolean
		{
			return queryChildByData(value) != null;
		}

		public function queryChildByData(value : Object) : TreeNode
		{
			for each (var node:TreeNode in _children)
			{
				if (node.getData() == value) return node;
			}
			return null;
		}

		public function addChild(node : TreeNode) : void
		{
			_children.push(node);
		}

		public function removeChild(node : TreeNode) : void
		{
		}

		public function removeChildAt(index : int) : void
		{
			if (index < _children.length)
				_children.splice(index,1);
		}

		public function open() : void
		{
			if (_children.length == 0) return;
		}

		public function close() : void
		{
			if (_children.length == 0) return;
		}

		public function  getParent() : TreeNode
		{
			return _parent;
		}

		public function  getChildren() : Vector.<TreeNode>
		{
			return _children;
		}

		public function getChildrenAt(index : uint) : TreeNode
		{
			if (index < _children.length) return _children[index];
			return null;
		}

		public function setChildren(value : Vector.<TreeNode>) : void
		{
			_children = value;
		}

		public function getData() : Object
		{
			return _data;
		}

		public function setData(value : Object) : void
		{
			_data = value;
		}

		public function setClass(value : Class) : void
		{
			_targe = new value();
		}

		public function getTarge() : TreeCell
		{
			return _targe;
		}

		public function isOpen() : Boolean
		{
			return _isOpen;
		}

		public function setOpen(value : Boolean) : void
		{
			_isOpen = value;
		}

		public function getLable() : String
		{
			if(_lable=="")return _data["lable"];
			return _lable;
		}

		public function setLable(value : String) : void
		{
			_lable = value;
		}

		public function get id() : int
		{
			return _id;
		}

		override public function toString() : String
		{
			return  _lable;
		}
		
		public function clone():TreeNode
		{
			return this;
		}
	}
}
