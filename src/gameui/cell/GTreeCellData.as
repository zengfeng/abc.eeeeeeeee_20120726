package gameui.cell
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;
	import gameui.data.GLabelData;
	import net.AssetData;

	/**
	 * @author yangyiqiang
	 */
	public class GTreeCellData extends GComponentData
	{
		public var upAsset : AssetData;

		public var overAsset : AssetData;

		public var selected_upAsset : AssetData;

		public var selected_overAsset : AssetData;

		public var disabledAsset : AssetData;

		public var labelData : GLabelData;

		public var allowSelect : Boolean ;

		public var clickSelect : Boolean;

		public var allowDoubleClick : Boolean;

		public var lock : Boolean;

		public var index : int;

		public var hotKey : String;

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GCellData = source as GCellData;
			if (data == null) return;
			data.upAsset = upAsset;
			data.overAsset = overAsset;
			data.selected_upAsset = selected_upAsset;
			data.selected_overAsset = selected_overAsset;
			data.disabledAsset = disabledAsset;
			data.labelData = labelData.clone();
			data.allowSelect = allowSelect;
			data.clickSelect = clickSelect;
			data.allowDoubleClick = allowDoubleClick;
			data.lock = lock;
		}

		public function GTreeCellData()
		{
			upAsset = new AssetData("GCell_upSkin");
			overAsset = new AssetData("GCell_overSkin");
			selected_upAsset = new AssetData("GCell_selected_upSkin");
			selected_overAsset == new AssetData("GCell_selected_overSkin");
			disabledAsset = new AssetData("GCell_disabledSkin");
			labelData = new GLabelData();
			allowSelect = true;
			clickSelect = true;
			allowDoubleClick = false;
			lock = false;
			index = -1;
			width = 100;
			height = 22;
			labelData.align = new GAlign(8,-1,-1,-1,-1,0);
		}

		override public function clone() : *
		{
			var data : GTreeCellData = new GTreeCellData();
			parse(data);
			return data;
		}
	}
}
