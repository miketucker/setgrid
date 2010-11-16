package com.grid.vo {

	/**
	 * @author mikepro
	 */
	public class TagVO extends VO {
		private var _description : String = "";
		private var _tag_name : String = "";
		private var _name : String = "";
		private var _imageVOs : Array = [];

		public function TagVO(x:XML=null):void{
			super(x);
			
			if(!x) return;
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
		
		public function set label(val:String) : void {
			_name = val;
		}
		
		public function set tag(val:String) : void {
			_tag_name = val;
		}
		
		public function set description(val:String) : void {
			_description = val;
		}

		public function addImageVO(vo : ImageVO) : void {
			_imageVOs.push(vo);
		}
		
		public function get imageCount():int{
			return _imageVOs.length;
		}
	}
}
