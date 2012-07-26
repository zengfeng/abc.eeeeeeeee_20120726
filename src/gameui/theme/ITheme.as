package  gameui.theme {
	import flash.display.Sprite;

	public interface ITheme {

		function get cssText() : String;

		function get GButton_upSkin() : Sprite;

		function get GButton_overSkin() : Sprite;

		function get GButton_downSkin() : Sprite;

		function get GButton_disabledSkin() : Sprite;

		function get GButton_selectedUpSkin() : Sprite;

		function get GButton_selectedOverSkin() : Sprite;

		function get GButton_selectedDownSkin() : Sprite;

		function get GButton_selectedDisabledSkin() : Sprite;

		function get GProgressBar_trackSkin() : Sprite;

		function get GProgressBar_barSkin() : Sprite;

		function get GPanel_backgroundSkin() : Sprite;

		function get GScrollBar_trackSkin() : Sprite;

		function get GScrollBar_thumbUpSkin() : Sprite;

		function get GScrollBar_thumbOverSkin() : Sprite;

		function get GScrollBar_thumbDownSkin() : Sprite;
	}
}