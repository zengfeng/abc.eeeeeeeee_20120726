package gameui.data
{
	import gameui.core.GComponentData;

	import flash.text.StyleSheet;


	public class GStatsData extends GComponentData {
		public var bgColor : uint;
		public var fpsColor : uint;
		public var msColor : uint;
		public var memColor : uint;
		public var maxMemColor : uint;
		public var css : StyleSheet;

		public function GStatsData() {
			width = 70;
			height = 100;
			bgColor = 0x000033;
			fpsColor = 0xffff00;
			msColor = 0x00ff00;
			memColor = 0x00ffff;
			maxMemColor = 0xff0070;
			css = new StyleSheet();
			css.setStyle("xml", {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
			css.setStyle("fps", {color:"#" + fpsColor.toString(16)});
			css.setStyle("ms", {color:"#" + msColor.toString(16)});
			css.setStyle("mem", {color:"#" + memColor.toString(16)});
			css.setStyle("maxMem", {color:"#" + maxMemColor.toString(16)});
		}
	}
}
