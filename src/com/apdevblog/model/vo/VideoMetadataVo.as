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
package com.apdevblog.model.vo  
{

    /**
     * ValueObject saving video metadata.
     * 
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.model.vo  
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: VideoMetadataVo.as 2 2009-09-02 11:03:20Z p.kyeck $
     */
    public class VideoMetadataVo 
    {
        public var duration:Number;
        public var width:Number;
        public var height:Number;
        public var keyframes:Object;
        public var isH264:Boolean;

        /**
         * 
         */
        public function VideoMetadataVo(data:Object=null)
        {		
            if(data != null)
            {
                width = data["width"];
                height = data["height"];
                duration = data["duration"];

                if(data["keyframes"] != null)
                {
                    isH264 = false;
                    keyframes = data["keyframes"];
                }
                else if(data["seekpoints"] != null)
                {
                    isH264 = true;
                    keyframes = new Object();
                    keyframes["times"] = new Array();
                    keyframes["filepositions"] = new Array();

                    for(var i:String in data["seekpoints"]) 
                    {
                        keyframes["times"][i] = data["seekpoints"][i]["time"] as Number;
                        keyframes["filepositions"][i] = data["seekpoints"][i]["offset"] as Number;
                    }
                }
                else
                {			
                    keyframes = null;
                }
            }
        }
    }
}
