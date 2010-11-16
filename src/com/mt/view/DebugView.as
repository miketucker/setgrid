package com.mt.view {
	import net.hires.debug.Logger;
	import net.hires.debug.Stats;

	import com.mt.model.AbstractModel;
	import com.mt.view.elements.AbstractView;

	import flash.events.KeyboardEvent;

	/**
	 * @author mikepro
	 */
	public class DebugView extends AbstractView {
		
		private var _logger:Logger;
		private var stats:Stats;
		public function DebugView(stat:Boolean=true,log:Boolean=true) {
			AbstractModel.view.debug = this;
			
			if(stat) addChild(stats = AbstractModel.debug.stats = new Stats());
		
			if(log){
				addChild(_logger = AbstractModel.debug.logger = new Logger(0,'logger',true,20));
				logger.colors = ['#000000','#666666','#999999','#FF3300','#FF0000'];
				if(stats) logger.x = 100;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, eventKeyDown);
			}
		}
		
		private function eventKeyDown(event : KeyboardEvent) : void {
			
			if(!event.altKey) return;
			switch(event.keyCode){
				case 8:
					if(logger) logger.clear();
					break;
				case 32:
					visible = !visible;
					break;
			}
		}
		
		public function get logger() : Logger {
			return _logger;
		}
	}
}
