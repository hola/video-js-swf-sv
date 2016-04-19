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
package com.apdevblog.ui.video.controls 
{
    import com.apdevblog.ui.video.style.ApdevVideoPlayerDefaultStyle;
    import com.apdevblog.utils.Draw;

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;

    /**
     * Play icon (displayed on the preview image).
     * 
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.ui.video
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: IconPlay.as 7 2009-10-13 16:46:31Z p.kyeck $
     * 
     * @see com.apdevblog.ui.video.ApdevVideoPlayer ApdevVideoPlayer
     */
    public class IconPlay extends Sprite 
    {
        /**
         * creates a play icon ("o" and draws a ">" in the middle).
         */
        public function IconPlay(_style:ApdevVideoPlayerDefaultStyle)
        {
            mouseEnabled = false;
            mouseChildren = false;

            var circle:Shape = Draw.circle(0, 0, 60, _style.playIconBg, _style.playIconBgAlpha);
            addChild(circle);

            var play:Shape = new Shape();
            var g:Graphics = play.graphics;
            g.beginFill(_style.playIcon, _style.playIconAlpha);
            g.moveTo(-12, -22);
            g.lineTo(20, 0);
            g.lineTo(-12, 22);
            g.lineTo(-12, -22);
            g.endFill();
            addChild(play);
        }
    }
}
