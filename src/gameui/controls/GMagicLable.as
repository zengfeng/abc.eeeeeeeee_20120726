package gameui.controls {
	import gameui.data.GLabelData;

	import flash.utils.setTimeout;

	/**
	 * @author yangyiqiang
	 */
	public class GMagicLable extends GLabel
	{
		public function GMagicLable(data : GLabelData)
		{
			super(data);
		}

		private var _num : Number;
		private var _str : String;
		private var _countDown : int;
		private var _otherColor : int;

		public function setMagicText(value : String, num : Number, showMagic : Boolean = true) : void
		{
			if (!showMagic)
			{
				_num = num;
				_str = value;
				end();
				return;
			}
			if (_num == num) return;
			if (_num - num > 0)
			{
				// 减少
				_otherColor = 0xFF0000;
				// _textField.textColor = 0xFFFFFF;
				// TweenLite.to(_textField, 10.6, {alpha:1, textColor:_textField.textColor | 0xFF0000, overwrite:0, ease:Elastic.easeIn, onComplete:end});
			}
			else
			{
				// 增加
				_otherColor = 0x00FF00;
				// _textField.textColor = 0xffffff;
				// TweenLite.to(_textField, 10.6, {alpha:1, textColor:_textField.textColor | 0x00FF00, overwrite:0, ease:Elastic.easeIn, onComplete:end});
			}
			_countDown = 6;
			_num = num;
			_str = value;
			changeColor();
		}

		private function changeColor() : void
		{
			var tempColor : int = _textField.textColor;
			_textField.textColor = _otherColor;
			_otherColor = tempColor;
			_countDown--;

			if (_countDown > 0)
				setTimeout(changeColor, 100);
			else
				end();
		}

		public function set num(value : int) : void
		{
			_num = value;
		}

		private function end() : void
		{
			_textField.textColor = _data.textColor;
			_textField.text = _str;
			layout();
		}
	}
}
