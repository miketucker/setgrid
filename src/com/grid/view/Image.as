package com.grid.view {
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.grid.model.Model;
	import com.grid.vo.ImageVO;
	import com.mt.model.AbstractModel;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author mikepro
	 */
	public class Image extends Sprite {
		private var _vo : ImageVO;
		private var _size : int = 1;
		private var _cellX : int;
		private var _cellY : int;
		private var _enable : Boolean;
		private var shape : Shape;
		private var bit_low : Bitmap;
		private var bit_high : Bitmap;
		
		private static const TWEEN_SPEED : Number = .5;
		private var _isSelected : Boolean;
		
		private function get pad():Number{
			return Model.imagePad;
		}
		

		public function Image(v : ImageVO) {
			_vo = v;
			shape = new Shape();
			shape.graphics.beginFill( 0x000000 , 0 );
			shape.graphics.drawRect( 0 , 0 , Model.imageWidth , Model.imageHeight );

			resetSize();
			loadLow( );
			addEventListener(MouseEvent.CLICK,eClick );
			buttonMode = true;
		}
		
		public function resetSize():void{
			size = _vo.rating;
		}
		
		public function get centerWidth():int{
			return shape.width * .5;
		}
		
		public function get centerHeight():int{
			return  shape.height * .5;
		}
		
		public function select() : void {
			_isSelected = true;
			if(!bit_high) loadHigh();
			else 
				TweenLite.to(bit_high,1,{alpha:1,onComplete:function():void{bit_low.alpha = 0;}});
		}
		
		public function dim():void{
		//	alpha = .2;
			TweenLite.to(this,1,{alpha:.2,overwrite:2});
		}
		
		public function undim():void{
		//	alpha = 1;
			TweenLite.to(this,1,{alpha:1,overwrite:2});
		}
		
		public function deselect():void{
			_isSelected = false;
			bit_low.alpha = 1;
			if(bit_high) TweenLite.to(bit_high,TWEEN_SPEED,{alpha:0});
		}

		private function eClick(event : MouseEvent) : void {
			dispatchEvent(new Event( Event.OPEN ) );
		}

		private function loadHigh() : void {
			var li : LoadingItem = Model.asset.load( _vo.urlHigh , "high_" +  _vo.id , 100 );
			li.addEventListener( Event.COMPLETE , loadHighComplete );
		}
		
		private function loadHighComplete(event : Event) : void {
			bit_high = addBit(LoadingItem( event.target ).content,true,true);
			scaleBit();
		}

		private function loadLow() : void {
			var dir:String = Model.DIR_SM;
			if(_vo.type == Model.IMAGE_TYPE_DIRECTIONS || _vo.type == Model.IMAGE_TYPE_LINK) dir = Model.DIR_MD;
			var li : LoadingItem = Model.asset.load( _vo.urlLow , "low_" +  _vo.id );
			li.addEventListener( Event.COMPLETE , loadLowComplete );
		}

		private function loadLowComplete(event : Event) : void {
			bit_low = addBit( Bitmap(LoadingItem( event.target ).content) ,true);
			AbstractModel.debug.log('loaded '+bit_low+' '+_vo.id);
			scaleBit();
		}
		
		private function addBit(content : Bitmap,smooth:Boolean=false , isHigh:Boolean=false) : Bitmap {
			content.smoothing = smooth;
			content.alpha = 0;
			addChild( content );
			if(_isSelected || !isHigh) TweenLite.to(content,TWEEN_SPEED,{alpha:1});
			return content;
		}

		public function slide(delay:Number=0,time:Number=1,callback:Function=null):void{
			var tx:int = cellX * (Model.imageWidth);
			var ty:int = cellY * (Model.imageHeight);
			var scaleTime : Number = (time > 0) ? time - .1 : 0;

			TweenLite.to(this,time*.5,{x:tx,delay:delay+time*.5,ease:Quint.easeOut,onComplete:callback});			
			TweenLite.to(this,time*.5,{y:ty,delay:delay,ease:Linear.easeNone});
			if(shape) TweenLite.to(shape,scaleTime,{scaleX:size,ease:Quint.easeOut,scaleY:size,delay:delay,onUpdate:scaleBit});
		}

		public function get vo() : ImageVO {
			return _vo;
		}

		public function get size() : int {
			return _size;
		}

		public function get cellX() : int {
			return _cellX;
		}

		public function set cellX(cellX : int) : void {
			_cellX = cellX;
		}

		public function get cellY() : int {
			return _cellY;
		}

		public function set cellY(cellY : int) : void {
			_cellY = cellY;
		}

		public function set size(size : int) : void {
			_size = size;
		}
		
		private function scaleBit() : void {
			if(bit_low){
				bit_low.width = shape.width - pad;
				bit_low.height = shape.height - pad * (Model.imageHeight / Model.imageWidth);
				bit_low.x = pad * .5;
				bit_low.y = pad * .5;
			
			}
			
			if(bit_high){
				var r:Number = bit_high.bitmapData.width / bit_high.bitmapData.height;
				
				if(r < 1){
					bit_high.width = shape.width - pad;
					bit_high.height = bit_high.width * 1 / r;
					bit_high.x = pad * .5;
					bit_high.y = ((bit_high.width) - bit_high.height) * .5 + pad * .5;
				} else {
					bit_high.height = shape.height - pad;
					bit_high.width = bit_high.height * r;
					bit_high.y = pad * .5;
					bit_high.x = ((bit_high.height) - bit_high.width) * .5 + pad * .5;
				}
				
			}
		}
		
		public function get center():Point{
			var p:Point = new Point(x,y);
			p.x += width * .5 * scaleX;
			p.y += height * .5 * scaleY;
			
			return p;
		}
		
		public function get enable() : Boolean {
			return _enable;
		}
		
		public function set enable(enable : Boolean) : void {
			_enable = enable;
			visible = enable;
		}
	}
}
