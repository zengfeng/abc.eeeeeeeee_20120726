package gameui.data
{
	import gameui.core.GComponentData;
	import gameui.skin.SkinStyle;

	import net.AssetData;

	/**
	 * Game Panel Data
	 * 
	 */
	public class GPanelData extends GComponentData
	{
		/**
		 *  Show the scrollbar if the children exceed the owner's dimension.
		 *  The size of the owner is not adjusted to account
		 *  for the scrollbars when they appear, so this may cause the
		 *  scrollbar to obscure the contents of the control or container.
		 */
		public static const AUTO : String = "auto";

		/**
		 *  Never show the scrollbar.
		 */
		public static const OFF : String = "off";

		/**
		 *  Always show the scrollbar.
		 *  The size of the scrollbar is automatically added to the size
		 *  of the owner's contents to determine the size of the owner
		 *  if explicit sizes are not specified.
		 */
		public static const ON : String = "on";

		public var horizontalScrollPolicy : String = AUTO;

		public var verticalScrollPolicy : String = AUTO;
		
		public var bgAsset : AssetData;

		public var modal : Boolean = false;

		public var padding : int = 0;

		public var scrollBarData : GScrollBarData = new GScrollBarData();

		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GPanelData = source as GPanelData;
			if (data == null) return;
			data.bgAsset = bgAsset;
			data.modal = modal;
			data.padding = padding;
			data.horizontalScrollPolicy = data.horizontalScrollPolicy;
			data.verticalScrollPolicy = data.verticalScrollPolicy;
			if (scrollBarData)
				data.scrollBarData = scrollBarData.clone();
		}

		public function GPanelData()
		{
			bgAsset = new AssetData(SkinStyle.panel_backgroundSkin);
			width = 100;
			height = 100;
		}

		override public function clone() : *
		{
			var data : GPanelData = new GPanelData();
			parse(data);
			return data;
		}
	}
}
