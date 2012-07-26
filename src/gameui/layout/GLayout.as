package gameui.layout
{
	import gameui.containers.GPanel;
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.manager.UIManager;
	import flash.display.DisplayObject;


	public class GLayout {
		public function GLayout() {
		}

		public static function update(parent : DisplayObject, target : GComponent) : void {
			if (!target) return;
			var a : GAlign = target.align;
			if (!a) return;
			var w : int;
			var h : int;
			if (parent == UIManager.root) {
				w = parent.stage.stageWidth;
				h = parent.stage.stageHeight;
			} else if (parent is GPanel) {
				w = parent.width - GPanel(parent).padding * 2;
				h = parent.height - GPanel(parent).padding * 2;
			} else {
				w = parent.width;
				h = parent.height;
			}
			var l : int = a.left;
			var r : int = a.right;
			var t : int = a.top;
			var b : int = a.bottom;
			var hc : int = a.horizontalCenter;
			var vc : int = a.verticalCenter;
			if (l != -1) {
				target.x = l;
				if (r != -1) target.width = w - l - r;
			} else if (r != -1) {
				target.x = w - target.width - r;
			} else if (hc != -1) {
				target.x = int((w - target.width) * 0.5) + hc;
			}
			if (t != -1) {
				target.y = t;
				if (b != -1) target.height = h - t - b;
			} else if (b != -1) {
				target.y = h - target.height - b;
			} else if (vc != -1) {
				target.y = int((h - target.height) * 0.5) + vc;
			}
		}

		public static function layout(target : DisplayObject, align : GAlign = null) : void {
			if (!target || !target.parent) return;
			var a : GAlign;
			if (align) {
				a = align;
			} else if (target is GComponent) {
				a = GComponent(target).align;
			}
			if (!a) return;
			var w : int;
			var h : int;
			if (target.parent == UIManager.root) {
				w = target.stage.stageWidth;
				h = target.stage.stageHeight;
			} else if (target.parent.name == "content") {
				var panel : GPanel = GPanel(target.parent.parent);
				w = panel.width - panel.padding * 2;
				h = panel.height - panel.padding * 2;
			} else {
				w = target.parent.width;
				h = target.parent.height;
			}
			var l : int = a.left;
			var r : int = a.right;
			var t : int = a.top;
			var b : int = a.bottom;
			var hc : int = a.horizontalCenter;
			var vc : int = a.verticalCenter;
			if (l != -1) {
				target.x = l;
				if (r != -1) target.width = w - l - r;
			} else if (r != -1) {
				target.x = w - target.width - r;
			} else if (hc != -1) {
				target.x = int((w - target.width) * 0.5) + hc;
			}
			if (t != -1) {
				target.y = t;
				if (b != -1) target.height = h - t - b;
			} else if (b != -1) {
				target.y = h - target.height - b;
			} else if (vc != -1) {
				target.y = int((h - target.height) * 0.5) + vc;
			}
		}
	}
}
