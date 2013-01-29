package as2.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ProgressBarSprite extends FlxSprite 
	{		
		[Embed(source = "../../../res/progress_left.png")]
		public static var PROGRESS_LEFT_PNG : Class;
		
		[Embed(source = "../../../res/progress_right.png")]
		public static var PROGRESS_RIGHT_PNG : Class;
		
		[Embed(source = "../../../res/progress_middle.png")]
		public static var PROGRESS_MIDDLE_PNG : Class;
		
		[Embed(source = "../../../res/progress_left_bg.png")]
		public static var PROGRESS_LEFT_BG_PNG : Class;
		
		[Embed(source = "../../../res/progress_middle_bg.png")]
		public static var PROGRESS_MIDDLE_BG_PNG : Class;
		
		[Embed(source = "../../../res/progress_right_bg.png")]
		public static var PROGRESS_RIGHT_BG_PNG : Class;
		
		public static const PROGRESS_SPEED : Number = 1;
		
		private var _progressPercent : Number = 0;
		private var _progressTargetPercent : Number = 0;
		private var _initialProgress : Number = 0;
		
		private var _leftPixels : BitmapData;
		private var _rightPixels : BitmapData;
		private var _middlePixels : BitmapData;
		
		private var _leftPixelsBG : BitmapData;
		private var _middlePixelsBG : BitmapData;
		private var _rightPixelsBG : BitmapData;
		
		public function ProgressBarSprite(width : int = 0) 
		{
			this.width = width;
			
			_leftPixels = FlxG.addBitmap(PROGRESS_LEFT_PNG, false, false);
			_rightPixels = FlxG.addBitmap(PROGRESS_RIGHT_PNG, false, false);
			_middlePixels = FlxG.addBitmap(PROGRESS_MIDDLE_PNG, false, false);
			
			_leftPixelsBG = FlxG.addBitmap(PROGRESS_LEFT_BG_PNG, false, false);
			_middlePixelsBG = FlxG.addBitmap(PROGRESS_MIDDLE_BG_PNG, false, false);
			_rightPixelsBG = FlxG.addBitmap(PROGRESS_RIGHT_BG_PNG, false, false);
			
			_pixels = new BitmapData(width, _leftPixels.height, true, 0x0);
			framePixels = new BitmapData(width, _leftPixels.height, true, 0x0);
			
			this.x = 0;
			this.y = 0;
		}
		
		public function get progress():Number {
			return _progressPercent;
		}
		
		public function set progress(n : Number):void
		{
			if (n > 1) n = 1;
			if (n < 0) n = 0;
			if (n > targetProgress) n = targetProgress;
			
			_progressPercent = n;
		}
		
		public function get targetProgress():Number
		{
			return _progressTargetPercent;
		}
		
		public function set targetProgress(n : Number):void
		{
			_progressTargetPercent = n;
		}
		
		public function get initialProgress():Number
		{
			return _initialProgress;
		}
		
		public function set initialProgress(n : Number):void
		{
			_initialProgress = n;
		}
		
		override public function update():void
		{
			super.update();
			progress += (PROGRESS_SPEED * FlxG.elapsed) * Math.abs((targetProgress - _initialProgress));
		}
		
		override public function draw():void
		{
			var p : Point = new Point(0, 0);
			
			_pixels.copyPixels(_leftPixelsBG, _leftPixelsBG.rect, p);
			var matrix : Matrix = new Matrix();
			matrix.scale((width - _leftPixelsBG.width) - _rightPixelsBG.width, 1);
			matrix.translate(_leftPixelsBG.width, 0);
			_pixels.draw(_middlePixelsBG, matrix);
			p.x = _pixels.width - _rightPixelsBG.width;
			_pixels.copyPixels(_rightPixelsBG, _rightPixelsBG.rect, p);
			
			p.x = 0;
			p.y = 0;
			matrix.identity();
			
			
			_pixels.copyPixels(_leftPixels, _leftPixels.rect, p);
			
			var mwidth : int = (width * _progressPercent) - _leftPixels.width;
			if (mwidth < 0) mwidth = 0;
			if (mwidth > ((width - _leftPixels.width) - _rightPixels.width)) mwidth = (width - _leftPixels.width) - _rightPixels.width;
			
			matrix.scale(mwidth, 1);
			matrix.translate(_leftPixels.width, 0);
			
			_pixels.draw(_middlePixels, matrix);
			
			p.x = _leftPixels.width + mwidth;
			//_pixels.copyPixels(_rightPixels, _rightPixels.rect, p);
			matrix.identity();
			matrix.translate(p.x, 0);
			_pixels.draw(_rightPixels, matrix);
			
			p.x = 0;
			p.y = 0;
			
			framePixels.copyPixels(_pixels, _pixels.rect, p);
			_flashRect.width = framePixels.width;
			_flashRect.height = framePixels.height;
			super.draw();
		}
		
		
		
	}

}