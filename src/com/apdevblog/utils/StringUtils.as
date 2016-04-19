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
package com.apdevblog.utils
{
    /**
     * Class with little helpers for working w/ Strings.
     *
     * @playerversion Flash 9
     * @langversion 3.0
     *
     * @package    com.apdevblog.utils
     * @author     Philipp Kyeck / phil[at]apdevblog.com
     * @copyright  2009 apdevblog.com
     * @version    SVN: $Id: StringUtils.as 7 2009-10-13 16:46:31Z p.kyeck $
     */
    public class StringUtils
    {
        public static var LEFT:Number = 1 << 1;
        public static var RIGHT:Number = 1 << 2;

        /**
         * converts hexadecimal string to int.
         *
         * @param hex	hexadecimal String (w/ or w/o #)
         *
         * @return		corresponding int value
         */
        public static function hexStringToInt(hex:String):int
        {
            hex = replace(hex, "#", "");
            return parseInt("0x" + hex.substr(0,6));
        }

        /**
         * dumps Object to String.
         *
         * @param obj	Object to be dumped
         */
        public static function objectToString(obj:Object):String
        {
            var s:String = "";
            var looped:Boolean = false;
            s += "{";

            for(var p:* in obj)
            {
                if (!looped) looped = true;
                if (obj[p] is Array)  s += p+": ["+obj[p]+"], ";
                else if (obj[p] is Object) s += StringUtils.objectToString(obj[p])+", ";
                else if (obj[p] is Function) s += p+": (function), ";
                else s += p+": "+obj[p]+", ";
            }

            if (looped) return s.slice(0,-2)+"}";
            return s+"}";
        }

        /**
         * Resize a given string to a greater length and fill it up with a custom
         * character.
         *
         * @usage   StringUtils.padString("4", 3, "0", StringUtils.LEFT); // "004"
         *
         * @param   val           The value that will be modified
         * @param   strLength     The length of the new string
         * @param   padChar       The string will be padded with this character
         * @param  padDirection  Where will the characters be added?
         * @return
         */
        public static function padString(val:String, strLength:Number, padChar:String, padDirection:Number=NaN):String
        {
            if(isNaN(padDirection))
            {
                padDirection = StringUtils.LEFT;
            }
            // If the input value is already as long as the result should be, return
            // the unchanged input value.
            // Also do nothing if padChar is not a single character.
            if(val.length >= strLength || padChar.length != 1)
            {
                return val;
            }
            var fill:String = "";
            for(var i:Number = 0;i < strLength - val.length; i++)
            {
                fill += padChar;
            }
            var out:String = padDirection == StringUtils.LEFT ? (fill + val) : (val + fill);
            return out;
        }

        /**
         * capitalizes first character of String.
         *
         * @param haystack	String to search in
         * @param needle	String that we are looking for
         * @param replace	If needle is found replace is with this String
         */
        public static function replace(haystack:String, needle:String, replace:String):String
        {
            return haystack.split(needle).join(replace);
        }

        /**
         * removes blanks at the beginning and end of a string.
         *
         * @param str	String to be trimmed
         */
        public static function trim(str:String=null):String
        {
            if (str == null) return "";
            str = String(str);
            while (str.charAt(0) == " ") str = str.substring(1);
            while (str.charAt(str.length - 1) == " ") str = str.substring(0, str.length - 1);
            return str;
        }

        /**
         * capitalizes first character of String.
         *
         * @param str	String to edit
         */
        public static function toTitleCase(str:String):String
        {
            return str.substr(0, 1).toUpperCase() + str.substr(1).toLowerCase();
        }

        /**
         * capitalizes first character of every word in String.
         *
         * @param str	String to edit
         */
        public static function ucWords(str:String):String
        {
            var newStr:String = "";
            var chunks:Array = str.split(" ");

            for(var i:int = 0; i<chunks.length; i++)
            {
                newStr += StringUtils.toTitleCase(chunks[i]);
                if(i < chunks.length-1) newStr += " ";
            }

            return newStr;
        }
    }
}