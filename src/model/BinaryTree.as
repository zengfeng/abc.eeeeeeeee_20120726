package  model {

	public class BinaryTree {

		public var root : BinaryNode;

		public function traverse(node : BinaryNode) : BinaryNode {
			if(!node)return null;
			if(node.left) {
				return node.left;
			}else if(node.right) {
				return node.right;
			} else {
				var parent : BinaryNode = node.parent;
				var next : BinaryNode = node;
				while(parent != null && (next == parent.right || parent.right == null)) {
					next = parent;
					parent = parent.parent;
				}
				if(!parent) {
					return null;
				}
				return parent.right;
			}
		}

		public function toArray(node : BinaryNode) : Array {
			if(node == null || root == null)return null;
			var path : Array = new Array;
			while(node != root) {
				path.push(node.data);
				node = node.parent;
			}
			path.push(root.data);
			path.reverse();
			return path;
		}

		public function clear() : void {
			if(root != null) {
				root.dispose();
				root = null;
			}
		}
	}
}
