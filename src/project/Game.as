package project
{
	import gameui.manager.UIManager;
	import gameui.skin.ASSkin;
	import gameui.theme.BlackTheme;

	import log4a.Logger;
	import log4a.TraceAppender;

	import net.AssetData;
	import net.RESManager;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;




	public class Game extends Sprite {

		protected var _res : RESManager;

		private function addedToStageHandler(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.showDefaultContextMenu = false;
			Logger.addAppender(new TraceAppender());
			ASSkin.setTheme(AssetData.AS_LIB, new BlackTheme());
			UIManager.setRoot(this);
			_res = RESManager.instance;
			initGame();
		}

		protected function initGame() : void {
		}

		public function Game() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
	}
}