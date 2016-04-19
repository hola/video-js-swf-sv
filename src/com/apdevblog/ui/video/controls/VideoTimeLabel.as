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
    import com.apdevblog.utils.StringUtils;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    /**
     * Label displaying the video's current time (ASC or DESC).
     *
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.ui.video
     * @author     Philipp Kyeck / philipp[at]beta-interactive.de
     * @copyright  2009 beta_interactive
     * @version    SVN: $Id: VideoTimeLabel.as 8 2009-12-24 11:29:22Z p.kyeck $
     *
     * @see com.apdevblog.ui.video.ApdevVideoPlayer ApdevVideoPlayer
     * @see com.apdevblog.ui.video.ApdevVideoControls ApdevVideoControls
     */
    public class VideoTimeLabel extends Sprite
    {
        public static const STATE_COUNT_UP:String = "stateCountUp";
        public static const STATE_COUNT_DOWN:String = "stateCountDown";
        //
        private var _bg:Shape;
        private var _txt:TextField;
        private var _state:String;
        private var _meta:Object;
        private var _currentTime:Number;
        private var _style:ApdevVideoPlayerDefaultStyle;

        /**
         * creates a label to display already played/still remaining time.
         */
        public function VideoTimeLabel(style:ApdevVideoPlayerDefaultStyle)
        {
            _init(style);
        }

        /**
         * updates the video's time played.
         *
         * @param time		time that the video already played
         */
        public function update(time:Number):void
        {
            _currentTime = time;

            if(_state == VideoTimeLabel.STATE_COUNT_DOWN)
            {
                // cound down from total to 0
                var total:Number = _meta != null ? _meta.duration : 0;
                time = total - time;
                if(time < 0)
                {
                    time = 0;
                }
                _txt.textColor = _style.timerDown;
            }
            else
            {
                _txt.textColor = _style.timerUp;
            }

            var seconds:Number = time % 60;
            var minutes:Number = (time - seconds) / 60;

            var secondsStr:String = seconds.toString().split(".")[0];
            secondsStr = StringUtils.padString(secondsStr, 2, "0");
            var minutesStr:String = StringUtils.padString(minutes.toString(), 2, "0");

            _txt.text = minutesStr + ":" + secondsStr;
        }

        /**
         * updates video's metadata.
         *
         * @param meta		video's metadata
         */
        public function updateMeta(meta:Object):void
        {
            _meta = meta;
        }

        /**
         * draws label's initial components.
         */
        private function _draw():void
        {
            _bg = Draw.rect(34, 23, _style.timerBg, _style.timerBgAlpha);
            addChild(_bg);

            _txt = new TextField();
            _txt.width = 34;
            _txt.height = 18;
            _txt.y = 2;
            _txt.selectable = false;

            var tf:TextFormat = new TextFormat();
            tf.font = "Arial";
            tf.color = _style.timerUp;
            tf.size = 10;
            tf.kerning = true;
            tf.align = TextFormatAlign.CENTER;

            _txt.defaultTextFormat = tf;
            _txt.text = "00:00";

            addChild(_txt);
        }

        /**
         * initializes all important attributes and event listeners.
         */
        private function _init(style:ApdevVideoPlayerDefaultStyle):void
        {
            mouseChildren = false;
            buttonMode = true;
            _style = style;
            _state = VideoTimeLabel.STATE_COUNT_UP;
            _currentTime = 0;

            _draw();

            addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
        }

        /**
         * toggles time display state (count ASC or DESC).
         */
        private function _toggleState():void
        {
            if(_state == VideoTimeLabel.STATE_COUNT_UP)
            {
                _state = VideoTimeLabel.STATE_COUNT_DOWN;
            }
            else
            {
                _state = VideoTimeLabel.STATE_COUNT_UP;
            }

            update(_currentTime);
        }

        /**
         * event handler - called when user clicks label.
         */
        private function onMouseClick(event:MouseEvent):void
        {
            _toggleState();
        }
    }
}
