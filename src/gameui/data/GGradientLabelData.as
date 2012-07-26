package gameui.data
{
    import gameui.skin.SkinStyle;
    import net.AssetData;

    /**
     * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-5-4 ����4:24:02
     */
    public class GGradientLabelData extends GLabelData
    {
		public var gradientAsset : AssetData;
        public function GGradientLabelData()
        {
            super();
			gradientAsset = new AssetData(SkinStyle.gradientLabel_bgSkin);
        }
        
        override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GGradientLabelData = source as GGradientLabelData;
			if (data == null) return;
			data.gradientAsset = gradientAsset;
        }
        
        override public function clone() : *
		{
			var data : GGradientLabelData = new GGradientLabelData();
			parse(data);
			return data;
		}
    }
}
