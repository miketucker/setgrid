package com.grid.model {
	import com.grid.GridApp;
	import com.grid.view.Hover;
	import com.grid.view.Notes;
	import com.grid.view.elements.NavBar;
	import com.grid.view.elements.SortBar;
	import com.grid.vo.ImageVO;
	import com.mt.model.AbstractModel;
	import com.mt.model.AssetModel;
	import com.mt.model.ConfigModel;
	import com.mt.model.DebugModel;
	import com.mt.model.SoundModel;
	import com.mt.model.ViewModel;

	import flash.text.Font;

	/**
	 * @author mikepro
	 */
	public class Model extends AbstractModel {		

		public static const DIR_DATA : String = "data/";
		public static const DIR_SM : String = DIR_DATA + "sm/";
		public static const DIR_MD : String = DIR_DATA + "md/";
		public static const DIR_LG : String = DIR_DATA + "lg/";

		public static const IMAGE_TYPE_DEFAULT : String = "";
		public static const IMAGE_TYPE_LINK : String = "link";
		public static const IMAGE_TYPE_DIRECTIONS : String = "directions";


		public static const BAR_WIDTH : int = 0;
		public static const BAR_MINIMUM_TAGS : int = 2;
		public static const BAR_SORT_LABEL : String = "SORT BY";
		public static const BAR_TAG_LABEL : String = "TAGS";
		public static const BAR_SORT_RATING : String = "RATING";
		public static const BAR_SORT_DATE : String = "DATE";
		public static const BAR_SORT_RANDOM : String = "RANDOM";

		public static const BAR_EXTRA_HELP : String = "HELP";
		public static const BAR_EXTRA_ABOUT : String = "ABOUT";

		public static const TEXT_COLOR : uint = 0xFFFFFF;
		public static const LINK_ALPHA_DIM : Number = 0.7;
		public static const LINK_ALPHA_UNHIGHLIGHT : Number = 0.7;
		public static const GRID_COLUMNS : int = 10;
		public static const GRID_MAX_SIZE : int = 7;  

		public static const FOOTER_MAX_TAGS : Number = 20;


		private static var _imageWidth : int = 1000 / GRID_MAX_SIZE;
		private static var _imageHeight : int = 676 / GRID_MAX_SIZE;
		public static var imagePad : int = 20;
		public static const IMAGE_X_PAD : int = 0;
		public static const IMAGE_Y_PAD : int = 0;

		public static var backgroundColor : uint = 0x222222;
		public static const TRAIL_COLOR : uint = 0xFFFFFF;

		private static var _defaultFont : Font;
		
		private static var _image : ImageModel;
		public static var _app : GridApp;
		private static var _flickr : FlickrModel;

		public static var sortBar : SortBar;
		public static var notes : Notes;
		public static var hover : Hover;
		public static var title : String = "PROCESS";
		public static var navBar : NavBar;
		public static var maxImages : int;

		public static const NOTES_ABOUT : String = 	"Browse any flickr account by navigating to http://setgrid.net/USERNAME<br/><br/>" +
													"Click and drag to pan the camera.<br/>" +
													"Click an image to zoom in, and again to zoom out<br/>" + 
													"Use your mouse wheel for extra zooming<br/>" + 
													"Click the title to view the image on Flickr.com<br/><br/>" + 
													"Created by Mike Tucker ( <a href='http://mike-tucker.com'>mike-tucker.com</a> )<br/><br/>" +
													"This project is open-source.<br/>View at <a href='https://github.com/miketucker/SetGrid'>https://github.com/miketucker/SetGrid</a>";
		public function Model() {
			_defaultFont = new Menlo();
			super( );
		}
		
		
		public static function get fontSize():int{
			return 12;
		}
		
		public static function get fontName():String{
			return _defaultFont.fontName;
		}
		
		public static function set imageWidth(val:int):void{
			_imageWidth = val / GRID_MAX_SIZE;
		}
		
		public static function set imageHeight(val:int):void{
			_imageHeight = val / GRID_MAX_SIZE;
		}
		
		static public function get imageHeight() : int {
			return _imageHeight;
		}
		
		static public function get imageWidth() : int {
			return _imageWidth;
		}
		
		
		public static function highlightTagsByVO(i:ImageVO):void{
			if(!app.bar) return;
			Model.app.bar.highlightByVO( i );
		}
		
		public static function unhighlightTags():void{
			if(!app.bar) return;
			Model.app.bar.unhighlight( );
		}

		public static function get config() : ConfigModel {
			return AbstractModel.config;
		}

		public static function get view() : ViewModel {
			return AbstractModel.view;
		}	

		public static function get image() : ImageModel {
			if(! _image) _image = new ImageModel( );
			return _image;
		}	
		
		public static function get flickr() : FlickrModel {
			if(! _flickr) _flickr = new FlickrModel( );
			return _flickr;
		}	

		static public function get asset() : AssetModel {
			return AbstractModel.asset;
		}		

		static public function get debug() : DebugModel {
			return AbstractModel.debug;
		}

		static public function get sound() : SoundModel {
			return AbstractModel.sound;
		}

		static public function get app() : GridApp {
			return _app;
		}

		static public function set app(app : GridApp) : void {
			_app = app;
		}
		
	}
}
