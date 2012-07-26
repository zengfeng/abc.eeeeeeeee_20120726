package net {
	import log4a.Logger;

	import utils.GStringUtil;

	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public class RESLoader extends ALoader {
		protected var _stream : URLStream;
		protected var _byteArray : ByteArray;

		private function addStreamEvents() : void {
			_stream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_stream.addEventListener(Event.COMPLETE, completeHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function removeStreamEvents() : void {
			if (!_stream) return;
			_stream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_stream.removeEventListener(Event.COMPLETE, completeHandler);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function ioErrorHandler(event : IOErrorEvent) : void {
			if (--_libData.tryNum > 0) {
				_isLoadding = false;
				_isLoaded = false;
				_libData.version+=_libData.tryNum;
				load();
			} else
				onError(event.text);
		}

		private function progressHandler(event : ProgressEvent) : void {
			_loadData.calc(event.bytesLoaded, event.bytesTotal);
		}

		private function completeHandler(event : Event) : void {
			removeStreamEvents();
			_loadData.calc(100, 100);
			_byteArray = new ByteArray();
			var length : int = _stream.bytesAvailable;
			_stream.readBytes(_byteArray, 0, length);
			_stream.close();
			onComplete();
		}

		public function get callBackFun() : Function {
			var obj : Object = funArray[0];
			if (obj) return obj["fun"];
			return null;
		}

		public function get callBackParams() : * {
			var obj : Object = funArray[0];
			if (obj) return obj["params"];
			return null;
		}

		protected function onComplete() : void {
			_isLoadding = false;
			_isLoaded = true;
			if (isCache) {
				if (completeFun != null)
					completeFun(this);
				for each (var obj:Object in funArray)
					if ((obj["fun"] as Function) != null) (obj["fun"] as Function).apply(null, obj["params"]);
			} else {
				for each (obj in funArray)
					if ((obj["fun"] as Function) != null) (obj["fun"] as Function).apply(null, obj["params"]);
				if (completeFun != null)
					completeFun(this);
			}
		}

		protected function onError(message : String) : void {
			removeStreamEvents();
			_isLoadding = _isLoaded = false;
			Logger.error(GStringUtil.format("load {0} error!message={1}", _libData.url, message));
			var event : ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
			event.text = message;
			if (isCache) {
				if (errorFun != null)
					errorFun(this);
				for each (var obj:Object in funArray)
					if ((obj["fun"] as Function) != null) (obj["fun"] as Function).apply(null, obj["params"]);
			} else {
				for each (obj in funArray)
					if ((obj["fun"] as Function) != null) (obj["fun"] as Function).apply(null, obj["params"]);
				if (completeFun != null)
					completeFun(this);
			}
		}

		public function RESLoader(data : LibData, fun : Function = null, onCompleteParams : Array = null) {
			super(data);
			if (fun != null)
				funArray.push({fun:fun, params:onCompleteParams});
		}

		public function resetData(data : LibData, fun : Function = null, onCompleteParams : Array = null) : void {
			_libData = data;
			if (fun != null) {
				funArray = [];
				funArray.push({fun:fun, params:onCompleteParams});
			}
		}

		override public function load() : void {
			if (_isLoadding) return;
			if (_isLoaded) return;
			_isLoadding = true;
			_stream = new URLStream();
			addStreamEvents();
			_loadData.reset();
			var request : URLRequest = new URLRequest(_libData.url);
			request.data = new URLVariables("v=" + _libData.version);
			try {
				_stream.load(request);
			} catch(e : IOError) {
				onError(e.message);
			} catch(e : SecurityError) {
				onError(e.message);
			}
		}

		override public function clear() : void {
			removeStreamEvents();
			_byteArray = new ByteArray();
			if (_stream && _stream.connected)
				_stream.close();
		}

		public function getByteArray() : ByteArray {
			return _byteArray;
		}

		override public function stop() : void {
			if (_stream && _stream.connected)
				_stream.close();
		}
	}
}