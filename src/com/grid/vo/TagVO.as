package com.grid.vo {

	/**
	 * @author mikepro
	 */
	public class TagVO extends VO {
		private var _description : String = "";
		private var _tag_name : String = "";
		private var _name : String = "";

		public function TagVO(x:XML):void{
			super(x);
			_name = String(_xml.name);
			_tag_name = _xml.tag;
			_description = _xml.description;
			
		}
		
		public function get description() : String {
			return _description;
		}
		
		public function get name() : String {
			return _name;
		}
		
		public function get tag_name() : String {
			return _tag_name;
		}
	}
}
