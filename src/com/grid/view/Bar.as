package com.grid.view {
	import com.grid.model.Model;
	import com.grid.view.elements.Label;
	import com.grid.view.elements.Link;
	import com.grid.view.elements.TagLink;
	import com.grid.vo.ImageVO;
	import com.mt.view.elements.AbstractView;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author mikebook
	 */
	public class Bar extends AbstractView {
		private var bg : Shape;
		private var links : Object = new Object( );
		private static const BG_COLOR : uint = 0xFFFFFF;
		public static const MARGIN_LEFT : int = 20;
		private static const TEXT_LEADING : int = 12;
		private static const MARGIN_TOP : int = 20;
		private var activeLink : TagLink;
		private var tSortBy : Label;
		private var tSortRating : Label;
		private var tSortDate : Label;
		private var textY : int = MARGIN_TOP;
		private var tTags : Label;
		private var tSortRandom : Link;

		public function Bar() {
			super( );
			init( );
		}


		public function highlightByVO(v : ImageVO) : void {
			for each(var l:TagLink in links)
				l.dim( );			
			for each(var s:String in v.tags)
				if(links[s]) links[s].highlight( );
		}

		public function highlightByID(str : String) : void {
			for each(var l:TagLink in links)
				l.unhighlight( );	
			if(links[str]) links[str].highlight( );
		}

		public function unhighlight() : void {
			for each(var l:TagLink in links)
				l.unhighlight( );
		}

		public function deselect() : void {
			for each (var l:TagLink in links)
				l.deselect( );
		}

		private function init() : void {
			addChild( bg = new Shape( ) );
			bg.graphics.beginFill( BG_COLOR , 1 );
			bg.graphics.drawRect( 0 , 0 , Model.BAR_WIDTH , stage.stageHeight );
			
			addText(tSortBy = new Label( Model.BAR_SORT_LABEL ) );
			addText(tSortRating = new Link( Model.BAR_SORT_RATING ) );
			tSortRating.addEventListener(MouseEvent.CLICK, eSortClick);
			addText(tSortDate = new Link( Model.BAR_SORT_DATE ) );
			tSortDate.addEventListener(MouseEvent.CLICK, eSortClick);
			addText(tSortRandom = new Link( Model.BAR_SORT_RANDOM ) );
			tSortRandom.addEventListener(MouseEvent.CLICK, eSortClick);
			addTextSpacer();
			addText(tTags = new Label( Model.BAR_TAG_LABEL ) );
			
			addTags( );
		}

		private function eSortClick(event : MouseEvent) : void {
			Model.app.wall.sortBy(Link(event.target).name);
		}

		private function addText(s : Sprite) : void {
			addChild(s);
			s.y = textY;
			s.x = MARGIN_LEFT;
			
			addTextSpacer();
		}
		
		private function addTextSpacer():void{
			textY +=  TEXT_LEADING;
		}

		override public function resize() : void {
			bg.height = stage.stageHeight;
		}

		private function addTags() : void {
			var l : TagLink;
			for each(var str:String in Model.image.tagKeys) {
				if(Model.image.tags[str].length >= Model.BAR_MINIMUM_TAGS) {
					links[str] = (l = new TagLink( str , Model.image.tags[str].length ));
					addText(l);
					l.addEventListener( MouseEvent.MOUSE_OVER , linkOver );
					l.addEventListener( MouseEvent.MOUSE_OUT , linkOut );
					l.addEventListener( MouseEvent.CLICK , linkClick );
				}
			}
		}

		private function linkClick(event : MouseEvent) : void {
			var l : TagLink = TagLink( event.target );
			if(activeLink && activeLink != l) activeLink.deselect( );
			l.select( );
			activeLink = l;
		}

		private function linkOut(event : MouseEvent) : void {
			var l : TagLink = TagLink( event.target );
			wall.hideTag( l.name );
			l.mouseOut( );
			resetAll( );
		}
		
		private function resetAll() : void {
			for each(var l:TagLink in links)
				l.unhighlight();
		}

		private function linkOver(event : MouseEvent) : void {
			var l : TagLink = TagLink( event.target );
			wall.zoomOut();
			wall.showTag( l.name );
			l.mouseOver( );
			highlightByID( l.name );
		}

		private function get wall() : Wall {
			return Model.app.wall;
		}
	}
}
