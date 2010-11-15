package com.grid.model {
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import com.grid.view.Image;
	import com.grid.vo.ImageVO;
	import com.grid.vo.TagVO;

	import flash.events.Event;

	/**
	 * @author mikepro
	 */
	public class ImageModel extends Model {
		private var _imageXML : XML;
		private var _voAr : Array = [];
		private var fComplete : Function;
		private var _tags : Object = new Object( );
		private var _tagKeys : Array = [];
		public const TAG_ALL : String = "All";
		private var _tagXML : XML;
		private var _tagAr : Array = [];
		private var _tagArObj : Array = [];
		private var idCount : int = 0;

		public function ImageModel() {
			super( );
		}

		public function loadXML(f : Function = null) : void {
			fComplete = f;

			var li : LoadingItem;
			li = asset.load( 'nav.xml' );
			li.addEventListener( Event.COMPLETE , tagsComplete );
			
		}

		private function tagsComplete(event : Event) : void {
			_tagXML = LoadingItem( event.target ).content;
			var t:TagVO;
			for each(var x:XML in _tagXML.tag) {
				t = new TagVO(x);
				_tagAr.push(t);
				_tagArObj[t.tag_name] = t;
				trace('tag added',t.name,t.tag_name,t.description);
			}
			var li : LoadingItem;
			li = asset.load( 'images.xml' );
			li.addEventListener( Event.COMPLETE , imagesComplete );
		}

		private function imagesComplete(event : Event) : void {
			_imageXML = LoadingItem( event.target ).content;
			trace( 'load complete' );
			var v : ImageVO;
			var allStr : String = TAG_ALL;
			_tags[allStr] = [];
			
			for each(var x:XML in _imageXML.image) {
				idCount ++;
				v = new ImageVO( x , idCount );
				_voAr.push( v );
				for each(var str:String in v.tags) {
					if(!_tags[str]) {
						_tags[str] = [];
						_tagKeys.push( str );
					}
					_tags[allStr].push( v );
					_tags[str].push( v );
				}
			}
			_tagKeys.sort( );
			_tagKeys.splice( 0 , 0 , allStr );
			
			if(fComplete != null) fComplete( );
			dispatchEvent( new Event( Event.COMPLETE , true ) );
		}
		
		public function getPrevImgByTag(tag:String,img:Image):Image{
			var n:int = 0;
			for each(var i:ImageVO in _tags[tag]){
				
				if(i.img==img){
					if(n > 0) return ImageVO(_tags[tag][n-1]).img;
					else return null;
				}
				n++;
			}
			return null;
		}
		
		public function getNextImgByTag(tag:String,img:Image):Image{
			var n:int = 0;
			for each(var i:ImageVO in _tags[tag]){
				if(i.img==img){
					if(n < _tags[tag].length-1) return ImageVO(_tags[tag][n+1]).img;
					else return null;
				}
				n++;
			}
			return null;
		}
		

		public function get vos() : Array {
			return _voAr;
		}

		public function get tags() : Object {
			return _tags;
		}

		public function get tagKeys() : Array {
			return _tagKeys;
		}
		
		public function get tagAr() : Array {
			return _tagAr;
		}
		
		public function get tagArObj() : Array {
			return _tagArObj;
		}
	}
}
