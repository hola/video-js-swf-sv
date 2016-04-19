package com.videojs{

    import com.videojs.events.VideoJSEvent;
    import com.videojs.events.VideoPlaybackEvent;
    import com.videojs.structs.ExternalErrorEventName;
    import com.videojs.structs.ExternalEventName;
    import com.dreamsocket.media.StageVideoProxy;
    import com.apdevblog.ui.video.ApdevVideoControls;
    import com.apdevblog.ui.video.style.ApdevVideoPlayerDefaultStyle;
    import com.apdevblog.ui.video.ApdevVideoState;
    import com.apdevblog.ui.video.controls.ImageOverlay;
    import com.apdevblog.events.video.VideoControlsEvent;
    import flex.util.ui.throbber.SimpleThrobber;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.StageDisplayState;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.media.Video;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.utils.Timer;

    public class VideoJSView extends Sprite{

        private var _uiVideo:Video;
        private var _uiBackground:Sprite;
        private var _videoControls:ApdevVideoControls;
        private var _model:VideoJSModel;
        private var _positionTimer:Timer;
        private var _loadTimer:Timer;
        private var _activityTimer:Timer;
        private var _inactivityTimer:Timer;
        private var _throbberTimer:Timer;
        private var _scrubbing:Boolean;
        private var _wasPlaying:Boolean;
        private var _buffering:Boolean = false;
        private var _playerIdle:Boolean = true;
        private var _userActivity:Boolean = true;
        private var _userActive:Boolean = true;
        private var _image:ImageOverlay;
        private var _style:ApdevVideoPlayerDefaultStyle;
        private var _throbber:SimpleThrobber;

        public function VideoJSView(){

            _model = VideoJSModel.getInstance();
            _model.addEventListener(VideoJSEvent.BACKGROUND_COLOR_SET, onBackgroundColorSet);
            _model.addEventListener(VideoJSEvent.STAGE_RESIZE, onStageResize);
            _model.addEventListener(VideoJSEvent.CONTROLS_SET, toggleControls);
            _model.addEventListener(VideoJSEvent.POSTER_SET, onPosterSet);
            _model.addEventListener(VideoPlaybackEvent.ON_META_DATA, onMetaData);
            _model.addEventListener(VideoPlaybackEvent.ON_VIDEO_DIMENSION_UPDATE, onDimensionUpdate);
            _model.addEventListener(VideoPlaybackEvent.ON_STREAM_START, onPlayerIdleChange);
            _model.addEventListener(VideoPlaybackEvent.ON_STREAM_CLOSE, onPlayerIdleChange);
            _model.addEventListener(VideoPlaybackEvent.ON_NETSTREAM_STATUS, onNetStreamStatus);
            _positionTimer = new Timer(250);
            _positionTimer.addEventListener(TimerEvent.TIMER, updatePosition, false, 0, true);
            _loadTimer = new Timer(500);
            _loadTimer.addEventListener(TimerEvent.TIMER, updateLoading, false, 0, true);
            _activityTimer = new Timer(250);
            _activityTimer.addEventListener(TimerEvent.TIMER, userActivityCheck, false, 0, true);
            _inactivityTimer = new Timer(2000);
            _inactivityTimer.addEventListener(TimerEvent.TIMER, onInactive, false, 0, true);
            _throbberTimer = new Timer(500, 1);
            _throbberTimer.addEventListener(TimerEvent.TIMER, showThrobber, false, 0, true);

            _uiBackground = new Sprite();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
            _uiBackground.alpha = _model.backgroundAlpha;
            addChild(_uiBackground);

            _style = new ApdevVideoPlayerDefaultStyle();
            _image = new ImageOverlay(_model.stageRect.width, _model.stageRect.height, _style);
            showPoster(false);
            addChild(_image);

            _uiVideo = new StageVideoProxy();
            _uiVideo.width = _model.stageRect.width;
            _uiVideo.height = _model.stageRect.height;
            _uiVideo.smoothing = true;
            addChild(_uiVideo);

            _throbber = new SimpleThrobber();
            _throbber.hideWhenStopped = true;
            moveThrobber();
            addChild(_throbber);

            _model.videoReference = _uiVideo;
            listenForUserActivity();
        }

        private function setUserActive(active:Boolean):void{
            if (active==_userActive)
                return;
            _userActive = active;
            if (!_videoControls || _playerIdle)
                return;
            if (active)
                showControls(true);
            else if (!_model.paused)
                showControls(false);
        }

        private function onPlayerIdleChange(e:VideoPlaybackEvent):void{
            _playerIdle = e.type==VideoPlaybackEvent.ON_STREAM_CLOSE;
            showControls(true);
            if (!_playerIdle)
                showPoster(false);
        }

        private function setBuffering(buffering:Boolean){
            if (_buffering==buffering)
                return;
            if (_model.controls)
                buffering ? _throbberTimer.start() : _throbber.stop();
            _buffering = buffering;
        }

        private function onNetStreamStatus(e:VideoPlaybackEvent):void{
            switch (e.data.info.code){
            case "NetStream.Buffer.Full": setBuffering(false); break;
            case "NetStream.Buffer.Empty":
            case "NetStream.SeekStart.Notify": setBuffering(true); break;
            }
        }

        private function toggleControls(e:VideoJSEvent):void{
            _model.controls ? enableControls() : disableControls();
        }

        private function enableControls():void{
            if (!_model.paused)
                _positionTimer.start();
            _loadTimer.start();
            _model.addEventListener(ExternalEventName.ON_START, onExternalEvent);
            _model.addEventListener(ExternalEventName.ON_PAUSE, onExternalEvent);
            _model.addEventListener(ExternalEventName.ON_RESUME, onExternalEvent);
            _model.addEventListener(ExternalEventName.ON_PLAYBACK_COMPLETE, onExternalEvent);
            _model.addEventListener(ExternalEventName.ON_VOLUME_CHANGE, onExternalEvent);
            _model.addEventListener(VideoJSEvent.FULL_SCREEN_CHANGE, updateDisplayState);
            addEventListener(VideoControlsEvent.SEEK, onSeek, false, 0, true);
            addEventListener(VideoControlsEvent.SCRUB, onSeek, false, 0, true);
            addEventListener(VideoControlsEvent.TOGGLE_PLAY_PAUSE, onTogglePlay, false, 0, true);
            addEventListener(VideoControlsEvent.SET_VOLUME, onChangeVolume, false, 0, true);
            addEventListener(VideoControlsEvent.ENTER_FULLSCREEN, onChangeDisplaystate, false, 0, true);
            _scrubbing = false;
            _wasPlaying = false;
            _videoControls = new ApdevVideoControls(_uiVideo.width, _style);
            _videoControls.y = height-_videoControls.height; 
            _videoControls.state = _model.paused ?
                ApdevVideoState.VIDEO_STATE_PAUSED :
                ApdevVideoState.VIDEO_STATE_PLAYING;
            updateMeta();
            updateVolume();
            updateLoading(null);
            updatePosition(null);
            updateDisplayState(null);
            showControls(false);
            addChild(_videoControls);
            if (_playerIdle)
                showPoster(true);
            else
                showControls(true);
        }

        private function disableControls():void{
            showPoster(false);
            _positionTimer.stop();
            _loadTimer.stop();
            _model.removeEventListener(ExternalEventName.ON_START, onExternalEvent);
            _model.removeEventListener(ExternalEventName.ON_PAUSE, onExternalEvent);
            _model.removeEventListener(ExternalEventName.ON_RESUME, onExternalEvent);
            _model.removeEventListener(ExternalEventName.ON_PLAYBACK_COMPLETE, onExternalEvent);
            _model.removeEventListener(ExternalEventName.ON_VOLUME_CHANGE, onExternalEvent);
            _model.removeEventListener(VideoJSEvent.FULL_SCREEN_CHANGE, updateDisplayState);
            removeEventListener(VideoControlsEvent.SEEK, onSeek, false);
            removeEventListener(VideoControlsEvent.SCRUB, onSeek, false);
            removeEventListener(VideoControlsEvent.TOGGLE_PLAY_PAUSE, onTogglePlay, false);
            removeEventListener(VideoControlsEvent.SET_VOLUME, onChangeVolume, false);
            removeEventListener(VideoControlsEvent.ENTER_FULLSCREEN, onChangeDisplaystate, false);
            removeChild(_videoControls);
            _videoControls = null;
        }

        private function sizeVideoObject():void{

            var __targetWidth:int, __targetHeight:int;

            var __availableWidth:int = _model.stageRect.width;
            var __availableHeight:int = _model.stageRect.height;

            var __nativeWidth:int = 100;

            if(_model.metadata.width != undefined){
                __nativeWidth = Number(_model.metadata.width);
            }

            if(_uiVideo.videoWidth != 0){
                __nativeWidth = _uiVideo.videoWidth;
            }

            var __nativeHeight:int = 100;

            if(_model.metadata.width != undefined){
                __nativeHeight = Number(_model.metadata.height);
            }

            if(_uiVideo.videoWidth != 0){
                __nativeHeight = _uiVideo.videoHeight;
            }

            // first, size the whole thing down based on the available width
            __targetWidth = __availableWidth;
            __targetHeight = __targetWidth * (__nativeHeight / __nativeWidth);

            if(__targetHeight > __availableHeight){
                __targetWidth = __targetWidth * (__availableHeight / __targetHeight);
                __targetHeight = __availableHeight;
            }

            _uiVideo.width = __targetWidth;
            _uiVideo.height = __targetHeight;

            _uiVideo.x = Math.round((_model.stageRect.width - _uiVideo.width) / 2);
            _uiVideo.y = Math.round((_model.stageRect.height - _uiVideo.height) / 2);
            if (_videoControls)
            {
                _videoControls.width = __availableWidth;
                _videoControls.y = __availableHeight-_videoControls.height; 
            }
        }

        private function sizePoster():void{
            _image.resize(_model.stageRect.width, _model.stageRect.height);
        }

        private function showThrobber(e:TimerEvent):void{
            if (_buffering)
                _throbber.start();
            _throbberTimer.reset();
        }

        private function moveThrobber():void{
            _throbber.x = Math.round((_model.stageRect.width - _throbber.w) / 2);
            _throbber.y = Math.round((_model.stageRect.height - _throbber.h) / 2);
        }

        private function onBackgroundColorSet(e:VideoJSEvent):void{
            _uiBackground.graphics.clear();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
        }

        private function onStageResize(e:VideoJSEvent):void{
            onBackgroundColorSet(null);
            sizeVideoObject();
            sizePoster();
            moveThrobber();
        }

        private function onPosterSet(e:VideoJSEvent):void{
            if (_playerIdle && _model.controls && _model.poster)
                showPoster(true);
        }

        private function showPoster(show:Boolean):void{
            if (show)
                _image.load(_model.poster);
            _image.visible = show;
        }

        private function onMetaData(e:VideoPlaybackEvent):void{
            if (_videoControls)
                updateMeta();
            sizeVideoObject();
        }

        private function onDimensionUpdate(e:VideoPlaybackEvent):void{
            sizeVideoObject();
        }

        private function updateLoading(event:TimerEvent):void
        {
            var buffered:Array;
            if (!_model.duration || !(buffered = _model.buffered).length)
                return;
            var start:Number = buffered[0][0], end:Number = buffered[0][1];
            var d:Number = Math.min(end, _model.duration)-start;
            _videoControls.updateLoading(d/_model.duration);
            if (d==_model.duration)
                _loadTimer.stop();
        }

        private function updatePosition(event:TimerEvent):void{
            if (_model.duration)
                _videoControls.updatePlaying(_model.time/_model.duration);
        }

        private function updateVolume():void{
            _videoControls.volume = _model.volume;
        }

        private function updateMeta():void{
            _videoControls.meta = {duration: _model.duration};
        }

        private function onExternalEvent(e:Event):void{
            switch (e.type){
            case "playing":
            case "play":
                _videoControls.state = ApdevVideoState.VIDEO_STATE_PLAYING;
                _positionTimer.start();
                break;
            case "pause":
                _videoControls.state = ApdevVideoState.VIDEO_STATE_PAUSED;
                updatePosition(null);
                _positionTimer.stop();
                break;
            case "volumechange": updateVolume(); break;
            }
        }

        private function showControls(show:Boolean):void{
            if (_videoControls)
                _videoControls.visible = show;
        }

        private function seekBySeconds(sec:Number):void{
            _model.seekBySeconds(sec);
            _model.broadcastEventExternally(ExternalEventName.ON_SEEK_START);
        }

        private function onSeek(e:VideoControlsEvent):void{
            if (!_model.duration)
                return;
            var scrubbing:Boolean = e.type==VideoControlsEvent.SCRUB;
            if (_scrubbing && !scrubbing) // end scrubbing
            {
                if (_wasPlaying)
                    _model.play();
            }
            else
            {
                var d:Number = _model.duration, to:Number = e.data * d;
                // dont end while scrubbing
                to = Math.max(0, Math.min(to, d-0.1));
                _videoControls.updatePlaying(to/d);
                seekBySeconds(to);
                if (!_scrubbing && scrubbing && (_wasPlaying = !_model.paused))
                    _model.pause(); // started scrubbing and is playing
            }
            _scrubbing = scrubbing;
        }

        private function onTogglePlay(e:VideoControlsEvent):void{
            if (_model.hasEnded)
            {
                seekBySeconds(0);
                _model.play();
                return;
            }
            if (_model.paused)
                _model.play();
            else
                _model.pause();
        }

        private function onChangeVolume(e:VideoControlsEvent):void{
            _model.volume = e.data as Number;
        }

        private function onChangeDisplaystate(e:VideoControlsEvent):void{
            stage.displayState =
                stage.displayState==StageDisplayState.FULL_SCREEN ?
                StageDisplayState.NORMAL : 
                StageDisplayState.FULL_SCREEN;
        }

        private function updateDisplayState(event:VideoJSEvent):void{
            _videoControls.updateDisplayState(stage.displayState);
        }

        private function listenForUserActivity():void{
            addEventListener(MouseEvent.CLICK, onUserAction);
            addEventListener(MouseEvent.MOUSE_MOVE, onUserAction);
            _activityTimer.start();
        }

        private function onUserAction(e:MouseEvent):void{
            _userActivity = true;
        }

        private function onInactive(e:TimerEvent):void{
            setUserActive(false);
        }

        private function userActivityCheck(e:TimerEvent):void{
            if (_userActivity)
            {
                _inactivityTimer.stop();
                setUserActive(true);
            }
            else
                _inactivityTimer.start();
            _userActivity = false;
        }
    }
}
