package com.grid.view.elements {
	import com.grid.model.Model;
	import com.grid.view.Wall;
	import com.grid.vo.TagVO;
	import com.mt.view.elements.AbstractView;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author mikebook
	 */
	public class SortBar extends AbstractView {
		private var bg : Shape;
		private var textX : int = 10;
		private var tSortBy : Label;
		private var tSortRating : Link;
		private var tSortDate : Link;
		private var tSortRandom : Link;
		private static const HEIGHT : int = 30;
		private var links : Array = [];
		private var activeLink : TagLink;
		private var right : Sprite;
		private static const PAD_R : int = 12;
		private var tTopics : Label;
		private const TAG_SPACING : int = 10;
		private static const Y_OFF : int = 6;
		public function SortBar() {
			Model.sortBar = this;
			addChild(bg = new Shape());
			addChild(right = new Sprite());
			bg.graphics.beginFill(0x111111, 1);
			bg.graphics.drawRect(0, 1, 500, HEIGHT);
			bg.graphics.beginFill(0x333333, 1);
			bg.graphics.drawRect(0, 0, 500, 1);

			addText(tSortBy = new Label(Model.BAR_SORT_LABEL));
			addText(tSortRating = new Link(Model.BAR_SORT_RATING));
			tSortRating.addEventListener(MouseEvent.CLICK, eSortClick);
			addText(tSortDate = new Link(Model.BAR_SORT_DATE));
			tSortDate.addEventListener(MouseEvent.CLICK, eSortClick);
			addText(tSortRandom = new Link(Model.BAR_SORT_RANDOM));
			tSortRandom.addEventListener(MouseEvent.CLICK, eSortClick);

			right.addChild(tTopics = new Label(Model.BAR_TAG_LABEL));
			right.y = Y_OFF;
			var nextX : int = tTopics.width + TAG_SPACING;
			var l : TagLink;

			Model.image.tagAr.sortOn('imageCount', Array.DESCENDING | Array.NUMERIC);
			var count : int = 0;
			for each (var t:TagVO in Model.image.tagAr) {
				if (count > Model.FOOTER_MAX_TAGS) break;
				count++;
				if (Model.image.tags[t.tag_name]) {
					l = new TagLink(t.tag_name, Model.image.tags[t.tag_name].length);
					right.addChild(l);
					l.x = nextX;
					links[t.tag_name] = l;
					l.addEventListener(MouseEvent.MOUSE_OVER, linkOver);
					l.addEventListener(MouseEvent.MOUSE_OUT, linkOut);
					l.addEventListener(MouseEvent.CLICK, linkClick);
					nextX += l.width + TAG_SPACING;
				}
			}
			super();
		}

		private function linkClick(event : MouseEvent) : void {
			var l : TagLink = TagLink(event.target);
			if (activeLink && activeLink != l) activeLink.deselect();
			l.select();
			activeLink = l;
		}

		private function linkOut(event : MouseEvent) : void {
			var l : TagLink = TagLink(event.target);
			wall.hideTag(l.name);
			l.mouseOut();
			resetAll();
		}

		private function resetAll() : void {
			for each (var l:TagLink in links)
				l.unhighlight();
		}

		private function linkOver(event : MouseEvent) : void {
			var l : TagLink = TagLink(event.target);
			wall.showTag(l.name);
			l.mouseOver();
			highlightByID(l.name);
			// Model.notes.text = TagVO(Model.image.tagArObj[l.name]).description;
		}

		private function get wall() : Wall {
			return Model.app.wall;
		}

		public function highlightByID(str : String) : void {
			for each (var l:TagLink in links)
				l.unhighlight();
			if (links[str]) links[str].highlight();
		}

		private function eSortClick(event : MouseEvent) : void {
			Model.app.wall.sortBy(Link(event.target).name);
		}

		private function addText(s : Sprite, target : Sprite = null) : void {
			if (target) target.addChild(s);
			else addChild(s);
			s.y = Y_OFF;
			s.x = textX;
			textX += s.width + TAG_SPACING;
		}

		override public function resize() : void {
			bg.width = stage.stageWidth;
			var c:DisplayObject;
			var w:int = stage.stageWidth - textX - 50;
			var lastVis:int = right.width;
			for(var i:int = 0; i < right.numChildren; i++){				
				c = right.getChildAt(i);
				c.visible = true;
				if(c.x + c.width > w){
					c.visible = false;
					break;
				} else {
					lastVis = c.x + c.width;
				}
			}
			right.x = stage.stageWidth - lastVis - PAD_R;
			
//			right.x = Math.max(stage.stageWidth - right.width - PAD_R, textX + 50);
			y = stage.stageHeight - HEIGHT;
		}
	}
}
