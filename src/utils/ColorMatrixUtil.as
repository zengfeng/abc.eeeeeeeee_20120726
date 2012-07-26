package  utils {

	public class ColorMatrixUtil {

		public static const GRAY : Array = [0.299,0.587,0.114,0,0,0.299,0.587,0.114,0,0,0.299,0.587,0.114,0,0,0,0,0,1,0];
		
		public static const ERASE : Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,-1,255];

		private static const DELTA_INDEX : Array = [0,   0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1, 0.11,
			 0.12,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.22,0.24,
			 0.25,0.27,0.28,0.30,0.32,0.34,0.36,0.38,0.40,0.42,
			 0.44,0.46,0.48,0.5, 0.53,0.56,0.59,0.62,0.65,0.68, 
			 0.71,0.74,0.77,0.80,0.83,0.86,0.89,0.92,0.95,0.98,
			 1.0, 1.06,1.12,1.18,1.24,1.30,1.36,1.42,1.48,1.54,
			 1.60,1.66,1.72,1.78,1.84,1.90,1.96,2.0, 2.12,2.25, 
			 2.37,2.50,2.62,2.75,2.87,3.0, 3.2, 3.4, 3.6, 3.8,
			 4.0, 4.3, 4.7, 4.9, 5.0, 5.5, 6.0, 6.5, 6.8, 7.0,
			 7.3, 7.5, 7.8, 8.0, 8.4, 8.7, 9.0, 9.4, 9.6, 9.8, 
			 10.0];

		private static function multiplyMatrix(s : Array,t : Array) : void {
			var temp : Array = [];
			for (var i : int = 0;i < 5;i++) {
				for(var j : int = 0;j < 5;j++) {
					temp[j] = s[j + i * 5];
				}
				for(j = 0;j < 5;j++) {
					var v : Number = 0;
					for (var k : int = 0;k < 5;k++) {
						v += t[j + k * 5] * temp[k];
					}
					s[j + i * 5] = v;
				}
			}
		}

		public static function adjustColor(b : int,c : int,s : int,h : int) : Array {
			var matrix : Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
			if(b != 0)multiplyMatrix(matrix, adjustBrightness(b));
			if(c != 0)multiplyMatrix(matrix, adjustContrast(c));
			if(s != 0)multiplyMatrix(matrix, adjustSaturation(s));
			if(h != 0)multiplyMatrix(matrix, adjustHue(h));
			return matrix;
		}

		public static function adjustBrightness(b : int) : Array {
			b = Math.max(-100, Math.min(100, b));
			if(b == 0)return [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
			return [1,0,0,0,b,
				0,1,0,0,b,
				0,0,1,0,b,
				0,0,0,1,0,
				0,0,0,0,1];
		}

		public static function adjustContrast(c : int) : Array {
			c = Math.max(-100, Math.min(100, c));
			if(c == 0)return [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
			var x : Number;
			if(c < 0) {
				x = 127 + c / 100 * 127;
			} else {
				x = c % 1;
				if(x == 0) {
					x = DELTA_INDEX[c];
				} else {
					x = DELTA_INDEX[c] * (1 - x) + DELTA_INDEX[c + 1] * x;
				}
				x = x * 127 + 127;
			}
			return [x / 127,0,0,0,0.5 * (127 - x),
				0,x / 127,0,0,0.5 * (127 - x),
				0,0,x / 127,0,0.5 * (127 - x),
				0,0,0,1,0,
				0,0,0,0,1];
		}

		public static function adjustSaturation(s : int) : Array {
			s = Math.max(-100, Math.min(100, s));
			if(s == 0)return [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
			var x : Number = 1 + ((s > 0) ? 3 * s / 100 : s / 100);
			var lumR : Number = 0.3086;
			var lumG : Number = 0.6094;
			var lumB : Number = 0.0820;
			return [lumR * (1 - x) + x,lumG * (1 - x),lumB * (1 - x),0,0,
				lumR * (1 - x),lumG * (1 - x) + x,lumB * (1 - x),0,0,
				lumR * (1 - x),lumG * (1 - x),lumB * (1 - x) + x,0,0,
				0,0,0,1,0,
				0,0,0,0,1];
		}

		public static function adjustHue(h : int) : Array {
			h = Math.max(-180, Math.min(180, h)) / 180 * Math.PI;
			if(h == 0)return [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
			var cosVal : Number = Math.cos(h);
			var sinVal : Number = Math.sin(h);
			var lumR : Number = 0.213;
			var lumG : Number = 0.715;
			var lumB : Number = 0.072;
			return [lumR + cosVal * (1 - lumR) + sinVal * (-lumR),lumG + cosVal * (-lumG) + sinVal * (-lumG),lumB + cosVal * (-lumB) + sinVal * (1 - lumB),0,0,
				lumR + cosVal * (-lumR) + sinVal * (0.143),lumG + cosVal * (1 - lumG) + sinVal * (0.140),lumB + cosVal * (-lumB) + sinVal * (-0.283),0,0,
				lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)),lumG + cosVal * (-lumG) + sinVal * (lumG),lumB + cosVal * (1 - lumB) + sinVal * (lumB),0,0,
				0,0,0,1,0,
				0,0,0,0,1];
		}
	}
}