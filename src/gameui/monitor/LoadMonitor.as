package gameui.monitor
{
	import gameui.containers.GPanel;
	import gameui.controls.GLabel;
	import gameui.controls.GProgressBar;
	import gameui.core.GAlign;
	import gameui.data.GLabelData;
	import gameui.data.GPanelData;
	import gameui.data.GProgressBarData;
	import gameui.layout.GLayout;

	import net.LoadModel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;



	public class LoadMonitor extends GPanel {

		protected var _label : GLabel;

		protected var _progressBar : GProgressBar;

		protected var _model : LoadModel;

		protected var _timeout : Timer;

		private function initData() : void {
			_data.align = new GAlign(-1, -1, -1, -1, 0, 0);
			_data.padding = 0;
			_data.width = 400;
			_data.height = 70;
			_data.modal = true;
		}

		override protected function onShow() : void {
			super.onShow();
			GLayout.layout(this);
		}

		private function initView() : void {
			addLabels();
			addProgressBars();
			_timeout = new Timer(500, 1);
			_timeout.addEventListener(TimerEvent.TIMER, timerHandler);
		}

		private function addLabels() : void {
			var data : GLabelData = new GLabelData();
			data.x = 10;
			data.y = 10;
			data.textColor = 0xFFFF00;
			data.width=400;
			_label = new GLabel(data);
			add(_label);
		}

		private function addProgressBars() : void {
			var data : GProgressBarData = new GProgressBarData();
			data.labelData.align = new GAlign(0, -1, 10, -1, -1, -1);
			data.x = 10;
			data.y = 35;
			data.width = 380;
			data.height = 10;
			_progressBar = new GProgressBar(data);
			add(_progressBar);
		}

		private function timerHandler(event : TimerEvent) : void {
			show();
		}

		private function initHandler(event : Event) : void {
			_progressBar.max = _model.total;
			_timeout.reset();
			_timeout.start();
		}

		private function changeHandler(event : Event) : void {
			_progressBar.value = _model.progress;
			_progressBar.text = "加载速度:" + _model.speed + " KB/S";
		}

		private function completeHandler(event : Event) : void {
			if(_timeout.running)_timeout.stop();
			hide();
		}

		private function addModelEvents() : void {
			_model.addEventListener(Event.INIT, initHandler);
			_model.addEventListener(Event.CHANGE, changeHandler);
			_model.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function removeModelEvents() : void {
			_model.removeEventListener(Event.INIT, initHandler);
			_model.removeEventListener(Event.CHANGE, changeHandler);
			_model.removeEventListener(Event.COMPLETE, completeHandler);
		}

		public function LoadMonitor(parent : Sprite) {
			_data = new GPanelData();
			_data.parent = parent;
			initData();
			super(_data);
			initView();
		}

		public function set model(value : LoadModel) : void {
			if(_model)removeModelEvents();
			_model = value;
			if(_model)addModelEvents();
		}

		public function set text(value : String) : void {
			_label.text = value;
		}
	}
}
