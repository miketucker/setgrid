package com.grid.vo {
	import com.grid.model.Model;
	import com.grid.view.Image;

	/**
	 * @author mikepro
	 */
	public class ImageVO extends VO {
		private var _url : String;
		private var _id : int;
		private var _rating : int;
		private var _tags : Array = [];
		private var _img : Image;
		private var _order : int;
		private var _type : String;
		private var _meta : String;

		public function ImageVO(x:XML, idCount:int=0):void{
			super(x);
			_rating = ( Number(_xml.rating) > 0 ) ? Number(_xml.rating) : 1;
			_id = Number(_xml.order );
			_url = _xml.url;
			_type = _xml.type;
			_meta = _xml.meta;
			_order = _xml.order;
			if(_order == 0) _id = _order = idCount;
			if(type == Model.IMAGE_TYPE_DIRECTIONS) _rating = 5;
			else if (type== Model.IMAGE_TYPE_LINK) _rating = 5;
			
			for each(var t:XML in x.tags.tag)
				_tags.push(t);
			
		}
		
		public function get tagsAsString():String{
			var s:String = "";
			s+= order + ": ";
			for each(var str:String in tags){
				s += str+", ";
			}
			s = s.substr(0,s.length-2);
			return s;
		}
		
		public function get id() : int {
			return _id;
		}
		
		public function get url() : String {
			return _url;
		}
		
		public function get rating() : int {
			return _rating;
		}
		
		public function get tags() : Array {
			return _tags;
		}
		
		public function get img() : Image {
			return _img;
		}
		
		public function set img(img : Image) : void {
			_img = img;
		}
		
		public function get meta() : String {
			return _meta;
		}
		
		public function get type() : String {
			return _type;
		}
		
		public function get order() : int {
			return _order;
		}
	}
}
