package gameui.containers
{
	import gameui.cell.GCell;
	import gameui.cell.TreeCell;
	import gameui.data.GTreePanelData;

	import model.TreeBuilder;
	import model.TreeNode;

	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * @author yangyiqiang
	 */
	public class GTreePanel extends GPanel
	{
		public var cell : Class = TreeCell;

		protected var _model : TreeBuilder;

		protected var _cellDic : Dictionary;

		private  function initTree() : void
		{
			_cellDic = new Dictionary(true);
			addCells(_model.getRoot());
		}

		private function addCells(parent : TreeNode) : void
		{
			var max : int = parent.getChildren().length;
			var tempClass : TreeCell;
			for (var i : int = 0;i < max;i++)
			{
				if (!_cellDic[parent.getChildren()[i]])
				{
					parent.getChildren()[i].setClass(cell);
				}
				tempClass = parent.getChildren()[i].getTarge();
				tempClass.source = parent.getChildren()[i];
				tempClass.x = getStartX(parent.getChildren()[i]);
				tempClass.y = getStartY(parent.getChildren()[i]);
				_cellDic[parent.getChildren()[i]] = tempClass;
				add(tempClass);
				if (parent.getChildren()[i].isOpen())
				{
					addCells(parent.getChildren()[i]);
				}
			}
		}

		private function removeCells(parent : TreeNode) : void
		{
			var children : Vector.<TreeNode> = parent.getChildren();
			parent.getTarge().selected=false;
			for each (var node:TreeNode in children)
			{
				node.setOpen(false);
				if (!node.getTarge()) continue;
				node.getTarge().hide();
				node.getTarge().selected = false;
				if (node.getChildren().length > 0)
				{
					removeCells(node);
				}
			}
		}

		private var _maxH : int = 0;

		private var _maxW : int = 0;

		private function resetList(parent : TreeNode) : void
		{
			var brothers : Vector.<TreeNode> = _model.getBrothers(parent);
			for each (var value:TreeNode in brothers)
			{
				if (parent.id >= value.id) continue;
				if (!TreeCell(_cellDic[value])) continue;
				// TweenLite.to(TreeCell(_cellDic[value]), 0.2, {y:getStartY(value)});
				TreeCell(_cellDic[value]).y = getStartY(value);
			}
			if (parent.getParent())
				resetList(parent.getParent());
		}

		private function getStartX(node : TreeNode) : int
		{
			var xx : int = 0;
			while (node.getParent())
			{
				node = node.getParent();
				if (!node.getParent()) break;
				xx += data.vGap;
			}
			_maxW = _maxW > xx ? _maxW : xx;
			return xx;
		}

		private function getStartY(node : TreeNode) : int
		{
			var num : int = getParentNum(node,num);
			while (node.getParent())
			{
				num = getParentNum(node.getParent(),num);
				node = node.getParent();
				if (!node.getParent()) break;
				num++;
			}
			var num2 : int = (num + 1) * (data.itemHeight + data.hGap);
			_maxH = _maxH > num2 ? _maxH : num2;
			return num * (data.itemHeight + data.hGap);
		}

		/**
		 *当前显示列表中 一共有多少个字节点的y比本节点小 
		 */
		private function getParentNum(node : TreeNode, num : int) : int
		{
			var brothers : Vector.<TreeNode> = _model.getBrothers(node);
			for each (var value:TreeNode in brothers)
			{
				if (node.id <= value.id) continue;
				num++;
				num = getChildrenNum(value,num);
			}
			return num;
		}

		/**
		 * 求出已打开树里子节点的个数
		 */
		private function getChildrenNum(node : TreeNode, num : int) : int
		{
			if (!node.isOpen()) return num;
			num += node.getChildren().length;
			for each (var value:TreeNode in node.getChildren())
				num = getChildrenNum(value,num);
			return num;
		}

		private function initEvent() : void
		{
			addEventListener(GCell.SINGLE_CLICK,onSincleClick);
		}

		private function onSincleClick(event : Event) : void
		{
			var obj : TreeCell = event.target as TreeCell;
			if (!obj) return;
			var brothers : Vector.<TreeNode> = _model.getBrothers(obj.source);
			for each (var node:TreeNode in brothers)
			{
				if (!node.isOpen()) continue;
				if (node == obj.source) continue;
				TreeCell(_cellDic[node]).selected = false;
				node.setOpen(false);
				closeTreeItem(node);
			}
			obj.selected ? openTreeItem(obj.source) : closeTreeItem(obj.source);
		}

		public function openTreeItem(node : TreeNode) : void
		{
			_maxH = data.height;
			node.setOpen(true);
			addCells(node);
			resetList(node);
			refreshMaxH();
			layout();
		}

		public function closeTreeItem(node : TreeNode) : void
		{
			_maxH = data.height;
			node.setOpen(false);
			removeCells(node);
			resetList(node);
			refreshMaxH(false);
			layout();
		}

		private function refreshMaxH(max : Boolean = true) : void
		{
			if (data.variableH)
			{
				if (max)
					_height = _maxH > _height ? _maxH : _height;
				else
					_height = _maxH < _height ? _maxH : _height;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function addNode(node : TreeNode) : void
		{
			_maxH = data.height;
			_model.addChild(node);
			addCells(node.getParent());
			resetList(node);
			refreshMaxH();
			layout();
		}

		public function removeNode(node : TreeNode) : void
		{
			_maxH = data.height;
			_model.removeChild(node);
			removeCells(node);
			TreeCell(_cellDic[node]).hide();
			delete _cellDic[node];
			resetList(node);
			refreshMaxH(false);
			layout();
		}

		public function get model() : TreeBuilder
		{
			return _model;
		}

		override public function set source(value : *) : void
		{
			_source = value;
			_model = new TreeBuilder();
			_model.generateTree(_source);
			initTree();
		}

		override public function show() : void
		{
			super.show();
		}

		override public function hide() : void
		{
			removeEventListener(GCell.SINGLE_CLICK,onSincleClick);
			super.hide();
		}

		public function clear() : void
		{
			_maxH = 20;
			_maxW = 0;
			this.clearContent();
			layout();
		}

		private var data : GTreePanelData;

		public function GTreePanel(data : GTreePanelData)
		{
			this.data = data;
			super(data);
			initEvent();
		}
	}
}
