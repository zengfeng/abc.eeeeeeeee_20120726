package gameui.containers {
	import gameui.core.GAlign;
	import gameui.core.GComponent;
	import gameui.data.GContainerData;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author yangyiqiang
	 */
	public class GContainer extends GComponent {
		protected var data : GContainerData;

		private function onFocusIn(event : Event) : void {
			addChildAt(event.currentTarget as DisplayObject, this.numChildren == 0 ? 0 : (numChildren - 1));
		}

		override public function addChild(child : DisplayObject) : DisplayObject {
			if (!child) return child;
			if (child is GTitleWindow)
				child.addEventListener(MouseEvent.MOUSE_DOWN, onFocusIn);
			if (!this.parent) {
				data.parent.addChild(this);
				refreshDepth();
			}
			return super.addChild(child);
		}

		override public function addChildAt(child : DisplayObject, index : int) : DisplayObject {
			if (!child) return child;
			child.addEventListener(MouseEvent.MOUSE_DOWN, onFocusIn);
			if (!this.parent) {
				data.parent.addChild(this);
				refreshDepth();
			}
			return super.addChildAt(child, index);
		}

		override public function removeChild(child : DisplayObject) : DisplayObject {
			if (!child) return child;
			child.removeEventListener(MouseEvent.MOUSE_DOWN, onFocusIn);
			if (numChildren == 1) this.hide();
			return super.removeChild(child);
		}

		override public function removeChildAt(index : int) : DisplayObject {
			var child : DisplayObject = getChildAt(index);
			if (!child) return child;
			child.removeEventListener(MouseEvent.MOUSE_DOWN, onFocusIn);
			if (numChildren == 1) this.hide();
			return super.removeChildAt(index);
		}

		private function refreshDepth() : void {
			var num:int=1;
			var child :DisplayObject=data.parent.getChildByName("MAP_CONTAINER");
			if(child){
				data.parent.addChildAt(child, 0);
			}
			child =data.parent.getChildByName("AUTO_CONTAINER");
			if(child){
				data.parent.addChildAt(child, num++);
			}
			child =data.parent.getChildByName("FULL_CONTAINER");
			if(child){
				data.parent.addChildAt(child, num++);
			}
			child =data.parent.getChildByName("UIC_CONTAINER");
			if(child){
				data.parent.addChildAt(child, num++);
			}
			child =data.parent.getChildByName("IOC_CONTAINER");
			if(child){
				data.parent.addChildAt(child, num++);
			}
		}

		public function GContainer(data : GContainerData) {
			this.data = data;
			data.parent = UIManager.root;
			super(data);
		}

		override public  function stageResizeHandler() : void {
			for (var i : int = 0;i < numChildren;i++) {
				var child : DisplayObject = getChildAt(i);
				var component : GComponent = child as GComponent;
				if (component == null) continue;
				component.stageResizeHandler();
				if (component.name == "MenuView") {
					component.x = UIManager.stage.stageWidth - component.width;
					component.y = UIManager.stage.stageHeight - component.height;
					continue;
				}
				if (component is GTitleWindow) {
					var titleWindow : GTitleWindow = component as GTitleWindow;
					if (titleWindow.modal) titleWindow.resizeModal();
					GLayout.layout(component, new GAlign(titleWindow.x, -1, titleWindow.y));
				}
				if (component.align == null) continue;
				if (component is GPanel) {
					var panel : GPanel = component as GPanel;
					if (panel.modal) panel.resizeModal();
				}
				GLayout.update(UIManager.root, component);
			}
		}

		public function initialization() : void {
		}
	}
}
