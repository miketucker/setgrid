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
		private var _completeHandler : Function;
		private var _tags : Object = new Object();
		private var _tagKeys : Array = [];
		public const TAG_ALL : String = "All";
		private var _tagXML : XML;
		private var _tagAr : Array = [];
		private var _tagArObj : Array = [];
		private var idCount : int = 0;

		public function ImageModel() {
			super();

			_tags[TAG_ALL] = [];
		}
		
		public function set completeHandler(val:Function):void{
			_completeHandler = val;
		}

		public function loadXML(f : Function = null) : void {

			var li : LoadingItem;
			li = asset.load('nav.xml');
			li.addEventListener(Event.COMPLETE, tagsComplete);
		}

		public function addTag(tag : String, label : String = null, description : String = null) : void {
			if (_tagArObj[tag]) return;

			var t : TagVO = new TagVO();
			t.label = (label) ? label : tag;
			t.tag = tag;
			t.description = description;
			_tagAr.push(t);
			_tagArObj[tag] = t;
		}

		public function addImage(vo : ImageVO) : void {
			idCount++;
			vo.id = idCount;
			_voAr.push(vo);
			for each (var str:String in vo.tags) {
				if (!_tags[str]) {
					_tags[str] = [];
					_tagKeys.push(str);
				}
				_tags[TAG_ALL].push(vo);
				_tags[str].push(vo);
			}
		}

		public function doneLoading() : void {
			_tagKeys.sort();
			_tagKeys.splice(0, 0, TAG_ALL);
			if (_completeHandler != null) _completeHandler();
			dispatchEvent(new Event(Event.COMPLETE, true));
		}

		private function tagsComplete(event : Event) : void {
			_tagXML = LoadingItem(event.target).content;
			var t : TagVO;
			for each (var x:XML in _tagXML.tag) {
				addTag(t.tag_name, t.name, t.description);
			}
			var li : LoadingItem;
			li = asset.load('images.xml');
			li.addEventListener(Event.COMPLETE, imagesComplete);
		}

		private function imagesComplete(event : Event) : void {
			_imageXML = LoadingItem(event.target).content;
			trace('load complete');
			var v : ImageVO;

			for each (var x:XML in _imageXML.image) {
				v = new ImageVO(x);
				addImage(v);
			}

			doneLoading();

		}

		public function getPrevImgByTag(tag : String, img : Image) : Image {
			var n : int = 0;
			for each (var i:ImageVO in _tags[tag]) {
				if (i.img == img) {
					if (n > 0) return ImageVO(_tags[tag][n - 1]).img;
					else return null;
				}
				n++;
			}
			return null;
		}

		public function getNextImgByTag(tag : String, img : Image) : Image {
			var n : int = 0;
			for each (var i:ImageVO in _tags[tag]) {
				if (i.img == img) {
					if (n < _tags[tag].length - 1) return ImageVO(_tags[tag][n + 1]).img;
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
