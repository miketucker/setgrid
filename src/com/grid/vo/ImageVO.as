package com.grid.vo {
	import com.grid.model.Model;
	import com.grid.view.Image;

	/**
	 * @author mikepro
	 */
	public class ImageVO extends VO {
		private var _url : String;
		private var _siteURL : String;
		private var _id : int;
		private var _rating : int;
		private var _tags : Array = [];
		private var _img : Image;
		private var _order : int;
		private var _type : String;
		private var _meta : String;
		private var _title : String;

		public function ImageVO(x:XML=null, idCount:int=0):void{
			super(x);
			
			if(!x) return;
			_id = Number(_xml.order );
			_url = _xml.url;
			_type = _xml.type;
			_meta = _xml.meta;
			_order = _xml.order;
			for each(var t:XML in x.tags.tag)
				_tags.push(t);
			
		}
		
		public function get urlLow():String{
			return _url + "_s.jpg";
		}
		
		public function get urlHigh():String{
			return _url + "_b.jpg";
		}
		
		public function addTag(val:String):void{
			_tags.push(val);
		}
		
		public function set title(val:String):void{
			_title = val;
		}
		
		public function set meta(val:String):void{
			_meta = val;
		}
		
		public function set order(val:int):void{
			_order = val;
		}
		
		public function set id(val:int):void{
			_id = val;
		}
				
		public function set rating(val:int):void{
			_rating = val;
		}
		
		public function set type(val:String):void{
			_type = val;
		}

		public function set url(val:String):void{
			_url = val;
		}
		
		public function get label():String{
			return String((title) ? title : id);
		}
		
		public function get hoverLabel():String{
			var s:String = label;
			
			if(tags.length > 0) s+=  ": ";
			for each(var str:String in tags){
				s += str+", ";
			}
			if(tags.length > 0) s = s.substr(0,s.length-2);
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

		public function get title() : String {
			return _title;
		}

		public function get siteURL() : String {
			return _siteURL;
		}

		public function set siteURL(val : String) : void {
			_siteURL = val;
		}
	}
}
