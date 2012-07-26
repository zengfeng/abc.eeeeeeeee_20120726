package gameui.data
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import net.AssetData;

	public class GTitleBarData extends GComponentData
	{
		public var backgroundAsset : AssetData;

		public var labelData : GLabelData;

		public function GTitleBarData()
		{
			width = 100;
			height = 30;
			labelData = new GLabelData();
			labelData.align = new GAlign(10,-1,-1,-1,-1,0);
			backgroundAsset = new AssetData("GTitleBar_backgroundSkin");
		}
	}
}
