package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Image;
	import com.mt.view.elements.AbstractView;

	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author mikebook
	 */
	public class LinkCircle extends AbstractView {
		private static const MARGIN : int = 100;
		private var _links : Array;
		private var _img : Image;
		private var _tags : Array = [];
		private var bg : Shape;
		private var holder : Sprite;

		public function LinkCircle() {
			Model.linkCircle = this;
			bg = new Shape();
			//addChild(bg);
			addChild(holder = new Sprite());
			bg.graphics.lineStyle( 1 , 0xFFFFFF );
			bg.graphics.drawCircle( 0 , 0 , 500 );
			resize( );
		}

		public function select(i : Image) : void {
			if(! i) {
				deselect( );
			} else {
				_img = i;
				findTags();
			}
		}
		
		

		private function findTags():void{
			killTags();
		
			var ti:Image;
			for each(var t:XML in _img.vo.tags){
				trace('t',t);
				ti = Model.image.getPrevImgByTag(t,_img);
				if(ti){
					 trace('prev',ti.vo.url);
					addTag(ti,t,false);
				}
				ti = Model.image.getNextImgByTag(t,_img);
				if(ti){
					 trace('next',ti.vo.url);
					 addTag(ti,t,true);
					 
				}
			}
			var angle :Number;

			for each(var c:LinkCircleTag in _tags){
				angle = Math.atan2(c.img.x-_img.x,c.img.y-_img.y);
				trace(angle);
				c.x = Math.sin(angle) * (bg.width * ((.4 * Math.random()+.2)));
				c.y = Math.cos(angle) * (bg.width * ((.4 * Math.random()+.2)));
				c.open();
			}
		}
		
		private function addTag(ti : Image,t:String,dir:Boolean) : void {
			for each(var ct:LinkCircleTag in _tags){
				if(ct.img == ti){
					ct.addLabel(t);
					return;
				}
			}
			
			var c:LinkCircleTag = new LinkCircleTag(ti,t,dir);
			holder.addChild(c);
			_tags.push(c);
			
		}

		public function deselect() : void {
			_img = null;
			killTags();
		}
		
		private function killTags() : void {
			while(_tags.length > 0)
				LinkCircleTag(_tags.pop()).out();
			
		}

		override public function resize() : void {
			bg.width = stage.stageWidth - MARGIN;
			bg.height = stage.stageHeight - MARGIN;
			if(bg.scaleX < bg.scaleY) bg.scaleY = bg.scaleX;
			else bg.scaleX = bg.scaleY;	
		}

	}
}
