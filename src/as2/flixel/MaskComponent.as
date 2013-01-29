package as2.flixel 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import mx.core.FlexSprite;
	import org.component.Component;
	import org.component.Entity;
	import org.component.EntityManager;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.flixel.SpriteLibrary;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class MaskComponent extends Component 
	{		
		[Embed(source = "../../../res/mask_kernel.pbj", mimeType = "application/octet-stream")]
		public static const SHADER : Class;
	
		protected var _maskClass : Class = null;
		protected var _maskSprite : FlxSprite = null;
		
		protected var _maskWidth : uint = 0;
		protected var _maskHeight : uint = 0;
		
		protected var _originalPixels : BitmapData;
		
		protected var _shader : Shader;
		protected var _shaderFilter : ShaderFilter;
		protected var _dirty : Boolean = false;
		
		protected var _masks : Vector.<Mask> = new Vector.<Mask>();
		
		public function MaskComponent() 
		{
			super();
			
			addRequisiteComponent(FlxSpriteComponent);
			
			for (var i : int = 0; i < 4; i++)
			{
				var m : Mask = new Mask();
				m.color = 0x00000000;
				m.id = i;
				m.frame = 0;
				
				_masks.push(m);
			}
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_maskSprite = new FlxSprite(0, 0, _maskClass);
			_maskSprite.frameWidth = _maskWidth;
			_maskSprite.frameHeight = _maskHeight;
			
			_shader = new Shader();
			_shader.byteCode = new SHADER();
			_shaderFilter = new ShaderFilter(_shader);
			
			syncShaderData();
		}
		
		public function syncShaderData():void
		{
			//Setup parameters of shader
			_shader.data.maskFrameWidth.value = [ _maskWidth ];
			_shader.data.maskFrameHeight.value = [ _maskHeight ];
			_shader.data.maskWidth.value = [ _maskSprite.width ];
			
			_shader.data.mask.input = _maskSprite.pixels;
			
			var i : int = 0;
			for each (var m : Mask in _masks)
			{
				if (i++ >= 4) break;
				
				var r : Number = (m.color & 0x00FF0000) >> 16;
				var g : Number = (m.color & 0x0000FF00) >> 8;
				var b : Number = (m.color & 0x000000FF);
				var a : Number = (m.color >> 24) & 0x000000FF;
				
				r /= 0xFF;
				g /= 0xFF;
				b /= 0xFF;
				a /= 0xFF;
				
				var color : Array = [r, g, b, a];
				
				switch (i)
				{
					case 1:
						_shader.data.color1.value = color;
						_shader.data.mask1.value = [ m.frame ];
					break;
					
					case 2:
						_shader.data.color2.value = color;
						_shader.data.mask2.value = [ m.frame ];
					break;
					
					case 3:
						_shader.data.color3.value = color;
						_shader.data.mask3.value = [ m.frame ];
					break;
					
					case 4:
						_shader.data.color4.value = color;
						_shader.data.mask4.value = [ m.frame ];
					break;
				}
			}
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			_originalPixels = new BitmapData(baseSprite.pixels.width, baseSprite.pixels.height, true);
			_originalPixels.copyPixels(baseSprite.pixels, baseSprite.pixels.rect, new Point());
			
			calcFrame();
		}
		
		public function get flxSpriteComponent():FlxSpriteComponent
		{
			return getSiblingComponent(FlxSpriteComponent) as FlxSpriteComponent;
		}
		
		public function get baseSprite():FlxSprite
		{
			var fsc : FlxSpriteComponent = flxSpriteComponent;
			
			if (fsc != null)
			{
				return fsc.sprite;
			} else {
				return null;
			}
		}
		
		public function getMaskPixel(x : uint, y : uint, frame : uint):uint
		{
			x %= _maskSprite.frameWidth;
			y %= _maskSprite.frameHeight;
			
			var indexX:uint = frame*_maskSprite.frameWidth;
			var indexY:uint = 0;

			if(indexX >= _maskSprite.pixels.width)
			{
				indexY = uint(indexX/_maskSprite.pixels.width)*_maskSprite.frameHeight;
				indexX %= _maskSprite.pixels.width;
			}
			
			return _maskSprite.pixels.getPixel(indexX + x, indexY + y);
		}
		
		override public function update():void
		{
			super.update();
			
			if (_dirty)
			{
				calcFrame();
				_dirty  = false;
			}
		}
		
		public function calcFrame():void
		{
			syncShaderData();
			
			var sprite : FlxSprite = baseSprite;
			var pixels : BitmapData = _originalPixels;
			
			sprite.pixels.applyFilter(pixels, pixels.rect, new Point(), _shaderFilter);
			sprite.dirty = true;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message is MaskMessage)
			{
				var mm : MaskMessage = message as MaskMessage;
				
				if (mm.type == MaskMessage.SET_FRAME)
				{
					_masks[mm.maskIndex].frame = mm.frameIndex;
					//calcFrame();
					_dirty = true;
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "maskSprite"))
			{
				_maskClass = SpriteLibrary.getSpriteClass(xml.maskSprite);
			}
			
			var colors : Array;
			if (xmlElementExists(xml, "colors"))
			{
				colors = extractArray(xml.colors);
			}
			
			if (xmlElementExists(xml, "masks"))
			{
				var array : Array = extractArray(xml.masks);
				
				for (var i : int = 0; i < array.length; i++)
				{					
					_masks[i].color = parseInt(colors[i]);
					_masks[i].frame = array[i];
				}
			}
			
			if (xmlElementExists(xml, "maskWidth"))
			{
				_maskWidth = parseInt(xml.maskWidth);
			}
			
			if (xmlElementExists(xml, "maskHeight"))
			{
				_maskHeight = parseInt(xml.maskHeight);
			}
		}
	}
}

class Mask
{
	public var color : uint;
	public var frame : uint;
	public var id : uint;
}