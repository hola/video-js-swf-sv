package com.videojs{
    
    import flash.display.Sprite;
    import flash.geom.Rectangle;
	
    public class VideoJSApp extends Sprite{
        
        private var _uiView:VideoJSView;
        private var _model:VideoJSModel;
        
        public function VideoJSApp(width:Number, height:Number){
            
            _model = VideoJSModel.getInstance()
            _model.stageRect = new Rectangle(0, 0, width, height);

            _uiView = new VideoJSView();
            addChild(_uiView);

        }
        
        public function get model():VideoJSModel{
            return _model;
        }
        
    }
}