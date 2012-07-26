package gameui.monitor
{
	import gameui.core.GComponent;
	import gameui.data.GStatsData;

	import utils.SystemUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;



	public class GStatus extends GComponent {

		private var _data : GStatsData;

		private var _xml : XML;

		private var _label : TextField;

		private var _timer : uint;

		private var _fps : uint;

		private var _ms : uint;

		private var _prev_ms : uint;

		private var _mem : Number;

		private var _maxMem : Number;

		private var _graph : Bitmap;

		private var _rect : Rectangle;

		private var _fps_graph : uint;

		private var _mem_graph : uint;

		private var _maxMem_graph : uint;

		override protected function create() : void {
			_xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><maxMem>MAX:</maxMem></xml>;
			graphics.beginFill(_data.bgColor);
			graphics.drawRect(0, 0, _data.width, _data.height);
			graphics.endFill();
			_label = new TextField();
			_label.width = _data.width;
			_label.height = 50;
			_label.styleSheet = _data.css;
			_label.condenseWhite = true;
			_label.selectable = false;
			_label.mouseEnabled = false;
			addChild(_label);
			_graph = new Bitmap();
			_graph.y = 50;
			_graph.bitmapData = new BitmapData(_data.width, _data.height - 50, false, _data.bgColor);
			_rect = new Rectangle(_data.width - 1, 0, 1, _data.height - 50);
			addChild(_graph);
		}

		override protected function onShow() : void {
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		override protected function onHide() : void {
			removeEventListener(MouseEvent.CLICK, clickHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function clickHandler(event : MouseEvent) : void {
			SystemUtil.gc();
		}

		private function enterFrameHandler(event : Event) : void {
			_timer = getTimer();
			if(_timer - 1000 > _prev_ms) {
				_prev_ms = _timer;
				_mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				_maxMem = _maxMem > _mem ? _maxMem : _mem;
				_fps_graph = Math.min(_graph.height, (_fps / stage.frameRate) * _graph.height);
				_mem_graph = Math.min(_graph.height, Math.sqrt(Math.sqrt(_mem * 5000))) - 2;
				_maxMem_graph = Math.min(_graph.height, Math.sqrt(Math.sqrt(_maxMem * 5000))) - 2;
				_graph.bitmapData.scroll(-1, 0);
				_graph.bitmapData.fillRect(_rect, _data.bgColor);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - _fps_graph, _data.fpsColor);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - ((_timer - _ms ) >> 1 ), _data.msColor);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - _mem_graph, _data.memColor);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - _maxMem_graph, _data.maxMemColor);
				_xml["fps"] = "FPS: " + _fps + " / " + stage.frameRate;
				_xml["mem"] = "MEM: " + _mem;
				_xml["maxMem"] = "MAX: " + _maxMem;
				_fps = 0;
			}
			_fps++;
			_xml["ms"] = "MS: " + (_timer - _ms);
			_ms = _timer;
			_label.htmlText = _xml;
		}

		public function GStatus(data : GStatsData) {
			_data = data;
			super(_data);
		}
	}
}
