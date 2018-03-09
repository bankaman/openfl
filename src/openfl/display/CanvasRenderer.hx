package openfl.display;


import lime.graphics.CanvasRenderContext;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (js && html5)
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:allow(openfl._internal.renderer.canvas)
@:allow(openfl.display)


class CanvasRenderer extends DisplayObjectRenderer {
	
	
	public var context:CanvasRenderContext;
	public var pixelRatio (default, null):Float = 1;
	
	private var __isDOM:Bool;
	private var __tempMatrix:Matrix;
	
	
	private function new (context:CanvasRenderContext) {
		
		super ();
		
		this.context = context;
		
		__tempMatrix = new Matrix ();
		__type = CANVAS;
		
	}
	
	
	public function applySmoothing (context:CanvasRenderContext, value:Bool) {
		
		untyped (context).mozImageSmoothingEnabled = value;
		//untyped (context).webkitImageSmoothingEnabled = value;
		untyped (context).msImageSmoothingEnabled = value;
		untyped (context).imageSmoothingEnabled = value;
		
	}
	
	
	public function setTransform (transform:Matrix, context:CanvasRenderContext = null):Void {
		
		if (context == null) {
			
			context = this.context;
			
		} else if (this.context == context && __displayMatrix != null) {
			
			__tempMatrix.copyFrom (transform);
			__tempMatrix.concat (__displayMatrix);
			transform = __tempMatrix;
			
		}
		
		if (__roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
	}
	
	
	private override function __clear ():Void {
		
		__setBlendMode (NORMAL);
		
		if (__stage != null) {
			
			context.setTransform (1, 0, 0, 1, 0, 0);
			context.globalAlpha = 1;
			
			if (!__stage.__transparent && __stage.__clearBeforeRender) {
				
				context.fillStyle = __stage.__colorString;
				context.fillRect (0, 0, __stage.stageWidth * __stage.window.scale, __stage.stageHeight * __stage.window.scale);
				
			} else if (__stage.__transparent && __stage.__clearBeforeRender) {
				
				context.clearRect (0, 0, __stage.stageWidth * __stage.window.scale, __stage.stageHeight * __stage.window.scale);
				
			}
			
		}
		
	}
	
	
	private override function __popMask ():Void {
		
		context.restore ();
		
	}
	
	
	private override function __popMaskObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (!object.__cacheBitmapRender && object.__mask != null) {
			
			__popMask ();
			
		}
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			__popMaskRect ();
			
		}
		
	}
	
	
	private override function __popMaskRect ():Void {
		
		context.restore ();
		
	}
	
	
	private override function __pushMask (mask:DisplayObject):Void {
		
		context.save ();
		
		setTransform (mask.__renderTransform, context);
		
		context.beginPath ();
		mask.__renderCanvasMask (this);
		
		context.clip ();
		
	}
	
	
	private override function __pushMaskObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			__pushMaskRect (object.__scrollRect, object.__renderTransform);
			
		}
		
		if (!object.__cacheBitmapRender && object.__mask != null) {
			
			__pushMask (object.__mask);
			
		}
		
	}
	
	
	private override function __pushMaskRect (rect:Rectangle, transform:Matrix):Void {
		
		context.save ();
		
		setTransform (transform, context);
		
		context.beginPath ();
		context.rect (rect.x, rect.y, rect.width, rect.height);
		context.clip ();
		
	}
	
	
	private override function __render (object:IBitmapDrawable):Void {
		
		object.__renderCanvas (this);
		
	}
	
	
	private override function __renderStage3D (stage:Stage):Void {
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderCanvas (stage, this);
			
		}
		
	}
	
	
	private override function __setBlendMode (value:BlendMode):Void {
		
		if (__blendMode == value) return;
		
		__blendMode = value;
		
		switch (value) {
			
			case ADD:
				
				context.globalCompositeOperation = "lighter";
			
			case ALPHA:
				
				context.globalCompositeOperation = "destination-in";
			
			case DARKEN:
				
				context.globalCompositeOperation = "darken";
			
			case DIFFERENCE:
				
				context.globalCompositeOperation = "difference";
			
			case ERASE:
				
				context.globalCompositeOperation = "destination-out";
			
			case HARDLIGHT:
				
				context.globalCompositeOperation = "hard-light";
			
			//case INVERT:
				
				//context.globalCompositeOperation = "";
			
			case LAYER:
				
				context.globalCompositeOperation = "source-over";
			
			case LIGHTEN:
				
				context.globalCompositeOperation = "lighten";
			
			case MULTIPLY:
				
				context.globalCompositeOperation = "multiply";
			
			case OVERLAY:
				
				context.globalCompositeOperation = "overlay";
			
			case SCREEN:
				
				context.globalCompositeOperation = "screen";
			
			//case SHADER:
				
				//context.globalCompositeOperation = "";
			
			//case SUBTRACT:
				
				//context.globalCompositeOperation = "";
			
			default:
				
				context.globalCompositeOperation = "source-over";
			
		}
		
	}
	
	
}