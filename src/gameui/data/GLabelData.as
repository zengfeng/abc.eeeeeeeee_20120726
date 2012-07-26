package gameui.data {
	import gameui.core.GComponentData;
	import gameui.core.ScaleMode;
	import gameui.manager.UIManager;

	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Game Label Data
	 * 
	 */
	public class GLabelData extends GComponentData
	{
		public var textColor : uint;

		public var textFieldFilters : Array;

		public var textFieldAlpha : Number;

		public var textFormat : TextFormat;

		public var autoSize : String = TextFieldAutoSize.CENTER;

		public var styleSheet : StyleSheet;

		public var hGap : int;

		public var text : String;

		public var maxLength : int;
		
		public var wordWrap:Boolean=false;

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GLabelData = source as GLabelData;
			if (data == null) return;

			data.textColor = textColor;
			data.textFieldFilters = (textFieldFilters ? textFieldFilters.concat() : null);
			data.textFormat = textFormat;
			data.styleSheet = styleSheet;
			data.hGap = hGap;
			data.text = text;
		}

		public function GLabelData()
		{
			textColor = 0xEFEFEF;
			textFieldFilters = UIManager.getEdgeFilters(0x000000,0.7);
			textFieldAlpha = 1;
			textFormat = UIManager.getTextFormat();
			textFormat.font = UIManager.defaultFont;
			textFormat.size = 12;
			textFormat.leading = 3;
			textFormat.kerning = true;
			styleSheet = UIManager.defaultCSS;
			hGap = 0;
			text = "";
			maxLength = 0;
			scaleMode = ScaleMode.AUTO_SIZE;
		}

		override public function clone() : *
		{
			var data : GLabelData = new GLabelData();
			parse(data);
			return data;
		}
	}
}
