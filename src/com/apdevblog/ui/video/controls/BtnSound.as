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
    import com.apdevblog.events.video.VideoControlsEvent;
    import com.apdevblog.ui.video.style.ApdevVideoPlayerDefaultStyle;
    import com.apdevblog.utils.Draw;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     *  Dispatched when the user changes volume of video.
     *
     *  @eventType com.apdevblog.events.video.VideoControlsEvent
     */
    [Event(name="setVolume", type="com.apdevblog.events.video.VideoControlsEvent")]

    /**
     * Button controlling the video's sound.
     * 
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.ui.video
     * @author     Aron Woost / aron[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: BtnSound.as 7 2009-10-13 16:46:31Z p.kyeck $
     * 
     * @see com.apdevblog.ui.video.ApdevVideoPlayer ApdevVideoPlayer
     * @see com.apdevblog.ui.video.ApdevVideoControls ApdevVideoControls
     */
    public class BtnSound extends Sprite 
    {
        private var _bars:Array;
        private var _style:ApdevVideoPlayerDefaultStyle;

        /**
         * creates fullscreen button and initializes it.
         */
        public function BtnSound(style:ApdevVideoPlayerDefaultStyle)
        {
            _init(style);
        }

        /**
         * updates volume state (visually).
         * 
         * @param vol	video's current volume
         */
        public function updateState(vol:Number):void
        {
            var num:int = Math.ceil(vol * 7);
            for(var i:Number = 1;i < 9; i++) 
            {
                var bar:Shape = _bars[i - 1] as Shape;
                if(bar != null)
                {
                    bar.alpha = (i - 1 > num) ? .25 : 1;
                }
            }			
        }

        /**
         * draws initial button components.
         */
        private function _draw():void
        {
            var	bg:Shape = Draw.gradientRect(31, 23, 90,
                _style.btnGradient1, _style.btnGradient2,
                _style.btnGradient1Alpha, _style.btnGradient2Alpha);
            addChild(bg);

            _bars = new Array();

            for(var i:Number = 0;i < 8; i++) 
            {
                var bar:Shape = Draw.rect(2, i + 1, _style.btnIcon, 1);
                bar.x = 4 + (i * 3);
                bar.y = 16 - (1 + i);
                addChild(bar);

                _bars.push(bar);
            }
        }

        /**
         * initializes all important attributes and event listeners.
         */
        private function _init(style:ApdevVideoPlayerDefaultStyle):void
        {
            _style = style;
            mouseEnabled = true;
            buttonMode = true;

            _draw();

            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
        }

        /**
         * calculates the new volume value and fires event.
         */
        private function _updateVolume():void
        {
            var mX:int = mouseX;
            var vol:Number;

            if(mX < 4)
            {
                vol = 0;
            }
            else if(mX > 27)
            {
                vol = 1;
            }
            else
            {
                vol = (mX - 4) / 23;
            }

            dispatchEvent(new VideoControlsEvent(VideoControlsEvent.SET_VOLUME, true, true, vol));
        }

        /**
         * event handler - called when user drags the mouse.
         */
        private function onMouseMove(event:MouseEvent):void
        {
            _updateVolume();
        }

        /**
         * event handler - called when user presses button.
         */
        private function onMouseDown(event:MouseEvent):void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
        }

        /**
         * event handler - called when user releases button.
         */
        private function onMouseUp(event:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

            _updateVolume();
        }
    }
}