package com.grid {
	import com.greensock.OverwriteManager;
	import com.grid.model.Model;
	import com.grid.view.Background;
	import com.grid.view.Bar;
	import com.grid.view.Intro;
	import com.grid.view.Notes;
	import com.grid.view.Wall;
	import com.grid.view.elements.NavBar;
	import com.grid.view.elements.SortBar;
	import com.mt.AbstractMainApp;
	import com.mt.view.DebugView;

	import flash.system.Security;

	[SWF(width="800",height="600",frameRate="50",backgroundColor="#FFFFFF")]
	public class GridApp extends AbstractMainApp {
		private var _wall : Wall;
		private var _bar : Bar;
		private var debug : DebugView;
		private var _bg : Background;
		private var _sortBar : SortBar;
		private var intro : Intro;
		private var notes : Notes;
		private var _navBar : NavBar;
		private const FLICKR_URL : String = "flickr.com";
		private const CROSSDOMAIN_URL : String = "http://api.flickr.com/crossdomain.xml";

		public function GridApp() {
			Model.app = this;

			Security.allowDomain(FLICKR_URL);
			Security.loadPolicyFile(CROSSDOMAIN_URL);

			var flashVars : Object = this.loaderInfo.parameters;
			if (valid(flashVars.root)) Model.config.root = flashVars.root;
			if (valid(flashVars.title)) Model.title = flashVars.title;
			if (valid(flashVars.imageWidth)) Model.imageWidth = flashVars.imageWidth;
			if (valid(flashVars.imageHeight)) Model.imageHeight = flashVars.imageHeight;
			if (valid(flashVars.imagePad)) Model.imagePad = flashVars.imagePad;
			if (valid(flashVars.background)) Model.backgroundColor = uint(flashVars.background);
			if (valid(flashVars.tags)) Model.backgroundColor = uint(flashVars.background);
			if (valid(flashVars.maxImages)) Model.maxImages = Number(flashVars.maxImages);

			Model.image.completeHandler = init;

			if (valid(flashVars.user) && valid(flashVars.api))
				Model.flickr.load(flashVars.user, flashVars.api, nullify(flashVars.tags));

			// Model.image.loadXML(init);
			OverwriteManager.init();
		}

		private function valid(str : String) : Boolean {
			return (str != "undefined" && str) ? true : false;
		}
		
		private function nullify(str : String) : String {
			return (str != "undefined" && str) ? str : null;
		}

		private function init() : void {
			addChild(_bg = new Background());
			addChild(_wall = new Wall());
			addChild(_sortBar = new SortBar());
			addChild(_navBar = new NavBar());
			// addChild(debug = new DebugView());
			_wall.populate(Model.image.vos);
		}

		public function get wall() : Wall {
			return _wall;
		}

		public function get bar() : Bar {
			return _bar;
		}
	}
}
