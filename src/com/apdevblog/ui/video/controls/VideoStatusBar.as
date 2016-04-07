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
    import com.apdevblog.events.video.VideoControlsEvent;
    import com.apdevblog.model.vo.VideoMetadataVo;
    import com.apdevblog.utils.Draw;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     *  Dispatched when the user pressed statusbar.
     *
     *  @eventType com.apdevblog.events.video.VideoControlsEvent
     */
    [Event(name="togglePlayPause", type="com.apdevblog.events.video.VideoControlsEvent")]

    /**
     *  Dispatched when the user scrubs the statusbar.
     *
     *  @eventType com.apdevblog.events.video.VideoControlsEvent
     */
    [Event(name="scrub", type="com.apdevblog.events.video.VideoControlsEvent")]

    /**
     *  Dispatched when the user pressed and released statusbar.
     *
     *  @eventType com.apdevblog.events.video.VideoControlsEvent
     */
    [Event(name="seek", type="com.apdevblog.events.video.VideoControlsEvent")]

    /**
     * ApdevVideoplayer's statusbar.
     *
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.ui.video
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: VideoStatusBar.as 8 2009-12-24 11:29:22Z p.kyeck $
     * 
     * @see com.apdevblog.ui.video.ApdevVideoPlayer ApdevVideoPlayer
     * @see com.apdevblog.ui.video.ApdevVideoControls ApdevVideoControls
     */
    public class VideoStatusBar extends Sprite 
    {
        private var _barBg:Shape;
        private var _barLoading:Sprite;
        private var _barPlaying:Sprite;
        private var _duration:Number = 0;
        private var _knob:Sprite;
        private var _barLoadingMask:Shape;
        private var _componentWidth:int;
        private var _style:ApdevVideoPlayerDefaultStyle;

        /**
         * creates status bar.
         * 
         * @param width		bar's initial width
         */
        public function VideoStatusBar(width:int, style:ApdevVideoPlayerDefaultStyle)
        {
            _init(width, style);
        }

        /**
         * updates the visual loading status.
         * 
         * @param fraction		percents of the video that are already loaded 
         */
        public function updateLoading(fraction:Number):void
        {
            _barLoadingMask.scaleX = fraction <= 1 ? fraction : 1;
        }

        /**
         * receives video's new meta information.
         * 
         * @param meta		video's metadata
         */
        public function updateMeta(meta:VideoMetadataVo):void
        {
            _duration = meta.duration;
        }

        /**
         * adjusts the bar when the video's playing state changed.
         * 
         * @param fraction		percents of the video that are already played
         */
        public function updatePlaying(fraction:Number):void
        {
            _barPlaying.scaleX = fraction <= 1 ? fraction : 1;
            _knob.x = Math.round(_barPlaying.width); 
        }

        /**
         * creates different bars for the loading and playing status.
         */
        private function _createDynamicBars():void
        {
            if(_barLoading != null)
            {
                _barLoading.removeEventListener(MouseEvent.MOUSE_DOWN, onClickLoadingBar);
                removeChild(_barLoading);
                _barLoading = null;
            }
            if(_barLoadingMask != null)
            {
                removeChild(_barLoadingMask);
                _barLoadingMask = null;
            }
            if(_barPlaying != null)
            {
                removeChild(_barPlaying);
                _barPlaying = null;
            }

            _barLoading = new Sprite();
            _barLoading.buttonMode = true;
            _barLoading.addChild(Draw.rect(_barBg.width, 5, _style.barLoading, _style.barLoadingAlpha));
            _barLoading.addEventListener(MouseEvent.MOUSE_DOWN, onClickLoadingBar, false, 0, true);
            addChild(_barLoading);

            _barLoadingMask = Draw.rect(_barBg.width, 5, 0xFF0000, 1);
            addChild(_barLoadingMask);

            _barLoading.mask = _barLoadingMask;

            _barPlaying = new Sprite();
            _barPlaying.mouseEnabled = false;
            _barPlaying.addChild(Draw.rect(_barBg.width, 5, _style.barPlaying, 1));
            addChild(_barPlaying);

            _barLoadingMask.scaleX = 0;
            _barPlaying.scaleX = 0;
        }

        /**
         * draws bar's initial components.
         */
        private function _draw():void
        {			
            _barBg = Draw.rect(_componentWidth, 5, _style.barBg, _style.barBgAlpha);
            addChild(_barBg);

            _createDynamicBars();

            _knob = new Sprite();
            _knob.mouseEnabled = false;
            _knob.addChild(Draw.rect(5, 11, _style.barKnobOutline, _style.barKnobOutlineAlpha, -2, -3));	
            _knob.addChild(Draw.rect(3, 9, _style.barKnob, 1, -1, -2));	
            addChild(_knob);			
        }

        /**
         * initializes all important attributes and event listeners.
         */
        private function _init(width:int, style:ApdevVideoPlayerDefaultStyle):void
        {
            _componentWidth = width;
            _style = style;

            _draw();
        }

        /**
         * user wants to seek to another position of the video ...
         */
        private function _seek(scrubbing:Boolean):void
        {
            var position:Number = _barLoading.mouseX * _barLoading.scaleX / _barLoading.width;			
            var evt:VideoControlsEvent;
            if(scrubbing)
            {
                evt = new VideoControlsEvent(VideoControlsEvent.SCRUB, true, true, position);
            }
            else
            {
                evt = new VideoControlsEvent(VideoControlsEvent.SEEK, true, true, position);
            }
            dispatchEvent(evt);
        }

        /**
         * event handler - called when user clicks loading bar.
         */
        private function onClickLoadingBar(event:MouseEvent):void
        {
            _seek(true);

            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
        }

        /**
         * event handler - called when user drags/scrubs over loadingbar.
         */
        private function onMouseMove(event:MouseEvent):void
        {
            _seek(true);			
        }

        /**
         * event handler - called when user stops dragging/scrubbing over loadingbar.
         */
        private function onMouseUp(event:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            _seek(false);
        }

        /**
         * statusbar's width.
         */
        override public function set width(width:Number):void
        {
            _barBg.width = width;

            _createDynamicBars();
        }

        override public function get width():Number
        {
            return _barBg.width;
        }
    }
}
