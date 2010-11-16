package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Image;
	import com.mt.view.elements.AbstractView;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author mikebook
	 */
	public class NavBar extends AbstractView {
		private static const HEIGHT : int = 20;
		private static const PAD : int = 10;
		private static const PAD_R : int = 10;
		private var bg : Shape;
		private var right : Sprite;
		private var left : Sprite;
		private var cText : Label;
		private var leftArrow : Shape;
		private var rightArrow : Shape;
		private var _currentImg : Image;
		private var _leftMask : Shape;
		private var _rightMask : Shape;

		private function get c() : uint {
			return 0x666666;
		}

		public function NavBar() {
			super( );
			Model.navBar = this;
			addChild( bg = new Shape( ) );
			addChild( right = new Sprite( ) );
			addChild( left = new Sprite( ) );
			_leftMask = new Shape();
			_leftMask.graphics.beginFill(0);
			_leftMask.graphics.drawRect(0, 0, 500, HEIGHT);
			
			_rightMask = new Shape();
			_rightMask.graphics.beginFill(0);
			_rightMask.graphics.drawRect(0, 0, 500, HEIGHT);
			
			
			addChild( cText = new Label( '' , 0xFFFFFF ) );
			cText.addEventListener(MouseEvent.CLICK, eSelectImage);
			left.y = right.y = cText.y = 3;
			bg.graphics.beginFill( 0x111111 , 1 );
			bg.graphics.drawRect( 0 , 0 , 500 , HEIGHT );
			bg.graphics.beginFill( 0x333333 , 1 );
			bg.graphics.drawRect( 0 , HEIGHT , 500 , 1 );
			
			leftArrow = drawArrow( false );
			rightArrow = drawArrow( true );
			leftArrow.x = PAD_R;
			leftArrow.y = rightArrow.y = HEIGHT * .5;
			_leftMask.x = left.x = PAD_R * 2;
			addChild( leftArrow );
			addChild( rightArrow );
			
			resize( );
		}
		
		public function select(img : Image) : void {
			clear( );
			if(! img) return;
			var ti : Image;
			_currentImg = img;
			cText.text = img.vo.label.toUpperCase( );
			if(img.vo.siteURL) cText.buttonMode = true;
			resize( );
			for each(var t:String in img.vo.tags) {
				ti = Model.image.getPrevImgByTag( t , img );
				if(ti) addTag( ti , t , true );
				
				ti = Model.image.getNextImgByTag( t , img );
				if(ti) addTag( ti , t , false );
			}
		}


		override public function resize() : void {
			//	y = stage.stageHeight - height;
			bg.width = stage.stageWidth;
			rightArrow.x = stage.stageWidth - PAD_R;
			right.x = stage.stageWidth - PAD_R * 2;
			cText.x = (stage.stageWidth - cText.width ) * .5;
		}

		private function clear() : void {
			_currentImg = null;
			cText.buttonMode = false;
			cText.text = Model.title;
			while(left.numChildren > 0) left.removeChildAt( 0 );
			while(right.numChildren > 0) right.removeChildAt( 0 );
			resize();
			
			rightArrow.visible = leftArrow.visible = false;
		}

		private function eSelectImage(event : MouseEvent) : void {
			if(_currentImg && _currentImg.vo.siteURL){
				navigateToURL(new URLRequest(_currentImg.vo.siteURL));
			}
		}

		private function drawArrow(_dir : Boolean) : Shape {
			var shape : Shape = new Shape( );
			shape.graphics.beginFill( c );
			
			if(_dir) {
				shape.graphics.moveTo( - 3 , - 5 );
				shape.graphics.lineTo( 5 , 0 );
				shape.graphics.lineTo( - 3 , 5 );
			} else {
				shape.graphics.moveTo( 3 , - 5 );
				shape.graphics.lineTo( - 5 , 0 );
				shape.graphics.lineTo( 3 , 5 );
			}
			return shape;
		}


		private function addTag(ti : Image,tag : String,doleft : Boolean = true) : void {
			var l : NavItem;
			if(doleft) {
				leftArrow.visible = true;
				l = new NavItem( ti , tag );
				if(left.width > 0) l.x = left.width + PAD;
				left.addChild( l );
			} else {
				rightArrow.visible = true;
				l = new NavItem( ti , tag );
				l.x = - right.width - l.width;
				if(right.width > 0) l.x -= PAD;
				right.addChild( l );
			}
		}

	}
}
