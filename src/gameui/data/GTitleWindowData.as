package gameui.data
{
	import effects.HideEffect;
	import gameui.core.GComponentData;
	import net.AssetData;
	public class GTitleWindowData extends GComponentData{

		public var titleBarData:GTitleBarData;
		
		public var modal:Boolean=false;
		
		public var allowDrag:Boolean=false;
		
		public var allowScale:Boolean=false;
		
		public var panelData:GPanelData=new GPanelData();
		
		public var closeButtonData:GButtonData=new GButtonData();
		
		public function GTitleWindowData():void{
			width=100;
			height=100;
			closeButtonData.width=closeButtonData.height=20;
			closeButtonData.downAsset=new AssetData("close_button_down_skin");
			closeButtonData.upAsset=new AssetData("close_button_up_skin");
			closeButtonData.disabledAsset=new AssetData("close_button_down_skin");
			closeButtonData.overAsset=new AssetData("close_button_over_skin");
			hideEffect=new HideEffect();
			titleBarData=new GTitleBarData();
		}
	}
}
