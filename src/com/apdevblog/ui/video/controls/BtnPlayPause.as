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
    import com.apdevblog.ui.video.ApdevVideoState;
    import com.apdevblog.utils.Draw;

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;

    /**
     * Button controlling the video's playback state.
     *
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.ui.video
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: BtnPlayPause.as 7 2009-10-13 16:46:31Z p.kyeck $
     *
     * @see com.apdevblog.ui.video.ApdevVideoPlayer ApdevVideoPlayer
     * @see com.apdevblog.ui.video.ApdevVideoControls ApdevVideoControls
     */
    public class BtnPlayPause extends Sprite
    {
        private var _play:Sprite;
        private var _pause:Sprite;
        private var _state:String;
        private var _style:ApdevVideoPlayerDefaultStyle;

        /**
         * creates play/pause button and initializes it.
         */
        public function BtnPlayPause(style:ApdevVideoPlayerDefaultStyle)
        {
            _init(style);
        }

        /**
         * updates video's playback state (visually).
         *
         * @param state		the new ApdevVideoState
         */
        public function updateState(state:String):void
        {
            visible = true;
            _state = state;

            switch(state)
            {
            case ApdevVideoState.VIDEO_STATE_PLAYING:
                _play.visible = false;
                _pause.visible = true;
                break;

            case ApdevVideoState.VIDEO_STATE_PAUSED:
            case ApdevVideoState.VIDEO_STATE_STOPPED:
                _play.visible = true;
                _pause.visible = false;
                break;
            }
        }

        private function _draw():void
        {
            var	bg:Shape = Draw.gradientRect(23, 23, 90,
                _style.btnGradient1, _style.btnGradient2,
                _style.btnGradient1Alpha, _style.btnGradient2Alpha);
            addChild(bg);

            var g:Graphics;

            // play icon
            _play = new Sprite();
            g = _play.graphics;

            g.beginFill(_style.btnIcon, 1);
            g.drawRect(9, 5, 1, 1);
            g.drawRect(9, 6, 2, 1);
            g.drawRect(9, 7, 3, 1);
            g.drawRect(9, 8, 4, 1);
            g.drawRect(9, 9, 5, 1);
            g.drawRect(9, 10, 6, 1);
            g.drawRect(9, 11, 7, 1);
            g.drawRect(9, 12, 6, 1);
            g.drawRect(9, 13, 5, 1);
            g.drawRect(9, 14, 4, 1);
            g.drawRect(9, 15, 3, 1);
            g.drawRect(9, 16, 2, 1);
            g.drawRect(9, 17, 1, 1);
            g.endFill();

            addChild(_play);

            // pause icon
            _pause = new Sprite();
            _pause.visible = false;
            g = _pause.graphics;

            g.beginFill(_style.btnIcon, 1);
            g.drawRect(7, 5, 3, 12);
            g.drawRect(13, 5, 3, 12);
            g.endFill();

            addChild(_pause);
        }

        private function _init(style:ApdevVideoPlayerDefaultStyle):void
        {
            _style = style;
            buttonMode = true;
            mouseChildren = false;

            _draw();

            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);

            _state = ApdevVideoState.VIDEO_STATE_PAUSED;
        }

        private function onMouseOver(event:MouseEvent):void
        {
            var filter:GlowFilter = new GlowFilter();
            filter.color = _style.btnRollOverGlow;
            filter.alpha = _style.btnRollOverGlowAlpha;

            _pause.filters = [filter];
            _play.filters = [filter];
        }

        private function onMouseOut(event:MouseEvent):void
        {
            _pause.filters = [];
            _play.filters = [];
        }
    }
}
