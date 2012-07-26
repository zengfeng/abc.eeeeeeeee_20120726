package gameui.controls {
	import gameui.cell.GCell;
	import gameui.cell.GCellData;
	import gameui.containers.GPanel;
	import gameui.core.ScaleMode;
	import gameui.data.GAlertData;
	import gameui.data.GGirdData;
	import gameui.data.GTextInputData;
	import gameui.drag.DragData;
	import gameui.drag.DragModel;
	import gameui.drag.DragState;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragSource;
	import gameui.drag.IDragTarget;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import model.GListEvent;
	import model.ListModel;
	import model.ListState;
	import model.PageModel;
	import model.SelectionModel;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;



	/**
	 * Game Gird
	 * 
	 */
	public class GGird extends GPanel implements IDragTarget {

		protected var _girdData : GGirdData;

		protected var _dragModel : DragModel;

		protected var _selectionModel : SelectionModel;

		protected var _model : ListModel;

		protected var _pageModel : PageModel;

		protected var _cell : Class;

		protected var _cellWidth : int;

		protected var _cellHeight : int;

		protected var _cells : Array;

		protected var _selectedCells : Array;

		protected var _dragData : DragData;

		protected var _dragCell : GCell;

		protected var _dragImage :DisplayObject;

		protected var _split_alert : GAlert;

		protected var _remove_alert : GAlert;

		protected var _refs : Array;

		override protected function init() : void {
			_cell = _girdData.cell;
			_cells = new Array();
			_selectedCells = new Array();
			_refs = new Array();
			super.init();
		}

		override protected function create() : void {
			super.create();
			var templet : GCell = new _cell(_girdData.cellData);
			_cellWidth = templet.width;
			_cellHeight = templet.height;
			if(_data.scaleMode == ScaleMode.AUTO_SIZE) {
				_width = _cellWidth * _girdData.columns + (_girdData.columns - 1) * _girdData.hgap + _girdData.padding * 2;
				_height = _cellHeight * _girdData.rows + (_girdData.rows - 1) * _girdData.vgap + _girdData.padding * 2;
			}
			initCells();
			if(_girdData.allowDrag)addAlerts();
		}

		protected function addAlerts() : void {
			_remove_alert = new GAlert(_girdData.alertData);
			_remove_alert.addEventListener(Event.CLOSE, remove_closeHandler);
			var data : GAlertData = _girdData.alertData.clone();
			data.labelData.text = "请输入拆分数量:";
			data.textInputData = new GTextInputData();
			data.textInputData.width = 150;
			data.textInputData.restrict = "0-9";
			data.textInputData.maxChars = 2;
			data.flag = GAlert.OK | GAlert.CANCEL;
			_split_alert = new GAlert(data);
			_split_alert.addEventListener(Event.CLOSE, split_closeHandler);
		}

		protected function initCells() : void {
			_cells = new Array();
			var index : int = 0;
			for(var row : int = 0;row < _girdData.rows;row++) {
				for(var column : int = 0;column < _girdData.columns;column++) {
					var data : GCellData = _girdData.cellData.clone();
					data.x = column * (_cellWidth + _girdData.hgap);
					data.y = row * (_cellHeight + _girdData.vgap);
					data.width = _cellWidth;
					data.height = _cellHeight;
					data.enabled = false;
					if(_girdData.hotKeys != null && index < _girdData.hotKeys.length) {
						data.hotKey = _girdData.hotKeys[index];
					}
					if(_model != null && _model.max > 0 && _cells.length >= _model.max) {
						data.lock = true;
					}
					var cell : GCell = new _cell(data);
					add(cell);
					_cells.push(cell);
					addCellEvents(cell);
					index++;
				}
			}
		}

		protected function updateCells(index : int = 0) : void {
			var start : int = _pageModel.getPageIndex(index);
			var end : int = Math.min(_cells.length, _pageModel.currentSize);
			var len : int = _cells.length;
			var cell : GCell;
			var base : int = _pageModel.base;
			for(var i : int = start;i < len;i++) {
				cell = _cells[i] as GCell;
				if(cell != null)cell.lock = (_model.max > 0 && (base + i) >= _model.max);
				if(i < end) {
					if(cell != null)cell.source = _model.getAt(base + i);
				} else {
					if(cell != null)cell.source = null;
				}
			}
		}

		protected function addCellEvents(cell : GCell) : void {
			if(_girdData.cellData.allowDoubleClick) {
				cell.addEventListener(GCell.DOUBLE_CLICK, cell_doubleClickHandler);
			}
			cell.addEventListener(GCell.SINGLE_CLICK, cell_singleClickHandler);
		}

		protected function removeCellEvents(cell : GCell) : void {
			if(_girdData.cellData.allowDoubleClick) {
				cell.removeEventListener(GCell.DOUBLE_CLICK, cell_doubleClickHandler);
			}
			cell.removeEventListener(GCell.SINGLE_CLICK, cell_singleClickHandler);
		}

		protected function cell_doubleClickHandler(event : Event) : void {
			var index : int = _cells.indexOf(event.target);
			if(index != -1)_selectionModel.index = _pageModel.base + index;
			dispatchEvent(event);
		}

		protected function cell_singleClickHandler(event : Event) : void {
			var index : int = _cells.indexOf(event.target);
			if(index != -1) {
				_selectionModel.index = _pageModel.base + index;
			}
			if(GCell(event.target).ctrlKey) {
				dispatchEvent(event);
				return;
			}
			if(_girdData.allowDrag) {
				_dragCell = GCell(event.target);
				if(_dragCell is IDragSource && _dragCell.source is IDragItem) {
					_dragData.reset(this, _dragCell.source);
					if(GCell(event.target).shiftKey) {
						if(_dragData.source.count > 1 && _dragData.source.max > 1) {
							_split_alert.inputText = "1";
							_split_alert.show();
							_split_alert.moveTo(stage.mouseX, stage.mouseY);
							return;
						}
					} else {
						dragStart();
					}
				}
			}
			dispatchEvent(event);
		}

		protected function stage_mouseMoveHandler(event : MouseEvent) : void {
			if(_dragImage != null) {
				_dragImage.x = int(event.stageX - _dragImage.width * 0.5);
				_dragImage.y = int(event.stageY - _dragImage.height * 0.5);
			}
		}

		override protected function stage_mouseUpHandler(event : MouseEvent) : void {
			var hitTarget : DisplayObject = UIManager.hitTest(stage.mouseX, stage.mouseY);
			if(_dragImage != null) {
				if(UIManager.atParent(hitTarget, this)) {
					if(!_model.allowNull) {
						//restore split at this
						if(_dragData.split != null) {
							_dragData.source.count += _dragData.split.count;
						}
						dragEnd();
						return;
					}
					var c : int = _content.mouseX / (_girdData.cellData.width + _girdData.hgap);
					var r : int = _content.mouseY / (_girdData.cellData.height + _girdData.vgap);
					c = Math.max(0, Math.min(_girdData.columns - 1, c));
					r = Math.max(0, Math.min(_girdData.rows - 1, r));
					var index : int = _pageModel.base + r * _girdData.columns + c;
					_dragData.t_place = _model.place;
					_dragData.t_gird = index;
					if(_model.max > 0 && index >= _model.max) {
						if(_dragData.split != null) {
							_dragData.source.count += _dragData.split.count;
						}
						dragEnd();
						return;
					}
					var target : IDragItem = IDragItem(_model.getAt(index));
					if(target == null) {
						if(_dragData.split == null) {
							_model.setAt(_dragData.s_gird, null);
							_model.setAt(index, _dragData.source);
						} else {
							_model.setAt(index, _dragData.split);
						}
					} else {
						if(target == _dragData.source) {
							dragEnd();
							return;
						}
						if(_dragData.split == null) {
							if(target.merge(_dragData.source)) {
								if(_dragData.source.count == 0) {
									_model.setAt(_dragData.source.gird, null);
								}
							} else {
								_model.setAt(_dragData.source.gird, target);
								_model.setAt(index, _dragData.source);
							}
						} else {
							if(target.merge(_dragData.split)) {
								if(_dragData.split.count > 0) {
									_dragData.source.count += _dragData.split.count;
								}else if(_dragData.source.count == 0) {
									_model.setAt(_dragData.source.gird, null);
								}
							} else {
								_dragData.source.count += _dragData.split.count;
								dragEnd();
								return;
							}
						}
					}
				} else {
					_dragData.hitTarget = hitTarget;
					_dragData.stageX = stage.mouseX;
					_dragData.stageY = stage.mouseY;
					_dragModel.check(_dragData);
					if(_dragData.state == DragState.NEXT) {
						return;
					}
					if(_dragData.state == DragState.END) {
						dragEnd();
						return;
					}
					if(_dragData.state == DragState.REMOVE) {
						dragEnd();
						var count : int = (_dragData.split == null ? _dragData.source.count : _dragData.splitCount);
						_remove_alert.label = "你真的要删除 [" + _dragData.source.name + "] " + count + "个?";
						_remove_alert.show();
						GLayout.layout(_remove_alert);
						return;
					}
					if(_dragData.state == DragState.MOVE) {
						if(_dragData.split == null) {
							_model.setAt(_dragData.s_gird, _dragData.target);
						}
					}else if(_dragData.state == DragState.MERGE) {
						if(_dragData.split == null && _dragData.source.count == 0) {
							_model.setAt(_dragData.s_gird, null);
						}
					}else if(_dragData.state == DragState.CANCEL) {
						if(_dragData.split != null) {
							_dragData.source.count += _dragData.split.count;
						}
					}
				}
				dragEnd();
				_dragData.source.syncMove(_dragData.s_place, _dragData.s_gird, _dragData.t_place, _dragData.t_gird, _dragData.split == null ? "" : _dragData.split.key, _dragData.splitCount);
			} else {
				if(!UIManager.atParent(hitTarget, this)) {
					var outside : Boolean = true;
					if(UIManager.atParent(hitTarget, _menuTrigger)) {
						outside = false;
					}
					if(outside) {
						hide();
					}
				}
			}
		}

		private function dragStart() : void {
			UIManager.dragModal = true;
			_dragCell.enabled = false;
			_dragImage = IDragSource(_dragCell).dragImage;
			_dragImage.x = int(stage.mouseX - _dragImage.width * 0.5);
			_dragImage.y = int(stage.mouseY - _dragImage.height * 0.5);
			stage.addChild(_dragImage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			if(!stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			Mouse.hide();
		}

		private function dragEnd() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			if(stage.hasEventListener(MouseEvent.MOUSE_UP) && _menuTrigger == null) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			}
			UIManager.dragModal = false;
			_dragImage.parent.removeChild(_dragImage);
			_dragImage = null;
			if(_dragCell.source != null && _refs.indexOf(_dragCell.source) == -1) {
				_dragCell.enabled = true;
			}
			Mouse.show();
		}

		private function remove_closeHandler(event : Event) : void {
			var detail : uint = _remove_alert.detail;
			if(detail == GAlert.YES) {
				if(_dragData.split == null) {
					_model.setAt(_selectionModel.index, null);
					IDragItem(_dragData.source).syncRemove();
				} else {
					IDragItem(_dragData.source).syncRemove(_dragData.split.count);	
				}
			}else if(detail == GAlert.NO) {
				if(_dragData.split != null) {
					_dragData.source.count += _dragData.split.count;
				}
			}
		}

		private function split_closeHandler(event : Event) : void {
			var detail : uint = _split_alert.detail;
			if(detail == GAlert.OK) {
				var count : int = int(_split_alert.inputText);
				count = Math.max(0, Math.min(_dragData.source.count, count));
				if(count <= 0) {
					return;
				} else if(count < _dragData.source.count) {
					_dragData.split = _dragData.source.split(count);
					_dragData.splitCount = count;
					dragStart();
				} else {
					dragStart();
				}
			}
		}

		protected function model_changeHandler(event : GListEvent) : void {
			var cell : GCell;
			var state : int = event.state;
			var index : int = event.index;
			var item : Object = event.item;
			var oldItem : Object = event.oldItem;
			switch(state) {
				case ListState.RESET:
					updateCells();
					if(_selectionModel.index >= _model.size)_selectionModel.index = -1;
					break;
				case ListState.ADDED:
					if(!_pageModel.atCurrentPage(index))return;
					cell = _cells[_pageModel.getPageIndex(index)] as GCell;
					if(cell)cell.source = item;
					break;
				case ListState.REMOVED:
					if(!_pageModel.atCurrentPage(index))return;
					updateCells(index);
					if(index < _selectionModel.index) {
						_selectionModel.index -= 1;
					}else if(index == _selectionModel.index) {
						_selectionModel.index = -1;
					}
					break;
				case ListState.UPDATE:
					if(!_pageModel.atCurrentPage(index))return;
					cell = _cells[_pageModel.getPageIndex(index)] as GCell;
					if(cell != null) {
						cell.source = item;
						if(cell.source != null && _refs.indexOf(cell.source) != -1) {
							cell.enabled = false;
						}
					}
					var i : int = _refs.indexOf(oldItem);
					if(oldItem != null && i != -1) {
						_refs.splice(i, 1);
					}
					if(item == null && _selectionModel.index == index) {
						_selectionModel.index = -1;
					}
					break;
				case ListState.INSERT:
					if(!_pageModel.atCurrentPage(index))return;
					updateCells(index);
					if(index <= _selectionModel.index)_selectionModel.index += 1;
					break;
			}
		}

		protected function page_changeHandler(event : Event) : void {
			updateCells(_pageModel.base);
			resetSelected();
		}

		protected function selection_changeHandler(event : Event) : void {
			resetSelected();
		}

		protected function resetSelected() : void {
			var cell : GCell;
			for each(cell in _selectedCells) {
				cell.selected = false;
			}
			_selectedCells.splice(0);
			if(!_pageModel.atCurrentPage(_selectionModel.index))return;
			cell = _cells[_selectionModel.index] as GCell;
			if(cell) {
				cell.selected = true;
				_selectedCells.push(cell);
			}
		}

		protected function addModelEvents() : void {
			_model.addEventListener(GListEvent.CHANGE, model_changeHandler);
			if(_girdData.cellData.allowSelect) {
				_selectionModel.addEventListener(Event.CHANGE, selection_changeHandler);	
			}
		}

		protected function removeModelEvents() : void {
			_model.removeEventListener(GListEvent.CHANGE, model_changeHandler);
			if(_girdData.cellData.allowSelect) {
				_selectionModel.removeEventListener(Event.CHANGE, selection_changeHandler);	
			}
		}

		public function GGird(data : GGirdData) {
			_girdData = data;
			super(data);
			_selectionModel = new SelectionModel();
			_dragModel = new DragModel();
			_dragData = new DragData();
			_model = new ListModel(true, _girdData.rows * _girdData.columns);
			_pageModel = new PageModel(_girdData.rows * _girdData.columns, _model);
			_pageModel.addEventListener(PageModel.PAGE_CHANGE, page_changeHandler);
			addModelEvents();
		}

		public function get selectionModel() : SelectionModel {
			return _selectionModel;
		}

		public function get dragModel() : DragModel {
			return _dragModel;
		}

		public function get pageModel() : PageModel {
			return _pageModel;
		}

		public function set model(value : ListModel) : void {
			if(_model != null) {
				removeModelEvents();
			}
			_model = value;
			_pageModel.listModel = model;
			if(_model != null) {
				addModelEvents();
				_model.update();
			}
		}

		public function get model() : ListModel {
			return _model;
		}

		public function getCellBy(value : int) : GCell {
			return _cells[value];
		}

		public function indeOfCell(cell : GCell) : int {
			return _cells.indexOf(cell);
		}

		public function getCellSize() : int {
			return _cells.length;
		}

		public function get selectionCell() : GCell {
			return _cells[_selectionModel.index];
		}

		public function get selection() : Object {
			return _model.getAt(_selectionModel.index);
		}

		public function dragEnter(dragData : DragData) : Boolean {
			if(!UIManager.atParent(dragData.hitTarget, this)) {
				return false;	
			}
			var local : Point = globalToLocal(new Point(dragData.stageX, dragData.stageY));
			var c : int = (local.x - _girdData.padding) / (_girdData.cellData.width + _girdData.hgap);
			var r : int = (local.y - _girdData.padding) / (_girdData.cellData.height + _girdData.vgap);
			c = Math.max(0, Math.min(_girdData.columns - 1, c));
			r = Math.max(0, Math.min(_girdData.rows - 1, r));
			var index : int = _pageModel.base + r * _girdData.columns + c;
			dragData.t_place = _model.place;
			dragData.t_gird = index;
			if(_model.max != -1 && index >= _model.max) {
				dragData.state = DragState.CANCEL;
				return true;
			}
			var target : IDragItem = _model.getAt(index) as IDragItem;
			if(target == null) {
				dragData.state = DragState.MOVE;
				_model.setAt(index, dragData.split == null ? dragData.source : dragData.split);
				return true;
			} else {
				if(dragData.split == null) {
					if(target.merge(dragData.source)) {
						dragData.state = DragState.MERGE;
						return true;
					}
					if(dragData.owner.canSwap(dragData.source, target)) {
						_model.setAt(index, dragData.source);
						dragData.state = DragState.MOVE;
						dragData.target = target;
						return true;
					}
					dragData.state = DragState.CANCEL;
					return true;
				} else {
					if(target.merge(dragData.split)) {
						if(dragData.split.count > 0) {
							dragData.source.count += dragData.split.count;
						}
						dragData.state = DragState.MERGE;
						return true;
					}
					dragData.state = DragState.CANCEL;
					return true;
				}
			}
			return true;
		}

		public function canSwap(source : IDragItem,target : IDragItem) : Boolean {
			return true;
		}

		public function addRef(value : Object) : void {
			if(_refs.indexOf(value) != -1) {
				return;
			}
			_refs.push(value);
			var cell : GCell;
			cell = getCellBy(_model.indexOf(value));
			if(cell != null) {
				cell.enabled = false;
			}
		}

		public function removeRef(value : Object) : void {
			var index : int = _refs.indexOf(value);
			if(index == -1) {
				return;
			}
			_refs.splice(index, 1);
			var cell : GCell;
			cell = _cells[_model.indexOf(value)];
			if(cell != null) {
				cell.enabled = true;
			}
		}

		public function getRefs() : Array {
			return _refs;
		}
	}
}
