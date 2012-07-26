package  model {
	import core.IDispose;
	public class BinaryNode implements IDispose {

		protected var _parent : BinaryNode;

		protected var _left : BinaryNode;

		protected var _right : BinaryNode;

		protected var _data : Object;

		public function BinaryNode(value : Object) {
			_data = value;
		}

		public function set parent(value : BinaryNode) : void {
			_parent = value;
		}

		public function get parent() : BinaryNode {
			return _parent;
		}

		public function set left(value : BinaryNode) : void {
			if(!_left) {
				_left = value;
				_left.parent = this;
			} else {
				_left.data = data;
			}
		}

		public function get left() : BinaryNode {
			return _left;
		}

		public function set right(value : BinaryNode) : void {
			if(!_right) {
				_right = value;
				_right.parent = this;
			} else {
				_right.data = data;
			}
		}

		public function get right() : BinaryNode {
			return _right;
		}

		public function set data(value : Object) : void {
			_data = value;
		}

		public function get data() : Object {
			return _data;
		}

		public function isLeft() : Boolean {
			return this == parent.left;
		}

		public function isRight() : Boolean {
			return this == parent.right;
		}

		public function getDepth(node : BinaryNode = null) : int {
			var left : int = -1, right : int = -1;
			if (node == null) node = this;
			if (node.left) {
				left = getDepth(node.left);
			}
			if (node.right) {
				right = getDepth(node.right);
			}
			return ((left > right ? left : right) + 1);
		}

		public function count() : int {
			var c : int = 1;
			if (left != null) {
				c += left.count();
			}
			if (right != null) {
				c += right.count();
			}
			return c;
		}

		public function dispose() : void {
			if(left != null) {
				left.dispose();
				left = null;
			}
			if(right != null) {
				right.dispose();
				right = null;
			}
		}
	}
}
