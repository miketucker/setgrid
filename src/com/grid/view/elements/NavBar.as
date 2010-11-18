package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Image;
	import com.grid.view.Notes;
	import com.mt.view.elements.AbstractView;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;

	/**
	 * @author mikebook
	 */
	public class NavBar extends AbstractView {
		private static const HEIGHT : int = 30;
		private static const PAD : int = 12;
		private static const PAD_R : int = 12;
		private var bg : Shape;
		private var right : Sprite;
		private var left : Sprite;
		private var cText : Label;
		private var leftArrow : Shape;
		private var rightArrow : Shape;
		private var _currentImg : Image;
		private var extra : Sprite;
		private var help : Label;
		private var about : Label;
		private var notes : Notes;
		private static const Y_OFF : int = 6;
		private var _cTextBg : Shape;

		private function get c() : uint {
			return 0x666666;
		}

		public function NavBar() {
			super();
			Model.navBar = this;
			addChild(bg = new Shape());
			addChild(right = new Sprite());
			addChild(left = new Sprite());

			addChild(extra = new Sprite());
			extra.addChild(about = new Link(Model.BAR_EXTRA_ABOUT));
			about.addEventListener(MouseEvent.CLICK, eAboutClick);
		
			addChild(cText = new Label('', 0xFFFFFF));
			
			
			//cText.background = true;
			cText.addEventListener(MouseEvent.CLICK, eSelectImage);
			extra.y = left.y = right.y = cText.y = Y_OFF;
			bg.graphics.beginFill(0x111111, 1);
			bg.graphics.drawRect(0, 0, 500, HEIGHT);
			bg.graphics.beginFill(0x333333, 1);
			bg.graphics.drawRect(0, HEIGHT, 500, 1);
			extra.visible = false;
			leftArrow = drawArrow(false);
			rightArrow = drawArrow(true);
			leftArrow.x = PAD_R;
			leftArrow.y = rightArrow.y = HEIGHT * .5;
			left.x = PAD_R * 2;

			extra.x = PAD;
			addChild(leftArrow);
			addChild(rightArrow);

			addChild(notes = new Notes());
			notes.y = HEIGHT;
			notes.text = Model.NOTES_ABOUT;
			resize();
		}

		private function eAboutClick(event : MouseEvent) : void {
			notes.open();
			about.removeEventListener(MouseEvent.CLICK, eAboutClick);
			setTimeout(function() : void {
				stage.addEventListener(MouseEvent.CLICK, eCloseAbout);
			}, 10);
		}

		private function eCloseAbout(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.CLICK, eCloseAbout);
			about.addEventListener(MouseEvent.CLICK, eAboutClick);
			notes.close();
		}

		public function select(img : Image) : void {
			clear();
			if (!img) return;
			var ti : Image;
			_currentImg = img;
			cText.text = img.vo.label.toUpperCase();
			if (img.vo.siteURL) cText.buttonMode = true;
			resize();
			for each (var t:String in img.vo.tags) {
				ti = Model.image.getPrevImgByTag(t, img);
				if (ti) addTag(ti, t, true);

				ti = Model.image.getNextImgByTag(t, img);
				if (ti) addTag(ti, t, false);
			}
		}

		override public function resize() : void {
			// y = stage.stageHeight - height;
			bg.width = stage.stageWidth;
			rightArrow.x = stage.stageWidth - PAD_R;
			right.x = stage.stageWidth - PAD_R * 2;
			cText.x = (stage.stageWidth - cText.width ) * .5;
			
			var i:int = 0;
			var c:DisplayObject;
			var w:int = stage.stageWidth/2 - (cText.width/2 + 40);
			for(i = 0; i < right.numChildren; i++){				
				c = right.getChildAt(i);
				if(-c.x > w) c.visible = false;
				else c.visible = true;
			}
			for(i = 0; i < left.numChildren; i++){				
				c = left.getChildAt(i);
				if(c.x + c.width > w) c.visible = false;
				else c.visible = true;
			}
		}

		private function clear() : void {
			_currentImg = null;
			left.visible = false;
			extra.visible = true;
			cText.buttonMode = false;
			cText.text = Model.title.toUpperCase();
			while (left.numChildren > 0) left.removeChildAt(0);
			while (right.numChildren > 0) right.removeChildAt(0);
			resize();

			rightArrow.visible = leftArrow.visible = false;
		}

		private function eSelectImage(event : MouseEvent) : void {
			if (_currentImg && _currentImg.vo.siteURL) {
				navigateToURL(new URLRequest(_currentImg.vo.siteURL));
			}
		}

		private function drawArrow(_dir : Boolean) : Shape {
			var shape : Shape = new Shape();
			shape.graphics.beginFill(c);

			if (_dir) {
				shape.graphics.moveTo(- Y_OFF, - 5);
				shape.graphics.lineTo(5, 0);
				shape.graphics.lineTo(- Y_OFF, 5);
			} else {
				shape.graphics.moveTo(Y_OFF, - 5);
				shape.graphics.lineTo(- 5, 0);
				shape.graphics.lineTo(Y_OFF, 5);
			}
			return shape;
		}

		private function addTag(ti : Image, tag : String, doleft : Boolean = true) : void {
			extra.visible = false;
			var l : NavItem;
			if (doleft) {
				left.visible = true;
				leftArrow.visible = true;
				l = new NavItem(ti, tag);
				if (left.width > 0) l.x = left.width + PAD;
				trace('l',l.x,left.width,left.y,left.x);
				left.addChild(l);
			} else {
				rightArrow.visible = true;
				l = new NavItem(ti, tag);
				l.x = - right.width - l.width;
				if (right.width > 0) l.x -= PAD;
				right.addChild(l);
			}
			resize();
		}
	}
}
