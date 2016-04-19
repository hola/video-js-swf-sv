package com.apdevblog.ui.video.style 
{
    import com.apdevblog.utils.StringUtils;

    /**
     * Default style-sheet for the VideoPlayer.
     * 
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.ui.video.style
     * @author     phil / philipp[at]beta-interactive.de
     * @copyright  2009 beta_interactive
     * @version    SVN: $Id$
     */
    public class ApdevVideoPlayerDefaultStyle 
    {
        // player ///////////////////////////////

        /**
         * background gradient color top
         */
        public var bgGradient1:uint = 0x000000;

        /**
         * background gradient alpha top
         */
        public var bgGradient1Alpha:Number = 1.0;

        /**
         * background gradient color bottom
         */
        public var bgGradient2:uint = 0x000000;

        /**
         * background gradient alpha bottom
         */
        public var bgGradient2Alpha:Number = 1.0;

        // controls /////////////////////////////

        /**
         * background color for videocontrols
         */
        public var controlsBg:uint = 0x2b333f;

        /**
         * videocontrols' background alpha
         */
        public var controlsBgAlpha:Number = 0.7;

        /**
         * btn's background gradient color top
         */
        public var btnGradient1:uint = 0x2b333f;

        /**
         * btn's background gradient alpha top
         */
        public var btnGradient1Alpha:Number = 0.0;

        /**
         * btn's background gradient color bottom
         */
        public var btnGradient2:uint = 0x2b333f;

        /**
         * btn's background gradient alpha bottom
         */
        public var btnGradient2Alpha:Number = 0.0;

        /**
         * btn's icon color
         */
        public var btnIcon:uint = 0xffffff;

        /**
         * btn's icon glow color
         */
        public var btnRollOverGlow:uint = 0xffffff;

        /**
         * btn's icon glow alpha
         */
        public var btnRollOverGlowAlpha:Number = 0.4;

        // timer ////////////////////////////////

        /**
         * background color for timer control
         */
        public var timerBg:uint = 0x000000;

        /**
         * timercontrol's background alpha
         */
        public var timerBgAlpha:Number = 0.0;

        /**
         * text color when timer is counting up
         */
        public var timerUp:uint = 0xffffff;

        /**
         * text color when timer is counting down
         */
        public var timerDown:uint = 0xffffff;

        // bars /////////////////////////////////

        /**
         * background color of time-bar
         */
        public var barBg:uint = 0x73859f;

        /**
         * alpha of time-bar
         */
        public var barBgAlpha:Number = 0.5;

        /**
         * background color of time-bar (loading)
         */
        public var barLoading:uint = 0x73859f;

        /**
         * alpha of time-bar (loading)
         */
        public var barLoadingAlpha:Number = 0.5;

        /**
         * background color of time-bar (playing)
         */
        public var barPlaying:uint = 0xffffff;

        /**
         * color of the knob on the time-bar 
         */
        public var barKnob:uint = 0xffffff;

        /**
         * color of the knob's outline on the time-bar
         */
        public var barKnobOutline:uint = 0x000000;

        /**
         * alpha of the knob's outline on the time-bar
         */
        public var barKnobOutlineAlpha:Number = 0.2;

        // play icon ////////////////////////////

        /**
         * color of the big play icon (only shown when using jpg at the beginning)
         */
        public var playIcon:uint = 0xffffff;

        /**
         * alpha of the big play icon
         */
        public var playIconAlpha:Number = 0.8;

        /**
         * color of the big play icon background (only shown when using jpg at the beginning)
         */
        public var playIconBg:uint = 0x2d2d2d;

        /**
         * alpha of the big play icon background
         */
        public var playIconBgAlpha:Number = 0.6;

        /**
         * btn's icon glow color
         */
        public var playIconRollOverGlow:uint = 0x2b333f;

        /**
         * btn's icon glow alpha
         */
        public var playIconRollOverGlowAlpha:Number = 0.4;

        // paddings /////////////////////////////

        /**
         * videocontrols padding left side (in pixel) 
         */
        public var controlsPaddingLeft:uint = 0;

        /**
         * videocontrols padding right side (in pixel)
         */
        public var controlsPaddingRight:uint = 5;

        // flags ////////////////////////////////

        /**
         * flag for ignoring any style-info passed via flashvars
         */
        public var ignoreFlashvars:Boolean = false;


        /**
         * check passed flashvars for style information
         * 
         * @param flashvars		object containing flashvars
         */
        public function feedFlashvars(flashvars:Object):void
        {
            if(!ignoreFlashvars && flashvars != null)
            {
                for(var key:String in flashvars)
                {
                    switch(key)
                    {
                    case "bgGradient1": bgGradient1 = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "bgGradient1Alpha": bgGradient1Alpha = flashvars[key]; break;
                    case "bgGradient2": bgGradient2 = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "bgGradient2Alpha": bgGradient2Alpha = flashvars[key]; break;
                                             //
                    case "controlsBg": controlsBg = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "controlsBgAlpha": controlsBgAlpha = flashvars[key]; break;
                                            //
                    case "btnGradient1": btnGradient1 = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "btnGradient2": btnGradient2 = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "btnIcon": btnIcon = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "btnRollOverGlow": btnRollOverGlow = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "btnRollOverGlowAlpha": btnRollOverGlowAlpha = flashvars[key]; break;
                                                 //
                    case "timerBg": timerBg = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "timerBgAlpha": timerBgAlpha = flashvars[key]; break;
                    case "timerUp": timerUp = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "timerDown": timerDown = StringUtils.hexStringToInt(flashvars[key]); break;
                                      //
                    case "barBg": barBg = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "barBgAlpha": barBgAlpha = flashvars[key]; break;
                    case "barLoading": barLoading = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "barPlaying": barPlaying = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "barKnob": barKnob = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "barKnobOutline": barKnobOutline = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "barKnobOutlineAlpha": barKnobOutlineAlpha = flashvars[key]; break;
                                                //
                    case "playIcon": playIcon = StringUtils.hexStringToInt(flashvars[key]); break;
                    case "playIconAlpha": playIconAlpha = flashvars[key]; break;
                                          //
                    case "controlsPaddingLeft": controlsPaddingLeft = flashvars[key]; break;
                    case "controlsPaddingRight": controlsPaddingRight = flashvars[key]; break;
                    }
                }
            }
        }
    }
}
