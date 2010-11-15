package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Image;
	import com.mt.view.elements.AbstractView;

	import flash.display.Shape;
	import flash.display.Sprite;

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

		private function get c() : uint {
			return 0x666666;
		}

		public function NavBar() {
			super( );
			Model.navBar = this;
			addChild( bg = new Shape( ) );
			addChild( right = new Sprite( ) );
			addChild( left = new Sprite( ) );
			addChild( cText = new Label( 'howdy' , 0xFFFFFF ) );
			left.y = right.y = cText.y = 3;
			bg.graphics.beginFill( 0x111111 , 1 );
			bg.graphics.drawRect( 0 , 0 , 500 , HEIGHT );
			bg.graphics.beginFill( 0x333333 , 1 );
			bg.graphics.drawRect( 0 , HEIGHT , 500 , 1 );
			
			leftArrow = drawArrow( false );
			rightArrow = drawArrow( true );
			leftArrow.x = PAD_R;
			leftArrow.y = rightArrow.y = HEIGHT * .5;
			left.x = PAD_R * 2;
			addChild( leftArrow );
			addChild( rightArrow );
			
			resize( );
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

		public function select(img : Image) : void {
			clear( );
			if(! img) return;
			var ti : Image;
			cText.text = img.vo.tagsAsString.toUpperCase( );
			resize( );
			for each(var t:XML in img.vo.tags) {
				ti = Model.image.getPrevImgByTag( t , img );
				if(ti) addTag( ti , t , true );
				
				ti = Model.image.getNextImgByTag( t , img );
				if(ti) addTag( ti , t , false );
			}
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

		override public function resize() : void {
			//	y = stage.stageHeight - height;
			bg.width = stage.stageWidth;
			rightArrow.x = stage.stageWidth - PAD_R;
			right.x = stage.stageWidth - PAD_R * 2;
			cText.x = (stage.stageWidth - cText.width ) * .5;
		}

		public function clear() : void {
			cText.text = Model.title;
			while(left.numChildren > 0) left.removeChildAt( 0 );
			while(right.numChildren > 0) right.removeChildAt( 0 );
			
			rightArrow.visible = leftArrow.visible = false;
		}
	}
}
