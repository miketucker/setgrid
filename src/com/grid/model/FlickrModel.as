package com.grid.model {
	import com.grid.vo.ImageVO;
	import com.grid.vo.TagVO;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;

	/**
	 * @author mikebook
	 */
	public class FlickrModel extends Model {
		private var ul : URLLoader;
		private var _secret : String = "7888ceeb16a23462";
		private var _user_id : String;
		private var _api : String;
		private var _nsid : String;
		private var _tags : String;
		private const GRID_TAG_PREFIX : String = "grid";
		private const DEFAULT_RATING : int = 2;
		private var _ratingsFound : Boolean;
		private const FLICKR_URL : String = "flickr.com";
		private const CROSSDOMAIN_URL : String = "http://api.flickr.com/crossdomain.xml";

		public function FlickrModel() {
			
			Security.allowDomain(FLICKR_URL);
			Security.loadPolicyFile(CROSSDOMAIN_URL);
			for(var i:int = 1; i < 6; i ++)
			Security.loadPolicyFile("http://farm"+i+".static.flickr.com/crossdomain.xml");
			
			super();
		}

		public function load(user_id : String, api : String, tags : String = null) : void {
			_api = api;
			_tags = tags;
			useSuppliedTags(tags);
			var ul : URLLoader = new URLLoader(new URLRequest('http://api.flickr.com/services/rest/?&method=flickr.urls.lookupUser&api_key=' + api + '&url=http://flickr.com/photos/' + user_id + '&format=rest'));
			ul.addEventListener(Event.COMPLETE, function(e : Event) : void {
				var x : XML = XML(ul.data);
				loadImages(x.user.@id);
				Model.title = 'SetGrid.net/'+user_id;
			});
		}

		private function useSuppliedTags(tags : String) : void {
			if (tags == null) return;
			var ar : Array = tags.split(',');
			for each (var t:String in ar) {
				if (t.indexOf(GRID_TAG_PREFIX) == -1)
					Model.image.addTag((t.charAt(0) == ' ') ? t.substr(1) : t);
			}
		}

		private function loadImages(nsid : String) : void {
			var ul : URLLoader = new URLLoader(new URLRequest('http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=' + _api + '&user_id=' + nsid + '&extras=tags&per_page=' + Model.maxImages + '&format=rest'));
			ul.addEventListener(Event.COMPLETE, function(e : Event) : void {
				var xml : XML = XML(ul.data);
				if (!_tags) {
					for each (var x:XML in xml.photos.photo) {
						parsePhotoTags(x);
					}
				}

				parsePhotos(xml);
			});
		}

		private function parsePhotos(x : XML) : void {
			var vo : ImageVO;
			var tags : Array;

			for each (var x:XML in x.photos.photo) {
				vo = new ImageVO();
				tags = x.@tags.split(' ');
				vo.id = Number(x.@id);
				vo.title = x.@title;
				vo.siteURL = "http://flickr.com/photos/" + x.@owner + '/' + x.@id;
				vo.rating = getRating(tags);
				vo.url = 'http://farm' + x.@farm + '.static.flickr.com/' + x.@server + '/' + x.@id + '_' + x.@secret;
				for each (var t:String in tags) {
					if (t.indexOf(GRID_TAG_PREFIX) == -1 && t != '') {
						vo.addTag(t);
						if (Model.image.tagArObj[t]) TagVO(Model.image.tagArObj[t]).addImageVO(vo);
					}
				}
				Model.image.addImage(vo);
			}

			Model.image.doneLoading();
		}

		private function getRating(ar : Array) : int {
			var n : Number;
			for each (var s:String in ar) {
				n = Number(s.substr(GRID_TAG_PREFIX.length, 1));
				if (n < 6 && n > 0){
					_ratingsFound = true;
					return n;
				}
			}
			return DEFAULT_RATING;
		}

		private function parsePhotoTags(x : XML) : void {
			var tags : Array = x.@tags.split(' ');
			for each (var t:String in tags) {
				Model.image.addTag(t);
			}
		}

		public function get ratingsFound() : Boolean {
			return _ratingsFound;
		}
		//
	// private function loadUser(event : FlickrResultEvent) : void {
	// fs.people.findByUsername(_user_id);
	// }
	}
}
