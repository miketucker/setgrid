package com.grid.view {
	import com.grid.model.Model;

	public class Grid {
		private var _searchX : Array = [1, - 1, - 1, - 1];
		private var _searchY : Array = [1, - 1, - 1, 1];
		private const MIN_X : int = - 300;
		private const MAX_X : int = 300;
		private const MIN_Y : int = - 300;
		private const MAX_Y : int = 300;

		public function Grid() {
		}

		public function calculateOrdered(images : Array) : void {
			var tmpCopy : Array = [];
			var img : Image;
			for each (img in images) {
				img.resetSize();
				img.enable = true;
				if (img.size > 0) tmpCopy.push(img);
				else img.enable = false;
			}

			var ts : int = 2;
			var sx : int = - .5 * Model.GRID_COLUMNS * ts;
			var sy : int = - .5 * (tmpCopy.length / Model.GRID_COLUMNS) * ts;
			var nx : int = sx;
			var ny : int = sy;
			var max_x : int = Model.GRID_COLUMNS * ts;

			for (var i : int = 0; i < tmpCopy.length; i++) {
				img = Image(tmpCopy[i]);
				if (img.size > 0) {
					img.enable = true;
					img.size = ts;
					img.cellX = nx;
					img.cellY = ny;

					nx += ts;
					if (nx >= max_x + sx) {
						nx = sx;
						ny += ts;
					}
				} else {
					img.enable = false;
				}
			}
		}

		public function calculuateSpiral(images : Array, random : Boolean = false) : void {
			var tmpCopy : Array = [];
			var img : Image;
			var targetPos : int;
			var taken : Boolean = true;

			for each (img in images) {
				if (random) img.size = int(Math.random() * (Model.GRID_MAX_SIZE ) + 1);
				else img.resetSize();

				if (random) {
					taken = true;
					while (taken) {
						targetPos = int(Math.random() * images.length);
						if (tmpCopy[targetPos] == null) {
							tmpCopy[targetPos] = img;
							taken = false;
						}
					}
				} else {
					if (img.size > 0) tmpCopy.push(img);
				}
			}

			var tmpGrid : Object = {};
			for (var i : int = 0 ; i < tmpCopy.length; i++) {
		img = Image( tmpCopy[i] );
		img.enable = true;
		if(random) img.size = int(Math.random() * 5 + 1);
		else img.resetSize( );
		setThumbOnSpiral( img , tmpGrid );
		}
		}

		private function get random() : Boolean {
			// return Math.floor( Math.random( ) * 100 ) == 1;
			return true;
		}

		/**
		 * Find a cell in the grid to place the thumb
		 * @param	thumb
		 * @param	tmpGrid
		 */
		private function setThumbOnSpiral(image : Image, tmpGrid : Object) : void {
			var cx : int = 0;
			var cy : int = 0;
			var n : int = 1;
			// spiral from the center out checking each cell when we find a cell
			// that can contain the thumb, place it and exit
			while ( true ) {
				while ( ++cx <= n && cx < MAX_X && random) {
					if ( placeThumbOnCellIfEmpty(image, cx, cy, tmpGrid) ) return;
				}
				--cx;
				while ( ++cy <= n && cx < MAX_Y && random) {
					if ( placeThumbOnCellIfEmpty(image, cx, cy, tmpGrid) ) return;
				}
				--cy;
				while ( --cx >= - n && cx > MIN_X && random) {
					if ( placeThumbOnCellIfEmpty(image, cx, cy, tmpGrid) ) return;
				}
				++cx;
				while ( --cy >= - n && cy > MIN_Y && random) {
					if ( placeThumbOnCellIfEmpty(image, cx, cy, tmpGrid) ) return;
				}

				++cy;

				++n;
			}
		}

		/**
		 * Determine if the cell has enough empty cells next to it to fit the thumb.
		 * If it does, place the thumb and return true, otherwise return false
		 * @param	thumb
		 * @param	cx
		 * @param	cy
		 * @param	tmpGrid
		 * @return
		 */
		private function placeThumbOnCellIfEmpty(image : Image, cx : int, cy : int, tmpGrid : Object) : Boolean {
			if ( isCellEmpty(cx, cy, tmpGrid) ) {
				var n : int = image.size;
				var sx : int;
				var sy : int;
				var si : int = - 1;
				var emptyFound : Boolean = false;
				mainLoop:
				while ( ++si <= Model.GRID_MAX_SIZE ) {
					sx = _searchX[i] >= 0 ? cx : cx - ( n - 1 );
					sy = _searchY[i] >= 0 ? cy : cy - ( n - 1 );
					var i : int = sx;
					var j : int = sy;
					while ( i < sx + n ) {
						j = sy;
						while ( j < sy + n ) {
							if ( !isCellEmpty(i, j, tmpGrid) ) {
								continue mainLoop;
							}
							++j;
						}
						++i;
					}
					emptyFound = true;
					break;
				}
				if ( emptyFound ) {
					placeThumbOnCell(image, sx, sy, tmpGrid);
					return true;
				}
			}
			return false;
		}

		/**
		 * Place the thumb in the given cell. assumes neighboring cells (in the direction of bottom right) are empty
		 * @param	thumb
		 * @param	cx
		 * @param	cy
		 * @param	tmpGrid
		 */
		private function placeThumbOnCell(image : Image, cx : int, cy : int, tmpGrid : Object) : void {
			image.cellX = cx;
			image.cellY = cy;
			var n : int = image.size;
			var i : int = cx;
			var j : int = cy;
			while ( i < cx + n ) {
				j = cy;
				while ( j < cy + n ) {
					tmpGrid[i + "," + j] = image;
					++j;
				}
				++i;
			}
		}

		/**
		 * True if the given cell is empty
		 * @param	cx
		 * @param	cy
		 * @param	tmpGrid
		 * @return
		 */
		private function isCellEmpty(cx : int, cy : int, tmpGrid : Object) : Boolean {
			return tmpGrid[cx + "," + cy] == null;
		}
	}
}