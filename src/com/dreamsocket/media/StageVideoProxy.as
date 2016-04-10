/**
 * Copyright (c) 2010 Dreamsocket Incorporated.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/


package com.dreamsocket.media 
{
    import flash.events.Event;
    import flash.events.StageVideoEvent;
    import flash.events.StageVideoAvailabilityEvent;
    import flash.geom.Rectangle;
    import flash.media.StageVideo;
    import flash.media.StageVideoAvailability;
    import flash.media.Video;
    import flash.media.VideoStatus;
    import flash.net.NetStream;

    public class StageVideoProxy extends Video
    {
        protected var m_netStream:NetStream;
        protected var m_stageVideo:StageVideo;


        public function StageVideoProxy (p_width:int = 320, p_height:int = 240)
        {
            super(p_width, p_height);

            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }


        override public function set height(p_value:Number):void
        {
            if(p_value != this.height)
            {
                super.height = p_value;
                this.layoutView();
            }
        }


        override public function get videoHeight():int
        {
            return this.m_stageVideo ? this.m_stageVideo.videoHeight : super.videoHeight;
        }


        override public function get videoWidth():int
        {
            return this.m_stageVideo ? this.m_stageVideo.videoWidth : super.videoWidth;
        }


        override public function set width(p_value:Number):void
        {
            if(p_value != this.width)
            {
                super.width = p_value;
                this.layoutView();
            }
        }


        override public function set x(p_value:Number):void
        {
            if(p_value != this.x)
            {
                super.x = p_value;
                this.layoutView();
            }
        }


        override public function set y(p_value:Number):void
        {
            if(p_value != this.y)
            {
                super.y = p_value;
                this.layoutView();
            }
        }


        override public function attachNetStream(p_stream:NetStream):void
        {
            if(p_stream != this.m_netStream)
            {
                this.m_netStream = p_stream;
                this.teardownStream();
                this.setupStageVideo();
            }
        }

        protected function setupSpriteVideo():void
        {		
            this.m_stageVideo = null;
            super.attachNetStream(this.m_netStream);		
        }


        protected function setupStageVideo():void
        {	// only setup the view when video is on stage and there is a netstream attached
            // this helps prevent as much as possible the time when a StageVideo is initialized
            if(!this.stage || !this.m_netStream) return;

            try
            {
                if(!this.m_stageVideo && this.stage.stageVideos.length >= 1)
                {
                    this.m_stageVideo = this.stage.stageVideos[0];
                    this.m_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, this.onRenderStateChanged);
                    this.layoutView();
                }

                if(this.m_stageVideo)
                {
                    this.m_stageVideo.attachNetStream(this.m_netStream);
                }
                else
                {
                    this.setupSpriteVideo();
                }
            }
            catch(error:Error)
            {
                this.setupSpriteVideo();
            }
        }


        protected function teardownStream():void
        {	
            try
            {
                if(this.m_stageVideo)
                {
                    this.m_stageVideo.viewPort = new Rectangle(this.x, this.y, 0, 0);
                    this.m_stageVideo.attachNetStream(null);
                }
                else if(this.m_netStream)
                {
                    super.attachNetStream(null);
                    this.clear();
                }

            }
            catch(error:Error){}
        }	


        protected function layoutView():void
        {
            if(this.m_stageVideo)
                this.m_stageVideo.viewPort = new Rectangle(this.x, this.y, this.width, this.height);
        }


        protected function onAddedToStage(p_event:Event):void
        {
            //this.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, this.onStageVideoAvailabilityChanged);
            this.setupStageVideo();
            this.layoutView();
        }


        protected function onRemovedFromStage(p_event:Event):void
        {	
            //this.stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, this.onStageVideoAvailabilityChanged);
            this.teardownStream();
        }


        protected function onRenderStateChanged(p_event:StageVideoEvent):void
        {
            if (p_event.status==VideoStatus.UNAVAILABLE)
            {
                this.teardownStream();
                this.setupStageVideo();
            }
        }


        protected function onStageVideoAvailabilityChanged(p_event:Event):void
        {
            this.teardownStream();
            this.setupStageVideo();
        }
    }
}
