package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Image;
	import com.grid.vo.ImageVO;
	import com.mt.view.elements.AbstractSprite;

	/**
	 * @author mikebook
	 */
	public class TagTrail extends AbstractSprite {
		private var array:Array = [];
		public function TagTrail(images:Array) {
			this.array = images;
			refresh();
			
			hide( 0 );
		}
		
		private function refresh() : void {
			var ar:Array = [];
			for each(var v:ImageVO in array)
				if(v.img.enable) ar.push(v);
			
			if(!ar.length) return;
			
			var img:Image = ImageVO(ar[0]).img;
			graphics.clear();
			graphics.lineStyle(0,Model.TRAIL_COLOR,.2);
			graphics.moveTo(img.center.x,img.center.y);
			
			for(var i:int = 1 ; i < ar.length ; i++){
				img = ImageVO(ar[i]).img;
				graphics.lineTo(img.center.x, img.center.y);
			}
			
		}
		

		override public function show(time:Number=-1,callback:Function=null):void{
			refresh();
			super.show(time,callback);
		}
	}
}
