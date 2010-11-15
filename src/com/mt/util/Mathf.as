package com.mt.util {

	/**
	 * @author mikebook
	 */
	public class Mathf {
		
		public static function deg2Rad(value:Number):Number{
			return value * (Math.PI * 2) / 360;
		}

		public static function rad2Deg(value:Number):Number{
			return value * 360 / (Math.PI * 2);
		}
		
		
	}
}
