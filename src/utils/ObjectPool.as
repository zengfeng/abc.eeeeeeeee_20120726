package utils {
	import gameui.manager.UIManager;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author yangyiqiang
	 */
	public class ObjectPool
	{
		private static var pools : Dictionary = new Dictionary();

		public static function getSize(type : Class) : int
		{
			return type in pools ? (pools[type] as Array).length : 0;
		}

		private static function getPool(type : Class) : Array
		{
			return type in pools ? pools[type] : pools[type] = new Array();
		}
		
		public static function clear():void
		{
//			for each(var type:Class in pools){
//				delete pools[type];
//			}
		}

		public static function getObject(type : Class, ...parameters) : *
		{
			var pool : Array = getPool(type);
			if ( pool.length > 0 )
			{
				trace("getObject===>form pool",type);
				return pool.pop();
			}
			else
			{
				return getNewClass(type, parameters);
			}
		}

		public static function disposeObject(object : *, type : Class = null) : void
		{
			trace("disposeObject===>"+object,type);
			if ( !type )
			{
				var typeName : String = getQualifiedClassName(object);
				type = UIManager.appDomain.getDefinition(typeName) as Class;
			}
			var pool : Array = getPool(type);
			trace("pool"+pool,"pool.length="+pool.length,"type===>"+type);
			if (pool.indexOf(object) < 0)
				pool.push(object);
		}

		private static function getNewClass(classRef : Class, initParms : Array) : *
		{
			trace("getNewClass===>----------------------------------"+classRef,initParms);
			if (initParms && initParms.length)
			{
				switch(initParms.length)
				{
					case 1:
						return new classRef(initParms[0]);
					case 2:
						return new classRef(initParms[0], initParms[1]);
					case 3:
						return new classRef(initParms[0], initParms[1], initParms[2]);
					case 4:
						return new classRef(initParms[0], initParms[1], initParms[2], initParms[3]);
					case 5:
						return new classRef(initParms[0], initParms[1], initParms[2], initParms[3], initParms[4]);
				}
			}
			return new classRef();
		}
	}
}
