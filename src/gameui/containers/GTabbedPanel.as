package gameui.containers
{
	import gameui.controls.GTab;
	import gameui.core.GComponent;
	import gameui.data.GTabbedPanelData;
	import gameui.group.GToggleGroup;

	import flash.display.DisplayObject;
	import flash.events.Event;

	public class GTabbedPanel extends GComponent
	{
		protected var _data : GTabbedPanelData;

		protected var _group : GToggleGroup;

		protected var _viewStack : GViewStack;

		override protected function create() : void
		{
			_group = new GToggleGroup();
			_viewStack = new GViewStack(_data.viewStackData);
			addChild(_viewStack);
		}

		override protected function layout() : void
		{
			_viewStack.x = 0;
			_viewStack.y = _data.tabData.height - 4;
		}

		private function initEvents() : void
		{
			_group.selectionModel.addEventListener(Event.CHANGE, group_changeHandler);
		}

		private function group_changeHandler(event : Event) : void
		{
			_viewStack.selectionModel.index = _group.selectionModel.index;
			_width = _viewStack.width;
			_height = _data.tabData.height + _viewStack.height - 1;
		}

		public function GTabbedPanel(data : GTabbedPanelData)
		{
			_data = data;
			super(_data);
			initEvents();
		}

		public function get selection() : GComponent
		{
			return _viewStack.selection;
		}

		public function get group() : GToggleGroup
		{
			return _group;
		}

		public function addTab(title : String, component : GComponent, index : int = -1) : void
		{
			var tab : GTab = new GTab(_data.tabData);
			tab.text = title;
			if (index != -1)
			{
				_viewStack.addAt(index, component);
				refresh();
				tab.group = _group;
				addChild(tab);
				return;
			}
			var lastTab : GTab = _group.model.getLast() as GTab;
			if (lastTab)
			{
				tab.x = lastTab.x + lastTab.width + _data.tabData.gap;
				tab.y = 0;
			}
			tab.group = _group;
			addChild(tab);
			_viewStack.add(component);
		}

		public function removeTab(component : GComponent) : void
		{
			var index : int = _viewStack.model.remove(component);
			if (index > -1)
			{
				var obj : DisplayObject = _group.model.getAt(index) as DisplayObject;
				_group.model.remove(obj);
				if (this.contains(obj))
					this.removeChild(obj);
			}
			refresh();
		}

		public function refresh() : void
		{
			var lastTab : GTab = _group.model.getAt(0) as GTab;
			if (lastTab)
			{
				lastTab.x = 0;
				for (var i : int = 1;i < _group.model.size;i++)
				{
					if (!lastTab) continue;
					_group.model.getAt(i)["x"] = lastTab.x + lastTab.width + _data.tabData.gap;
					addChild(lastTab);
					lastTab = _group.model.getAt(i) as GTab;
				}
			}
		}
	}
}
