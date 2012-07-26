package gameui.controls
{
	import gameui.core.ScaleMode;
	import gameui.cell.LabelSource;
	import gameui.core.GComponent;
	import gameui.data.GLabelData;
	import gameui.manager.UIManager;

	import utils.GStringUtil;

	import flash.display.BlendMode;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Game Label
	 * 
	 */
	public class GLabel extends GComponent
	{
		/**
		 *  @private
		 *  The padding to be added to textWidth to get the width
		 *  of a TextField that can display the text without clipping.
		 */
		private static const TEXT_WIDTH_PADDING : int = 3;

		/**
		 *  @private
		 *  The padding to be added to textHeight to get the height
		 *  of a TextField that can display the text without clipping.
		 */
		private static const TEXT_HEIGHT_PADDING : int = 4;

		protected var _data : GLabelData;

		protected var _textField : TextField;

		override protected function create() : void
		{
			_textField = UIManager.getTextField();
//			_textField.border=true;
//			_textField.thickness=2;
			_textField.mouseEnabled = false;
			_textField.selectable = false;
			_textField.defaultTextFormat = _data.textFormat;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.styleSheet = _data.styleSheet;
			_textField.textColor = _data.textColor;
			_textField.filters = _data.textFieldFilters;
			_textField.text = _data.text;
			if (_data.textFieldAlpha < 1)
			{
				blendMode = BlendMode.LAYER;
				_textField.alpha = _data.textFieldAlpha;
			}
			if(_data.scaleMode==ScaleMode.SCALE9GRID)
				_textField.width = _data.width;
			_textField.wordWrap = _data.wordWrap;
			addChild(_textField);
		}

		override protected function layout() : void
		{
			var textW : int = 0;
			var textH : int = 0;

			if (_textField.text.length > 0)
			{
				textW = _textField.textWidth ;
				textH = _textField.textHeight ;
			}
			_width = _data.hGap + textW + TEXT_WIDTH_PADDING;
			_height = textH + TEXT_HEIGHT_PADDING;

			_textField.x = _data.hGap;
			_textField.y = Math.floor((_height - textH) * 0.5);
			if(_data.scaleMode==ScaleMode.AUTO_SIZE){
				_textField.width = textW;
				_textField.height = textH;
			}
//			if (!_textField.wordWrap)
//			{
//				_textField.width = textW;
//				_textField.height = textH;
//			}
		}

		public function GLabel(data : GLabelData)
		{
			_data = data;
			super(data);
		}

		public function set styleSheet(value : StyleSheet) : void
		{
			_textField.styleSheet = value;
		}

		public function set text(value : String) : void
		{
			_textField.text = GStringUtil.truncateToFit(value, _data.maxLength);
			layout();
		}

		public function get text() : String
		{
			return _textField.text;
		}
		
		public function get textField():TextField
		{
			return _textField;
		}

		public function set textColor(value : uint) : void
		{
			_textField.textColor = value;
		}

		public function set htmlText(value : String) : void
		{
			_textField.htmlText = value;
			layout();
		}

		public function get htmlText() : String
		{
			return _textField.htmlText;
		}

		public function clear() : void
		{
			_textField.text = "";
		}

		override public function set source(value : *) : void
		{
			var data : LabelSource = value as LabelSource;
			if (data == null)
			{
				clear();
			}
			else
			{
				htmlText = data.text;
			}
			_source = data;
		}
	}
}
