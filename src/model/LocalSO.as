package  model
{
	import log4a.Logger;

	import flash.events.NetStatusEvent;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Security;
	import flash.system.SecurityPanel;


	/**
	 * Local Share Object 
	 */
	public class LocalSO
	{
		private var _shareObject : SharedObject;

		private function netStatusHandler(event : NetStatusEvent) : void
		{
			_shareObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			switch(event.info["code"])
			{
				case SharedObjectFlushStatus.FLUSHED:
					break;
				case SharedObjectFlushStatus.PENDING:
					break;
			}
		}

		public function LocalSO(name : String)
		{
			_shareObject = SharedObject.getLocal(name);
			_shareObject.objectEncoding = ObjectEncoding.AMF3;
		}

		public function showSetting() : void
		{
			Security.showSettings(SecurityPanel.LOCAL_STORAGE);
		}

		public function setAt(key : String, value : Object) : void
		{
			if (value != null)
			{
				_shareObject.setProperty(key, value);
			}
			else
			{
				delete _shareObject.data[key];
			}
		}

		public function flush() : Boolean
		{
			var done : Boolean = true;
			try
			{
				var result : Object = _shareObject.flush();
				if (result == SharedObjectFlushStatus.FLUSHED)
				{
				}
				else if (result == SharedObjectFlushStatus.PENDING)
				{
					_shareObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					done = false;
				}
			}
			catch(e : Error)
			{
				done = false;
				Logger.error(e.getStackTrace());
			}
			return done;
		}

		public function getAt(key : String) : Object
		{
			return _shareObject.data[key];
		}

		public function clear() : void
		{
			_shareObject.clear();
		}
	}
}
