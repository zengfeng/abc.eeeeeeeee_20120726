package gameui.controls
{
	import gameui.data.GGradientLabelData;
	import gameui.manager.UIManager;

	import flash.display.DisplayObject;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-5-4 ����4:23:22
     */
    public class GGradientLabel extends GLabel
    {
        protected var _gradientLabelData : GGradientLabelData;
        protected var _gradientBg : DisplayObject;

        public function GGradientLabel(data : GGradientLabelData)
        {
            _gradientLabelData = data;
            super(data);
			this.filters = _data.textFieldFilters;
        }

        override protected function create() : void
        {
            _gradientBg = UIManager.getUI(_gradientLabelData.gradientAsset);
            _gradientBg.cacheAsBitmap = true;
            addChildAt(_gradientBg, 0);
            super.create();
            _gradientBg.x = _textField.x;
            _gradientBg.y = _textField.y;
            _gradientBg.width = _textField.width;
            _gradientBg,height = _textField.height;
            _textField.cacheAsBitmap = true;
			_textField.filters = [];
            _gradientBg.mask = _textField;
        }

        override protected function layout() : void
        {
            _gradientBg.cacheAsBitmap = false;
            _textField.cacheAsBitmap = false;
            super.layout();
            _gradientBg.x = _textField.x;
            _gradientBg.y = _textField.y;
            _gradientBg.width = _textField.width;
            _gradientBg,height = _textField.height;
            _gradientBg.cacheAsBitmap = true;
            _textField.cacheAsBitmap = true;
        }
    }
}
