package com.mt.model {
	import net.hires.debug.Logger;
	import net.hires.debug.Stats;

	import com.mt.model.AbstractModel;

	/**
	 * @author mikepro
	 */
	public class DebugModel extends AbstractModel {
		
		public var logger:Logger;
		public var stats:Stats;
		
		
		public function DebugModel() {
			name = 'DebugModel';
			super();
		}
		
		public function log(value : String) : void {
			if(!logger) return;
			logger.debug(value);
		}
		
		public function info(value : String) : void {
			if(!logger) return;
			logger.info(value);
		}
		
	}
}
