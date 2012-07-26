package gameui.controls
{
	import gameui.core.GComponent;
	import gameui.data.GPageControlData;
	import gameui.drag.DragData;
	import gameui.drag.DragState;
	import gameui.drag.IDragItem;
	import gameui.drag.IDragTarget;
	import gameui.layout.GLayout;
	import gameui.manager.UIManager;

	import model.PageModel;

	import flash.events.Event;
	import flash.events.MouseEvent;



	/**
	 * Page Control
	 */
	public class GPageControl extends GComponent implements IDragTarget {

		protected var _data : GPageControlData;

		protected var _prev_btn : GButton;

		protected var _page_lb : GLabel;

		protected var _next_btn : GButton;

		protected var _model : PageModel;

		override protected function create() : void {
			_prev_btn = new GButton(_data.prev_buttonData);
			_next_btn = new GButton(_data.next_buttonData);
			_page_lb = new GLabel(_data.labelData);
			addChild(_prev_btn);
			addChild(_next_btn);
			addChild(_page_lb);
		}

		override protected function layout() : void {
			GLayout.layout(_prev_btn);
			GLayout.layout(_page_lb);
			GLayout.layout(_next_btn);
		}

		private function pageModel_pageChangeHandler(event : Event) : void {
			reset();
		}

		private function pageModel_totalChangeHandler(event : Event) : void {
			reset();
		}

		private function reset() : void {
			_page_lb.text = _model.currentPage + "/" + _model.totalPage;
			GLayout.layout(_page_lb);
			_prev_btn.enabled = _model.hasPrevPage;
			_next_btn.enabled = _model.hasNextPage;
		}

		private function initView() : void {
			model = new PageModel();
		}

		private function initEvents() : void {
			_prev_btn.addEventListener(MouseEvent.CLICK, prev_clickHandler);
			_next_btn.addEventListener(MouseEvent.CLICK, next_clickHandler);
		}

		private function prev_clickHandler(event : Event) : void {
			_model.prevPage();
		}

		private function next_clickHandler(event : Event) : void {
			_model.nextPage();
		}

		public function GPageControl(data : GPageControlData) {
			_data = data;
			super(_data);
			initView();
			initEvents();
		}

		public function get label() : GLabel {
			return _page_lb;
		}

		public function set model(value : PageModel) : void {
			if(_model != null) {
				_model.removeEventListener(PageModel.PAGE_CHANGE, pageModel_pageChangeHandler);
				_model.removeEventListener(PageModel.TOTAL_CHANGE, pageModel_totalChangeHandler);
			}
			_model = value;
			if(_model != null) {
				_model.addEventListener(PageModel.PAGE_CHANGE, pageModel_pageChangeHandler);
				_model.addEventListener(PageModel.TOTAL_CHANGE, pageModel_totalChangeHandler);
				reset();
			} else {
				_page_lb.text = "1/1";
				GLayout.layout(_page_lb);
				_prev_btn.enabled = _next_btn.enabled = false;
			}
		}

		public function get model() : PageModel {
			return _model;
		}

		public function dragEnter(dragData : DragData) : Boolean {
			if(UIManager.atParent(dragData.hitTarget, _prev_btn)) {
				_model.prevPage();
				dragData.state = DragState.NEXT;
				return true;
			}
			if(UIManager.atParent(dragData.hitTarget, _next_btn)) {
				_model.nextPage();
				dragData.state = DragState.NEXT;
				return true;
			}
			return false;
		}

		public function canSwap(source : IDragItem,target : IDragItem) : Boolean {
			return true;
		}
	}
}