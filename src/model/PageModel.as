package  model {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Page Model
	 */
	public class PageModel extends EventDispatcher {

		public static const PAGE_CHANGE : String = "pageChange";

		public static const TOTAL_CHANGE : String = "totalChange";

		private var _currentPage : uint = 1;

		private var _totalPage : uint = 1;

		private var _pageSize : uint = 10;

		private var _base : int = 0;

		private var _listModel : ListModel;

		private function list_resizeHandler(event : Event) : void {
			resetSize();
		}

		private function resetSize() : void {
			totalPage = Math.ceil(_listModel.size / _pageSize);
		}

		public function PageModel(pageSize : int = 10,model : ListModel = null) {
			_pageSize = pageSize;
			listModel = model;
		}

		public function set listModel(value : ListModel) : void {
			if(_listModel != null) {
				_listModel.addEventListener(Event.RESIZE, list_resizeHandler);
			}
			_listModel = value;
			if(_listModel != null) {
				resetSize();
				_listModel.addEventListener(Event.RESIZE, list_resizeHandler);
			}
		}

		public function set pageSize(value : int) : void {
			if(_pageSize == value)return;
			_pageSize = value;
		}

		public function get pageSize() : int {
			return _pageSize;
		}

		public function set currentPage(value : int) : void {
			value = Math.max(1, Math.min(_totalPage, value));
			if(_currentPage == value)return;
			_currentPage = value;
			_base = (_currentPage - 1) * _pageSize;
			dispatchEvent(new Event(PageModel.PAGE_CHANGE));
		}

		public function get currentPage() : int {
			return _currentPage;
		}

		public function get base() : int {
			return _base;
		}

		public function get currentSize() : int {
			return (_listModel == null ? _pageSize : Math.min(_pageSize, _listModel.size));
		}

		public function set totalPage(value : int) : void {
			value = Math.max(1, value);
			if(_totalPage == value)return;
			_totalPage = value;
			dispatchEvent(new Event(PageModel.TOTAL_CHANGE));
			if(_currentPage > _totalPage) {
				_currentPage = totalPage;
				_base = (_currentPage - 1) * _pageSize;
				dispatchEvent(new Event(PageModel.PAGE_CHANGE));
			}
		}

		public function get totalPage() : int {
			return _totalPage;
		}

		public function get hasPrevPage() : Boolean {
			return _currentPage > 1;
		}

		public function prevPage() : void {
			if(_currentPage < 2)return;
			_currentPage--;
			_base = (_currentPage - 1) * _pageSize;
			dispatchEvent(new Event(PageModel.PAGE_CHANGE));
		}

		public function get hasNextPage() : Boolean {
			return _currentPage < _totalPage;
		}

		public function nextPage() : void {
			if(_currentPage >= _totalPage)return;
			_base = _currentPage * _pageSize;
			_currentPage++;
			dispatchEvent(new Event(PageModel.PAGE_CHANGE));
		}

		public function atCurrentPage(index : int) : Boolean {
			if(index < 0)return false;
			return int(index / _pageSize) + 1 == _currentPage;
		}

		public function getPageIndex(index : int) : int {
			return index % _pageSize;
		}
	}
}