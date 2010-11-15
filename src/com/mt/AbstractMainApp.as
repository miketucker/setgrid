package com.mt {
	import com.mt.model.AbstractModel;
	import com.pixelbreaker.ui.osx.MacMouseWheel;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;

	/**
	 * @author mikebook
	 */
	public class AbstractMainApp extends Sprite {
		public function AbstractMainApp() {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 50;
			stage.quality = StageQuality.BEST;
			
			MacMouseWheel.setup(stage);
			
			AbstractModel.app = this;
		}
		
		
		public function log(value:String):void{
			AbstractModel.debug.log(value);
		}
		
		public function info(value:String):void{
			AbstractModel.debug.info(value);
		}	
	}
}
