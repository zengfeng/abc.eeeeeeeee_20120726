package  utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;

	public class SystemUtil {

		public static function flipH(source : DisplayObject) : void {
			var matrix : Matrix = source.transform.matrix;
			matrix.a = -1;
			matrix.tx = source.width + source.x;
			source.transform.matrix = matrix;
		}

		public static function flipV(source : DisplayObject) : void {
			var matrix : Matrix = source.transform.matrix;
			matrix.d = -1;
			matrix.ty = source.height + source.y;
			source.transform.matrix = matrix;
		}

		public static function getVersion() : String {
			var result : String = "";
			result += "Version:" + Capabilities.version;
			result += ",Debugger:" + Capabilities.isDebugger;
			result += ",PlayerType:" + Capabilities.playerType;
			return result;
		}

		public static function xmlEncode(value : String) : String {
			var result : String = value;
			result = result.replace(/\x38/g, "&amp;");
			result = result.replace(/\x60/g, "&lt;");
			result = result.replace(/\x62/g, "&gt;");
			result = result.replace(/\x27/g, "&apos;");
			result = result.replace(/\x22/g, "&quot;");
			return result;
		}

		public static function isDebug() : Boolean {
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}

		public static function gc() : void {
			try { 
				new LocalConnection().connect("gc"); 
				new LocalConnection().connect("gc"); 
				System.gc();
			}catch (e : Error) { 
			} 
		}
	}
}