package gameui.data
{
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;
	import net.AssetData;

	public class GScrollBarData extends GComponentData
	{
		public static const VERTICAL : int = 0;

		public static const HORIZONTAL : int = 1;

		public var trackAsset : AssetData = new AssetData(SkinStyle.scrollBar_trackSkin);

		public var thumbButtonData : GButtonData;

		public var upButtonData : GButtonData;

		public var downButtonData : GButtonData;

		public var direction : int = VERTICAL;

		public var wheelSpeed : int = 2;

		public var padding : int = 0;

		public var movePre : int = 25;
		
		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GScrollBarData = source as GScrollBarData;
			if (data == null) return;
			data.trackAsset = trackAsset;
			data.thumbButtonData = (thumbButtonData ? thumbButtonData.clone() : null);
			data.downButtonData = downButtonData;
			data.upButtonData = upButtonData;
			data.direction = direction;
			data.wheelSpeed = wheelSpeed;
			data.movePre = movePre;
		}

		public function GScrollBarData()
		{
			thumbButtonData = new GButtonData();
			thumbButtonData.upAsset = new AssetData(SkinStyle.scrollBar_thumbUpSkin);
			thumbButtonData.overAsset = new AssetData(SkinStyle.scrollBar_thumbOverSkin);
			thumbButtonData.downAsset = new AssetData(SkinStyle.scrollBar_thumbDownSkin);
			thumbButtonData.disabledAsset = null;
			thumbButtonData.width = 10;
			upButtonData = new GButtonData();
			upButtonData.upAsset = new AssetData(SkinStyle.scrollBar_upUpSkin);
			upButtonData.overAsset = new AssetData(SkinStyle.scrollBar_upOverSkin);
			upButtonData.downAsset = new AssetData(SkinStyle.scrollBar_upDownSkin);
			downButtonData = new GButtonData();
			downButtonData.upAsset = new AssetData(SkinStyle.scrollBar_bottomUpSkin);
			downButtonData.overAsset = new AssetData(SkinStyle.scrollBar_bottomOverSkin);
			downButtonData.downAsset = new AssetData(SkinStyle.scrollBar_bottomDownSkin);
			upButtonData.width = 10;
			upButtonData.height = 10;
			downButtonData.width = 10;
			downButtonData.height = 10;
			width = 10;
			height = 100;
		}

		override public function clone() : *
		{
			var data : GScrollBarData = new GScrollBarData();
			parse(data);
			return data;
		}
	}
}
