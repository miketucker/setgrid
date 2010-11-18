package com.grid.view {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.grid.model.Model;
	import com.grid.view.elements.TagTrail;
	import com.grid.vo.ImageVO;
	import com.mt.view.elements.AbstractSprite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author mikebook
	 */
	public class Wall extends AbstractSprite {
		private var grid : Grid;
		private var imageAr : Array = [];
		private var _holder : Sprite;
		private var _holderOuter : Sprite;
		private var _activeImage : Image;
		private var mouseIsDown : Boolean;
		private var mouseDownPoint : Point = new Point( );
		private var lastPoint : Point = new Point( );
		private var velocity : Point = new Point( );
		private var imgDic : Array = [];
		private static const MIN_ZOOM : Number = .1;
		private static const MAX_ZOOM : Number = 5;
		private static const DEFAULT_ZOOM : Number = .2;
		private var _links : Sprite;
		private var trails : Object = new Object( );
		private var activeURL : String = "";
		private var targetScale : Point = new Point( 1 );
		private var targetPosition : Point = new Point( );
		private var tagDic : Object = new Object( );
		private var hover : Hover;
		private var _screen : Sprite;

		public function Wall() {
			addChild( _holderOuter = new Sprite( ) );
			_holderOuter.addChild( _holder = new Sprite( ) );
			_holder.addChild( _links = new Sprite( ) );
			addChild( hover = new Hover( ) );
			Model.hover = hover;
			stage.addEventListener( Event.RESIZE , eResize );
			SWFAddress.setTitle( Model.title );
			_holder.addEventListener( MouseEvent.MOUSE_DOWN , mouseDown );
			stage.addEventListener( MouseEvent.MOUSE_WHEEL , mouseWheel );
			addEventListener( Event.ENTER_FRAME , eFrame );
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE , eAddressChange );
			layout( );
			grid = new Grid( );
		}
		
		private function bringScreenToTop():void{
			_holder.setChildIndex(_links, _holder.numChildren-2);
			_holder.setChildIndex(_screen, _holder.numChildren-3);
			TweenLite.to(_screen,1,{alpha:1});
		}
		
		private function bringScreenToBottom():void{
			TweenLite.to(_screen,1,{alpha:0,onComplete:function():void{
				_holder.setChildIndex(_screen, 0);
			}});
		}
		
		private function bringImageToTop(i:Image):void{
			_holder.setChildIndex(i,_holder.numChildren-1);
		}

		private function bringImageToBottom(i:Image):void{
			_holder.setChildIndex(i,0);
		}		

		

		public function selectByTag(name : String = "",id : int = 0) : void {
			if(name == "") name = Model.image.TAG_ALL;
			var i : Image = tagDic[name][id];
			SWFAddress.setValue( i.vo.id.toString( ) );
		}

		public function showTag(str : String) : void {
			TagTrail( trails[str] ).show( );
			bringScreenToTop();
			var i : Image;
			for each(i in imgDic){
				//i.dim( );
				bringImageToBottom(i);
			}
			for each(i in tagDic[str])
				//i.undim( );
				bringImageToTop(i);
		}

		public function hideTag(str : String) : void {
			TagTrail( trails[str] ).hide( );
			bringScreenToBottom();
			
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
				velocity.x += (lastPoint.x - mouseX) * .5 * (1 / _holderOuter.scaleX);
				velocity.y += (lastPoint.y - mouseY) * .5 * (1 / _holderOuter.scaleX);
				lastPoint.x = mouseX;
				lastPoint.y = mouseY;
			}
			if(int( (targetScale.x - _holderOuter.scaleX) * 100 ) != 0) {
				_holderOuter.scaleX += (targetScale.x - _holderOuter.scaleX) * .1;
				_holderOuter.scaleY = _holderOuter.scaleX;
			}
			
			if(int( (targetPosition.x - _holder.x) * 100 ) != 0)
				_holder.x += (targetPosition.x - _holder.x) * .1;
				
			if(int( (targetPosition.y - _holder.y) * 100 ) != 0)
				_holder.y += (targetPosition.y - _holder.y) * .1;			
			
			if(Math.abs( velocity.x + velocity.y ) > 0.01) {
				TweenLite.killTweensOf( targetPosition );
				TweenLite.killTweensOf( targetScale );
				_holder.x -= velocity.x;
				_holder.y -= velocity.y;
				targetPosition.x = _holder.x;
				targetPosition.y = _holder.y;

				velocity.x *= .8;
				velocity.y *= .8;
			}
			
			hover.x = mouseX + 4;
			hover.y = mouseY - hover.height - 4;
		}

		private function mouseWheel(event : MouseEvent) : void {
			targetScale.x += event.delta * .01;
			if(targetScale.x < MIN_ZOOM) targetScale.x = MIN_ZOOM;
			else if(targetScale.x > MAX_ZOOM) targetScale.x = MAX_ZOOM;
		}

		private function mouseDown(event : MouseEvent) : void {
			stage.addEventListener( MouseEvent.MOUSE_UP , mouseUp );
			mouseIsDown = true;
			mouseDownPoint.x = lastPoint.x = mouseX;
			mouseDownPoint.y = lastPoint.y = mouseY;
		}

		private function checkClick() : void {
			for each(var i:Image in imageAr) {
				if(i.hitTestPoint( mouseX + x , mouseY + y )) {
					var str : String = i.vo.id.toString( );
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
			drawScreen();			
			
			var i : Image;
			tagDic[Model.image.TAG_ALL] = [];
			for each(var v:ImageVO in ar) {
				i = new Image( v );
				i.addEventListener( MouseEvent.MOUSE_OVER , imageOver );
				i.addEventListener( MouseEvent.MOUSE_OUT , imageOut );
				_holder.addChild( i );
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
			if (Model.flickr.ratingsFound) sortBy(Model.BAR_SORT_RATING, 0);
			else sortBy(Model.BAR_SORT_RANDOM, 0);
			layout( );
		}

		private function drawScreen() : void {
			_screen = new Sprite();
			_screen.graphics.beginFill(Model.backgroundColor,.8);
			_screen.graphics.drawRect(-10000, -10000, 20000, 20000);
			_holder.addChild(_screen);
			
		}

		private function eScreenOver(event : MouseEvent) : void {
			hover.text = "CLICK AND DRAG!";
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
				_links.addChild( t );
				trails[Model.image.tagKeys[i]] = t;
			}
		}

		private function clearLinks() : void {
			while(_links.numChildren > 0)
				_links.removeChildAt( 0 );
		}

		private function select(i : Image = null) : void {
			var zoomed : Boolean = false;
			if(activeImage == i || i == null) {
				SWFAddress.setValue( '' );
				zoomOut( );
				return;
			} else {
				if(activeImage) zoomed = true;
				activeImage = i;
										
				bringImageToTop(i);
				bringScreenToTop();
				
				i.select( );
				var tx : int = (- activeImage.x - activeImage.centerWidth ) * _holder.scaleX;
				var ty : int = (- activeImage.y - activeImage.centerHeight) * _holder.scaleY;
				var ts : Number = Model.GRID_MAX_SIZE / i.size;
				
				TweenLite.to( targetScale , 1 , {x:ts , ease:Linear.easeNone} );				
				TweenLite.to( targetPosition , 1 , {x:tx , y:ty , ease:Quint.easeOut} );
				velocity.x = 0;
				velocity.y = 0;
			}
		}

		public function sortBy(type : String,time : int = 1) : void {
			select();
			
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
			activeImage = null;
			TweenLite.to( targetScale , 1 , {x:DEFAULT_ZOOM} );
		}

		private function clear() : void {
			while(imageAr.length > 0) {
				_holder.removeChild( Image( imageAr.shift( ) ) );
				trace( 'delete one' );
			}
		}

		public function get activeImage() : Image {
			return _activeImage;
		}

		public function set activeImage(val : Image) : void {
			if(activeImage) activeImage.deselect( );
			if(!val) bringScreenToBottom();
			
			if(Model.navBar) Model.navBar.select( val );
			_activeImage = val;
		}
	}
}
