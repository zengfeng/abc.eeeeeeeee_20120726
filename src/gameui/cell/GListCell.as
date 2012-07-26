package gameui.cell {
	import gameui.controls.GLabel;
	import gameui.layout.GLayout;
	/**
	 * Game List Cell
	 * 
	 */
	public class GListCell extends GCell {

		private var _label : GLabel;

		override protected function create() : void {
			super.create();
			_label = new GLabel(_data.labelData);
			addChild(_label);
		}

		public function GListCell(data : GCellData) {
			super(data);
		}

		override public function set source(value : *) : void {
			var data : LabelSource = value as LabelSource;
			if(data == null) {
				_label.clear();
			} else {
				_label.htmlText = data.text;
				GLayout.layout(_label);
			}
			_source = data;
			enabled = (_source != null);
		}
	}
}
