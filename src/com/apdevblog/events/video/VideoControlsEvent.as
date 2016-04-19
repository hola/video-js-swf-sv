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
package com.apdevblog.events.video 
{
    import flash.events.Event;

    /**
     * VideoControl specific Event.
     * 
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.events.video 
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: VideoControlsEvent.as 6 2009-09-27 12:31:47Z p.kyeck $
     */
    public class VideoControlsEvent extends Event 
    {
        public static const SEEK:String = "seek";
        public static const SCRUB:String = "scrub";
        //
        public static const TOGGLE_FULLSCREEN:String = "toggleFullscreen";
        public static const TOGGLE_PLAY_PAUSE:String = "togglePlayPause";
        public static const TOGGLE_SOUND:String = "toggleSound";
        //
        public static const SET_VOLUME:String = "setVolume";
        //
        public static const ENTER_FULLSCREEN:String = "enterFullscreen";
        //
        public static const STATE_UPDATE:String = "stateUpdate";
        //
        //
        private var _data:*;

        /**
         * create new VideoControlsEvent.
         * 
         * @param type			event type
         * @param bubbles		does event bubble
         * @param cancelable	can event be canceled
         * @param data			data fired w/ the event
         */
        public function VideoControlsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:*=null)
        {
            super(type, bubbles, cancelable);
            _data = data;
        }

        /**
         * @inheritDoc
         */
        public override function clone():Event 
        {
            return new VideoControlsEvent(type, bubbles, cancelable, data);
        }

        /**
         * @inheritDoc
         */
        public override function toString():String 
        { 
            return formatToString("VideoControlsEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
        }

        /**
         * event's data.
         */
        public function get data():*
        {
            return _data;
        }

        public function set data(data:*):void
        {
            _data = data;
        }
    }
}
