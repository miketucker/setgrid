package com.grid.view {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.grid.model.Model;
	import com.grid.view.elements.LinkCircle;
	import com.grid.view.elements.TagTrail;
	import com.grid.vo.ImageVO;
	import com.mt.view.elements.AbstractSprite;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author mikebook
	 */
	public class Wall extends AbstractSprite {
		private var grid : Grid;
		private var imageAr : Array = [];
		private var holder : Sprite;
		private var holderOuter : Sprite;
		private var _activeImage : Image;
		private var mouseIsDown : Boolean;
		private var mouseDownPoint : Point = new Point( );
		private var lastPoint : Point = new Point( );
		private var velocity : Point = new Point( );
		private var imgDic : Array = [];
		private static const MIN_ZOOM : Number = .1;
		private static const MAX_ZOOM : Number = 5;
		private static const DEFAULT_ZOOM : Number = .2;
		private var links : Sprite;
		private var trails : Object = new Object( );
		public var instance : Wall;
		private var activeURL : String = "";
		private var targetScale : Point = new Point( 1 );
		private var targetPosition : Point = new Point( );
		private var tagDic : Object = new Object( );
		private var linkCircle : LinkCircle;
		private var hover : Hover;

		public function Wall() {
			instance = this;
			addChild( holderOuter = new Sprite( ) );
			holderOuter.addChild( holder = new Sprite( ) );
			holder.addChild( links = new Sprite( ) );
			addChild( linkCircle = new LinkCircle( ) );
			addChild( hover = new Hover( ) );
			Model.hover = hover;
			stage.addEventListener( Event.RESIZE , eResize );
			SWFAddress.setTitle( Model.title );
			stage.addEventListener( MouseEvent.MOUSE_DOWN , mouseDown );
			stage.addEventListener( MouseEvent.MOUSE_WHEEL , mouseWheel );
			addEventListener( Event.ENTER_FRAME , eFrame );
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE , eAddressChange );
			layout( );
			grid = new Grid( );
		}

		public function selectByTag(name : String = "",id : int = 0) : void {
			if(name == "") name = Model.image.TAG_ALL;
			var i : Image = tagDic[name][id];
			SWFAddress.setValue( i.vo.id.toString( ) );
		}

		public function showTag(str : String) : void {
			TagTrail( trails[str] ).show( );
			var i : Image;
			for each(i in imgDic)
				i.dim( );
			for each(i in tagDic[str])
				i.undim( );
		}

		public function hideTag(str : String) : void {
			TagTrail( trails[str] ).hide( );
			var i : Image;
			for each(i in imgDic)
				i.undim( );
		}

		private function eAddressChange(event : SWFAddressEvent) : void {
			goto( event.path.split( '/' )[1] );
			//Model.notes.text='';
			hover.hide( );
		}

		private function goto(str : String) : void {
			activeURL = str;
			if(imgDic[str]) select( imgDic[str] );
			else zoomOut( );
		}

		private function eFrame(event : Event) : void {
			if(mouseIsDown) {
				velocity.x += (lastPoint.x - mouseX) * .5 * (1 / holderOuter.scaleX);
				velocity.y += (lastPoint.y - mouseY) * .5 * (1 / holderOuter.scaleX);
				lastPoint.x = mouseX;
				lastPoint.y = mouseY;
			}
			if(int( (targetScale.x - holderOuter.scaleX) * 100 ) != 0) {
				holderOuter.scaleX += (targetScale.x - holderOuter.scaleX) * .1;
				holderOuter.scaleY = holderOuter.scaleX;
			}
			
			if(int( (targetPosition.x - holder.x) * 100 ) != 0)
				holder.x += (targetPosition.x - holder.x) * .1;
				
			if(int( (targetPosition.y - holder.y) * 100 ) != 0)
				holder.y += (targetPosition.y - holder.y) * .1;			
			
			if(Math.abs( velocity.x + velocity.y ) > 0.01) {
				TweenLite.killTweensOf( targetPosition );
				TweenLite.killTweensOf( targetScale );
				holder.x -= velocity.x;
				holder.y -= velocity.y;
				targetPosition.x = holder.x;
				targetPosition.y = holder.y;

				velocity.x *= .8;
				velocity.y *= .8;
			}
			
			hover.x = mouseX + 2;
			hover.y = mouseY - hover.height - 2;
		}

		private function mouseWheel(event : MouseEvent) : void {
			targetScale.x += event.delta * .01;
			if(targetScale.x < MIN_ZOOM) targetScale.x = MIN_ZOOM;
			else if(targetScale.x > MAX_ZOOM) targetScale.x = MAX_ZOOM;
		}

		private function mouseDown(event : MouseEvent) : void {
			if(event.target is Stage || event.target is Image) {
				stage.addEventListener( MouseEvent.MOUSE_UP , mouseUp );
				mouseIsDown = true;
				mouseDownPoint.x = lastPoint.x = mouseX;
				mouseDownPoint.y = lastPoint.y = mouseY;
			}
		}

		private function checkClick() : void {
			trace( 'check click' );
			for each(var i:Image in imageAr) {
				if(i.hitTestPoint( mouseX + x , mouseY + y )) {
					var str : String = i.vo.id.toString( );
					trace( 'hit' , str );
					if(activeURL == str)
						SWFAddress.setValue( '' );
					else 
						SWFAddress.setValue( str );
				}
			}
		}

		private function mouseUp(event : MouseEvent) : void {
			mouseIsDown = false;
			stage.removeEventListener( MouseEvent.MOUSE_UP , mouseUp );
			if(Math.abs( mouseDownPoint.x - mouseX ) + Math.abs( mouseDownPoint.y - mouseY ) < 10)
				checkClick( );
		}

		private function eResize(event : Event) : void {
			layout( );
		}

		private function layout() : void {
			x = stage.stageWidth * .5 + Model.BAR_WIDTH * .5;
			y = stage.stageHeight * .5;
		}

		public function populate(ar : Array) : void {
			clear( );
			
			var i : Image;
			tagDic[Model.image.TAG_ALL] = [];
			for each(var v:ImageVO in ar) {
				i = new Image( v );
				i.addEventListener( MouseEvent.MOUSE_OVER , imageOver );
				i.addEventListener( MouseEvent.MOUSE_OUT , imageOut );
				holder.addChild( i );
				imageAr.push( i );
				imgDic[i.vo.id.toString( )] = i;
				for each(var t:String in i.vo.tags) {
					if(! tagDic[t]) tagDic[t] = [];
					tagDic[t].push( i );
				}
				tagDic[Model.image.TAG_ALL].push( i );
				v.img = i;
			}
			clearLinks( );
			drawLinks( );
			sortBy( Model.BAR_SORT_RATING , 0 );
			layout( );
		}

		private function imageOut(event : MouseEvent) : void {
			Model.unhighlightTags( );
			hover.hide( );
		}

		private function imageOver(event : MouseEvent) : void {
			var i : Image = Image( event.target );
			Model.highlightTagsByVO( i.vo );
			if(! activeImage) hover.vo = i.vo;
		}

		private function drawLinks() : void {
			var t : TagTrail;
			for(var i : int = 0; i < Model.image.tagKeys.length; i ++) {
				t = new TagTrail( Model.image.tags[Model.image.tagKeys[i]] );
				t.name = Model.image.tagKeys[i];
				links.addChild( t );
				trails[Model.image.tagKeys[i]] = t;
			}
		}

		private function clearLinks() : void {
			while(links.numChildren > 0)
				links.removeChildAt( 0 );
		}

		private function select(i : Image) : void {
			var zoomed : Boolean = false;
			if(activeImage == i) {
				SWFAddress.setValue( '' );
				zoomOut( );
				return;
			} else {
				if(activeImage) zoomed = true;
				activeImage = i;
										
				//SWFAddress.setTitle( Model.TITLE + "  " + i.vo.tagsAsString );
				
				i.select( );
				var tx : int = (- activeImage.x - activeImage.centerWidth ) * holder.scaleX;
				var ty : int = (- activeImage.y - activeImage.centerHeight) * holder.scaleY;
				var ts : Number = Model.GRID_MAX_SIZE / i.size;
				
				TweenLite.to( targetScale , 1 , {x:ts , ease:Linear.easeNone} );				
				
				TweenLite.to( targetPosition , 1 , {x:tx , y:ty , ease:Quint.easeOut} );
				velocity.x = 0;
				velocity.y = 0;
			}
		}

		public function sortBy(type : String,time : int = 1) : void {
			
			
			switch(type) {
				case Model.BAR_SORT_RATING:
					grid.calculuateSpiral( imageAr );
					break;
				case Model.BAR_SORT_RANDOM:
					grid.calculuateSpiral( imageAr , true );
					break;
				case Model.BAR_SORT_DATE:
					grid.calculateOrdered( imageAr );
					break;
			}
			var d : Number = 0;
			if(time > 0) d = .25;
			var cb : Function = null;
			var c : int = 0;
			for each(var i:Image in imageAr) {
				i.slide( d , time , cb );
				if(time > 0) d += .01;
				c ++;
			}
		}

		public function zoomOut() : void {
			//SWFAddress.setTitle( Model.TITLE + Model.SUBTITLE );
			activeImage = null;
			TweenLite.to( targetScale , 1 , {x:DEFAULT_ZOOM} );
		}

		private function clear() : void {
			while(imageAr.length > 0) {
				holder.removeChild( Image( imageAr.shift( ) ) );
				trace( 'delete one' );
			}
		}

		public function get activeImage() : Image {
			return _activeImage;
		}

		public function set activeImage(val : Image) : void {
			if(activeImage) activeImage.deselect( );
			//linkCircle.select(val);
			if(Model.navBar) Model.navBar.select( val );
			_activeImage = val;
		}
	}
}
