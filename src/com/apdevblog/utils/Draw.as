/**
 * Copyright (c) 2009 apdevblog.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.apdevblog.utils 
{	
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.InterpolationMethod;
    import flash.display.Shape;
    import flash.display.SpreadMethod;
    import flash.geom.Matrix;	

    /**
     * Class with little helpers for drawing different Shapes.
     * 
     * @playerversion Flash 9
     * @langversion 3.0
     * @keyword drawing api, draw, shape
     * 
     * @package    com.apdevblog.utils
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: Draw.as 7 2009-10-13 16:46:31Z p.kyeck $
     */
    public class Draw 
    {
        public static var VERTICAL:int = 1;
        public static var HORIZONTAL:int = 2;
        // radians
        public static const TO_RADIANS:Number = Math.PI / 180;

        /**
         * draws a circle in a newly created Shape and fills it w/ the specified
         * BitmapData and alpha value.
         * 
         * @param offsetX	x position of the circle's center 
         * @param offsetY	y position of the circle's center
         * @param r			circle's radius
         * @param bmp		BitmapData the circle will be filled w/
         * @param alpha		alpha value of the created Shape @default 1
         * 
         * @return circular shape
         */
        public static function bitmapCircle(offsetX:Number, offsetY:Number, r:Number, bmp:BitmapData, alpha:Number = 1):Shape 
        {
            var mc:Shape = new Shape();

            mc.graphics.beginBitmapFill(bmp);

            mc.graphics.moveTo(offsetX + r, offsetY);
            mc.graphics.curveTo(r + offsetX, Math.tan(Math.PI / 8) * r + offsetY, Math.sin(Math.PI / 4) * r + offsetX, Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + offsetX, r + offsetY, offsetX, r + offsetY);
            mc.graphics.curveTo(-Math.tan(Math.PI / 8) * r + offsetX, r + offsetY, -Math.sin(Math.PI / 4) * r + offsetX, Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(-r + offsetX, Math.tan(Math.PI / 8) * r + offsetY, -r + offsetX, offsetY);
            mc.graphics.curveTo(-r + offsetX, -Math.tan(Math.PI / 8) * r + offsetY, -Math.sin(Math.PI / 4) * r + offsetX, -Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(-Math.tan(Math.PI / 8) * r + offsetX, -r + offsetY, offsetX, -r + offsetY);
            mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + offsetX, -r + offsetY, Math.sin(Math.PI / 4) * r + offsetX, -Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(r + offsetX, -Math.tan(Math.PI / 8) * r + offsetY, r + offsetX, offsetY);

            mc.graphics.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws a rectangle in a newly created Shape and 
         * fills it with submitted Bitmap.
         * 
         * @param w       width of the new rectangle
         * @param h       height of the new rectangle
         * @param bmp     BitmapData to fill the rect
         * @param alpha   alpha of the created Shape
         * 
         * @return rectangle shape
         */
        public static function bitmapRect(w:int, h:int, bmp:BitmapData, alpha:Number):Shape 
        {
            var mc:Shape = new Shape();
            mc.graphics.beginBitmapFill(bmp);
            mc.graphics.drawRect(0, 0, w, h);
            mc.graphics.endFill();
            mc.alpha = alpha;
            return mc;
        }

        /**
         * draws a rectangle with rounded corners in a newly created Shape and 
         * fills it with submitted Bitmap.
         * 
         * @param w       width of the new rectangle
         * @param h       height of the new rectangle
         * @param radius  corner radius of the new rectangle
         * @param bmp     BitmapData to fill the rect
         * @param alpha   alpha of the created Shape
         * 
         * @return rectangle shape with rounded edges
         */
        public static function bitmapRoundedRect(w:int, h:int, radius:int, bmp:BitmapData, alpha:Number):Shape 
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            g.beginBitmapFill(bmp);

            g.moveTo(radius, 0);
            g.curveTo(w - radius, 0, w - radius, 0);
            g.curveTo(w, 0, w, radius);
            g.curveTo(w, h - radius, w, h - radius);
            g.curveTo(w, h, w - radius, h);
            g.curveTo(radius, h, radius, h);
            g.curveTo(0, h, 0,  h - radius);
            g.curveTo(0, radius, 0, radius);
            g.curveTo(0, 0, radius, 0);

            g.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws a checkered rectangle in a newly created Shape.
         * 
         * @param w				width of the rectangle
         * @param h				height of the rectangle
         * @param color32_1		color of the first field 0xAARRGGBB
         * @param color32_2		color of the second field 0xAARRGGBB
         * @param alpha   		alpha of the created Shape @default 1
         * 
         * @return checkered rectangle
         */
        public static function checkeredRect(w:int, h:int, color32_1:uint, color32_2:uint, alpha:Number = 1):Shape
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            var p:BitmapData = new BitmapData(2, 2, true);
            p.lock();
            p.setPixel32(0, 0, color32_1);
            p.setPixel32(1, 0, color32_2);
            p.setPixel32(0, 1, color32_2);
            p.setPixel32(1, 1, color32_1);
            p.unlock();

            g.clear();
            g.beginBitmapFill(p);
            g.drawRect(0, 0, w, h);
            g.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws a circle in a newly created Shape and fills it w/ the specified
         * color and alpha value.
         * 
         * @param offsetX	x position of the circle's center 
         * @param offsetY	y position of the circle's center
         * @param r			circle's radius
         * @param color		color the circle will be filled w/
         * @param alpha		alpha value of the created Shape @default 1
         * 
         * @return circular shape
         */
        public static function circle(offsetX:Number, offsetY:Number, r:Number, color:Number, alpha:Number = 1):Shape 
        {
            var mc:Shape = new Shape();

            mc.graphics.beginFill(color, 1);

            mc.graphics.moveTo(offsetX + r, offsetY);
            mc.graphics.curveTo(r + offsetX, Math.tan(Math.PI / 8) * r + offsetY, Math.sin(Math.PI / 4) * r + offsetX, Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + offsetX, r + offsetY, offsetX, r + offsetY);
            mc.graphics.curveTo(-Math.tan(Math.PI / 8) * r + offsetX, r + offsetY, -Math.sin(Math.PI / 4) * r + offsetX, Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(-r + offsetX, Math.tan(Math.PI / 8) * r + offsetY, -r + offsetX, offsetY);
            mc.graphics.curveTo(-r + offsetX, -Math.tan(Math.PI / 8) * r + offsetY, -Math.sin(Math.PI / 4) * r + offsetX, -Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(-Math.tan(Math.PI / 8) * r + offsetX, -r + offsetY, offsetX, -r + offsetY);
            mc.graphics.curveTo(Math.tan(Math.PI / 8) * r + offsetX, -r + offsetY, Math.sin(Math.PI / 4) * r + offsetX, -Math.sin(Math.PI / 4) * r + offsetY);
            mc.graphics.curveTo(r + offsetX, -Math.tan(Math.PI / 8) * r + offsetY, r + offsetX, offsetY);

            mc.graphics.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws a cross (x) in a newly created Shape.
         * 
         * @param w       	width of the new cross
         * @param h       	height of the new cross
         * @param color   	color of the new cross
         * @param alpha   	alpha of the created Shape @default 1
         * @param lineWidth	width of the line @default 2
         * 
         * @return cross shape
         */
        public static function cross(w:int, h:int, color:int, alpha:Number = 1, lineWidth:int = 2):Shape 
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            g.lineStyle(lineWidth, color);
            g.lineTo(w, h);
            g.moveTo(0, h);
            g.lineTo(w, 0);
            g.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws a donut in a newly created shape.
         * 
         * @param r1         outer radius
         * @param r2         inner radius
         * @param deg        degrees (of a circle)
         */
        public static function donut(r1:Number, r2:Number, deg:Number, color:int, alpha:Number):Shape 
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            g.beginFill(color, 1);

            g.moveTo(0, 0);
            g.lineTo(r1, 0);

            // draw the 30-degree segments
            var a:Number = Math.tan(1 * Math.PI * 180);  
            var i:Number;

            var endx:Number;
            var endy:Number;
            var ax:Number;
            var ay:Number;		   

            for (i = 0;i < deg; i++) 
            {
                endx = r1 * Math.cos((i + 1) * TO_RADIANS);
                endy = r1 * Math.sin((i + 1) * TO_RADIANS);
                ax = endx + r1 * a * Math.cos(((i + 1) - 90) * TO_RADIANS);
                ay = endy + r1 * a * Math.sin(((i + 1) - 90) * TO_RADIANS);
                g.curveTo(ax, ay, endx, endy);	
            }

            // cut out middle (draw another circle before endFill applied)
            g.moveTo(0, 0);
            g.lineTo(r2, 0);

            for (i = 0;i < deg; i++) 
            {
                endx = r2 * Math.cos((i + 1) * TO_RADIANS);
                endy = r2 * Math.sin((i + 1) * TO_RADIANS);
                ax = endx + r2 * a * Math.cos(((i + 1) - 90) * TO_RADIANS);
                ay = endy + r2 * a * Math.sin(((i + 1) - 90) * TO_RADIANS);
                g.curveTo(ax, ay, endx, endy);	
            }

            mc.alpha = alpha;
            return mc;
        }

        /**
         * draws a dotted line in a newly created Shape.
         * 
         * @param length		length of the line
         * @param layout		orientation of the line (horizontal / vertical)
         * @param color32_1		color of the dots 0xAARRGGBB
         * @param color32_2		color of the spaces 0xAARRGGBB
         * @param w_1			length of the dots
         * @param w_2			length of the spaces
         * @param alpha   		alpha of the created Shape @default 1
         * 
         * @return dotted line
         */
        public static function dottedLine(length:int, layout:int, color32_1:uint, color32_2:uint, w_1:int = 1, w_2:int = 1, alpha:Number = 1):Shape
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            var w:int = layout == HORIZONTAL ? length : 1;
            var h:int = layout == HORIZONTAL ? 1 : length;

            var p:BitmapData = new BitmapData(w_1 + w_2, 1, true);
            p.lock();

            var i:int = 0;
            for(;i < w_1;i++) p.setPixel32(i, 0, color32_1);
            for(;i < w_1 + w_2;i++) p.setPixel32(i, 0, color32_2);
            p.unlock();

            var matrix:Matrix = new Matrix();
            if(layout == VERTICAL) matrix.rotate(90 * Math.PI / 180);

            g.clear();
            g.beginBitmapFill(p, matrix);
            g.drawRect(0, 0, w, h);
            g.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws a rectangle w/ gradient in a newly created Shape.
         * 
         * @param w			width of the rectangle
         * @param h			height of the rectangle
         * @param rotation	rotation of the gradient
         * @param color1	first color of the gradient
         * @param color2	second color of the gradient
         * @param alpha1   	first alpha of the gradient @default 1
         * @param alpha2   	second alpha of the gradient @default 1
         * 
         * @return rectangle filled w/ gradient
         */
        public static function gradientRect(w:Number, h:Number, rotation:Number, color1:Number, color2:Number, alpha1:Number = 1, alpha2:Number = 1):Shape
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            var colors:Array = [color1, color2];
            var fillType:String = GradientType.LINEAR;
            var alphas:Array = [alpha1, alpha2];
            var ratios:Array = [0, 255];
            var spreadMethod:String = SpreadMethod.PAD;
            var interpolationMethod:String = InterpolationMethod.RGB;

            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(w, h, rotation * Math.PI / 180, 0, 0);

            g.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod);
            g.drawRect(0, 0, w, h);

            return mc;					
        }

        /**
         * draws a checkered rectangle in a newly created Shape.
         * 
         * @param w			width of the rectangle
         * @param h			height of the rectangle
         * @param color		color of the rectangle
         * @param alpha   	alpha of the created Shape @default 1
         * @param x			x position of the created Shape @default 0
         * @param y		   	y position of the created Shape @default 0
         * 
         * @return rectangle
         */
        public static function rect(w:Number, h:Number, color:Number, alpha:Number = 1, x:Number = 0, y:Number = 0):Shape 
        {
            var mc:Shape = new Shape();
            mc.graphics.beginFill(color, 1);
            mc.graphics.moveTo(0, 0);
            mc.graphics.lineTo(w, 0);
            mc.graphics.lineTo(w, h);
            mc.graphics.lineTo(0, h);
            mc.graphics.lineTo(0, 0);
            mc.graphics.endFill();
            mc.alpha = alpha;
            mc.x = x;
            mc.y = y;
            return mc;
        }

        /**
         * draws a rectangle with rounded corners in a newly created Shape and 
         * fills it with specified color.
         * 
         * @param w       width of the new rectangle
         * @param h       height of the new rectangle
         * @param radius  corner radius of the new rectangle
         * @param color   color to fill the rect
         * @param alpha   alpha of the created Shape
         * 
         * @return colored rectangle shape with rounded edges
         */
        public static function roundedRect(x:Number, y:Number, w:Number, h:Number, radius:Number, color:Number, alpha:Number):Shape 
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            g.beginFill(color, 1);
            g.moveTo(x + radius, y);
            g.curveTo(x + w - radius, y, x + w - radius, y);
            g.curveTo(x + w, y, x + w, y + radius);
            g.curveTo(x + w, y + h - radius, x + w, y + h - radius);
            g.curveTo(x + w, y + h, x + w - radius, y + h);
            g.curveTo(x + radius, y + h, x + radius, y + h);
            g.curveTo(x, y + h, x, y + h - radius);
            g.curveTo(x, y + radius, x, y + radius);
            g.curveTo(x, y, x + radius, y);
            g.endFill();

            mc.alpha = alpha;

            return mc;
        }

        /**
         * draws an outline in a newly created Shape.
         * 
         * @param w       width of the new outline
         * @param h       height of the new outline
         * @param color   color of the new outline
         * @param alpha   alpha of the created Shape
         * 
         * @return rounded rectangle shape
         */
        public static function outline(w:int, h:int, color:int, alpha:Number):Shape 
        {
            var mc:Shape = new Shape();
            var g:Graphics = mc.graphics;

            g.beginFill(color, 1);
            g.drawRect(0, 0, w, 1);
            g.drawRect(0, 1, 1, h - 1);
            g.drawRect(w - 1, 1, 1, h - 1);
            g.drawRect(1, h - 1, w - 2, 1);
            g.endFill();

            mc.alpha = alpha;

            return mc;
        }
    }
}
