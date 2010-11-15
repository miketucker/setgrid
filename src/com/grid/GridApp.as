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

	[SWF(width="800",height="600",frameRate="50",backgroundColor="#FFFFFF")]
	public class GridApp extends AbstractMainApp {

		
		private var _wall : Wall;
		private var _bar : Bar;
		public var i : GridApp;
		private var debug : DebugView;
		private var _bg : Background;
		private var _top : SortBar;
		private var intro : Intro;
		private var notes : Notes;
		private var _bottom : NavBar;

		public function GridApp() {
			i = this;
			Model.app = this;
			
			var flashVars:Object =this.loaderInfo.parameters;
			if(valid(flashVars.root)) Model.config.root = flashVars.root;
			if(valid(flashVars.title)) Model.title = flashVars.title;
			if(valid(flashVars.imageWidth)) Model.imageWidth = flashVars.imageWidth;
			if(valid(flashVars.imageHeight)) Model.imageHeight = flashVars.imageHeight;
			if(valid(flashVars.imagePad)) Model.imagePad = flashVars.imagePad;
			if(valid(flashVars.background)) Model.backgroundColor = uint(flashVars.background);
			
			Model.image.loadXML(init);
			OverwriteManager.init();
			
			
		}
		
		private function valid(str:String):Boolean{
			trace('valid',str);
			 return (str != "undefined" && str) ? true : false;
		
		}
		
		private function init() : void {
			addChild(_bg = new Background());
			addChild(_wall = new Wall());
			//addChild(_bar = new Bar());
			addChild(_top = new SortBar());
			addChild(_bottom = new NavBar());
			//addChild(debug = new DebugView());
			_wall.populate(Model.image.vos);
			//addChild(intro = new Intro());
			addChild(notes = new Notes());
		}
		
		public function get wall():Wall{
			return _wall;
		}
		
		public function get bar() : Bar {
			return _bar;
		}
	}
}
