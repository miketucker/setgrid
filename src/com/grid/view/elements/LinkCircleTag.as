package com.grid.view.elements {
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenLite;
	import com.grid.model.Model;
	import com.grid.view.Image;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author mikebook
	 */
	public class LinkCircleTag extends Sprite {
		private var _tag : String;
		private var _dir : Boolean;
		private var _endImg : Image;
		public var label : *;
		private var nextY : int;

		public function LinkCircleTag(endImg:Image,tag:String,direction:Boolean) {
			_endImg = endImg;
			_tag = tag;
			_dir = direction;
			
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(0, 0, 10);
				graphics.beginFill(c);
			
			if(_dir){
				graphics.moveTo(-3, -5);
				graphics.lineTo(5, 0);
				graphics.lineTo(-3, 5);
			} else {
				graphics.moveTo(3, -5);
				graphics.lineTo(-5, 0);
				graphics.lineTo(3, 5);
			}
			
			addChild(label = new Label(_tag,c));
			label.x = -.5 * label.width;
			label.y = 10;
			nextY = label.y + label.height-2;
			addEventListener(MouseEvent.CLICK,eClick );
			addEventListener(MouseEvent.MOUSE_OVER,eOver );
			addEventListener(MouseEvent.MOUSE_OUT,eOut );
			mouseChildren = false;
			buttonMode = true;
			scaleX = scaleY = 0;
		}
		
		private function eOut(event : MouseEvent) : void {
			Model.hover.hide();
		}

		private function eOver(event : MouseEvent) : void {
			Model.hover.vo = _endImg.vo;
		}

		public function out():void{
			TweenLite.to(this,1,{scaleX:0,scaleY:0,onComplete:function():void{
				if(this.parent) LinkCircleTag(this).parent.removeChild(LinkCircleTag(this));
			}});
		}
		
		private function get c():uint{
			//if(_dir) return 0x0000FF;
			//else return 0xFF0000;
			return 0x666666;
		}
		
		public function open():void{
			TweenLite.to(this,1,{scaleX:1,scaleY:1});
		}
		
		public function addLabel(str:String):void{
			var l:Label;
			addChild(l = new Label(str,c));
			l.y = nextY;
			l.x = -.5 * l.width;
			nextY += l.height - 2;
		}

		public function get tag():String{
			return _tag;
		}
		
		private function eClick(event : MouseEvent) : void {
			SWFAddress.setValue( _endImg.vo.id.toString( ) );
		}
		
		public function get img() : Image {
			return _endImg;
		}
	}
}
