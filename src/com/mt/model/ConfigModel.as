package com.mt.model {
	import com.mt.model.AbstractModel;

	/**
	 * @author mikepro
	 */
	public class ConfigModel extends AbstractModel {
		
		private var _root : String = "";

		public function ConfigModel() {
			super( );
		}
		
		public function get root() : String {
			return _root;
		}
		
		public function set root(value : String) : void {
			_root = value;
		}
	}
}
