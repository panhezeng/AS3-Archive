package utils {
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * @author Panhezeng
	 */
	public class TextStyle {
		// 常用字符
		public static const CHAR_COMMA : String = ",";
		public static const CHAR_AND : String = "&";
		public static const CHAR_UNDERLINE : String = "_";
		public static const CHAR_ELLIPSIS : String = "…";
		public static const CHAR_SlASH : String = "/";
		public static const CHAR_VERTICAL_BARS : String = "|";
		public static const CHAR_COMMA_CN : String = "，";
		public static const CHAR_BREAK : String = "\n";
		public static const CHAR_RETURN_WRAP : String = "\r\n";
		// 常用字符正则
		// public static const R_CN_MARK : RegExp = /[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b]/g;
		public static const R_CN_COMMA_DUN : RegExp = /[\uff0c\u3001]/g;
		// HTMLCSS
		public static const P_START : String = "<p>";
		public static const P_END : String = "</p>";
		public static const BR : String = "<br>";
		public static const SPAN_END : String = "</span>";
		public static const CLASS : String = "class";
		public static const FONT_RED_START : String = "<font color='#FF0000'>";
		public static const FONT_END : String = "</font>";
		public static const LINK_NAME_U : String = "<a href='event:{_DATA_}'><font color='#{_COLOR_}'><u>{_NAME_}</u></font></a>";
		public static const LINK_NAME : String = "<a href='event:{_DATA_}'><font color='#{_COLOR_}'>{_NAME_}</font></a>";
		public static const SPAN_HIDE : String = "<span class='hide'>";
		// CSS
		public static const INIT_CSS : String = "p{leading:2;}";
		public static const LINK_CSS : String = "a:hover{color:#FF0000;} a:visited{color:#990000;} a:active{color:#000000;} .hide{display:none;}";
		// HTMLCSS正则
		public static const R_SPAN_6 : RegExp = /{_SPAN_(.{6})_}/g;
		public static const R_SPAN_END : RegExp = /{_SPAN_END_}/g;
		public static const R_BR : RegExp = /{_BR_}/g;
		public static const R_COLOR : RegExp = /{_COLOR_}/g;
		public static const R_DATA : RegExp = /{_DATA_}/g;
		public static const R_NAME : RegExp = /{_NAME_}/g;
		// 模板
		public static const T_CSS_SPAN : String = " .SPAN_{_COLOR_}{color:#{_COLOR_};} ";
		public static const T_HTML_SPAN : String = "<span class='SPAN_{_COLOR_}'>";

		/**
		 * 根据XML模板标签改变文本样式
		 * @param content 要替换文本
		 * @param regExps 匹配规则，正则数组
		 * @param reps 符合匹配正则的替换内容数组，和上个参数一一对应
		 * @return 字符串数组，0是替换后的文本，1是此文本需要的css（不是一定有）
		 */
		public static function replaceStyle(content : String, regExps : Vector.<RegExp>, reps : Vector.<String>) : Vector.<String> {
			var rep : String;
			var css : String = "";
			var color : String;
			var max : int = regExps.length - 1;
			// 遍历正则数组
			for (var i : int = max; i > -1; i--) {
				// 替换匹配此正则的文本
				content = content.replace(regExps[i], replFN);
				function replFN() : String {
					/*
					 * 如替换内容为class，则执行提取色值，添加到CSS，把文本中相关地方替换成<span class='classname'>,classname为SPAN_加色值.
					 * 否则直接返回对应的替换内容数组
					 */
					if (reps[i] == CLASS) {
						color = arguments[1];
						// 如css中已经有此类名样式就跳过
						if (css.indexOf(color) == -1) css += T_CSS_SPAN.replace(R_COLOR, color);
						rep = T_HTML_SPAN.replace(R_COLOR, color);
					} else {
						rep = reps[i];
					}
					return rep;
				}
			}
			return VectorUtilities.getFixedString([content, css]);
		}

		/**
		 * 创建HTMLText文本框
		 * @param txtAndCSS new <String>[文本内容,CSS]
		 * @return 添加好内容的文本框
		 */
		public static function createFieldHTMLText(txtAndCSS : Vector.<String>, w : Number = 0, h : Number = 0, x : Number = 0, y : Number = 0, initCSS : String = "", filter : Array = null, par : DisplayObjectContainer = null) : TextField {
			var field : TextField = new TextField();
			// 如有希望添加到的容器，则把生成的文本框添加到此容器
			if (par) par.addChild(field);
			field.x = x;
			field.y = y;
			field.filters = filter || [new GlowFilter(0x272727, 1, 2, 2, 10)];
			field.multiline = true;
			field.wordWrap = true;
			field.selectable = false;
			field.mouseWheelEnabled = false;
			var css : String = initCSS;
			// 如有该文本特别需要的css，则并入初始默认css
			if (txtAndCSS[1]) css += txtAndCSS[1];
			/*
			 * 如有css，则添加css
			 * 否则直接添加文本内容
			 */
			if (css) {
				var sheet : StyleSheet = new StyleSheet();
				sheet.parseCSS(css);
				field.styleSheet = sheet;
				field.htmlText = P_START + txtAndCSS[0] + P_END;
			} else {
				field.htmlText = txtAndCSS[0];
			}
			/*
			 * 如有需要的高度，则用需要的高度
			 * 否则用实际文本高度
			 */
			if (w) {
				field.width = w;
			} else {
				field.width = field.textWidth + 4;
			}
			/*
			 * 如有需要的高度，则用需要的高度（设置了固定高度则不能换行）
			 * 否则用实际文本高度
			 */
			if (h) {
				field.height = h;
			} else {
				field.height = field.textHeight + 4;
			}
			return field;
		}

		/**
		 * 格式化时间，格式化为类似00:00:00文本
		 * @param now 当前时间
		 * @param end 截止时间
		 * @param start 开始时间
		 * @param hideHour 是否隐藏小时文本
		 * @param replaceZero 当倒计时为0时的替换文本
		 */
		public static function formatTime(now : Number, end : Number = NaN, start : Number = NaN, hideHour : Boolean = false, replaceZero : String = "") : String {
			var hTXT : String = "";
			var minTXT : String = "";
			var secTXT : String = "";
			var timeTXT : String = "";
			var h : Number;
			var min : Number;
			var sec : Number;
			var time : Number = now;
			// 如有截止时间，则time为当前时间减去截止时间的剩余时间，即为倒计时模式
			if (end || end == 0) time = Number(end - now);
			/*
			 * 如当前时间小于或等于0，格式文本都为0；倒计时模式下，剩余时间小于或等于0，即倒计时结束或者当前时间小于开始时间，即还没开始，则分和秒为0；
			 * 否则计算并显示格式化时间文本
			 */
			if (time <= 0 || ((start || start == 0) && now < start)) {
				h = 0;
				min = 0;
				sec = 0;
				// 如有替代都为零的文本
				if (replaceZero) timeTXT = replaceZero;
			} else {
				/*
				 * 如正常计时模式则用Date的getHours，因UTC时间trace(new Date(time).getUTCHours());差8小时,
				 * 否则倒计时模式用UTC毫秒数换算的小时数
				 */
				if (time == now) {
					h = new Date(time).getHours();
				} else {
					// h = int((time / 3600000) % 24);
					h = int(time / 3600000);
				}
				min = int((time / 60000) % 60);
				sec = int((time / 1000) % 60);
			}
			// 如返回文本已有值，说明都为零并且有替代文本，则不进入，直接返回替代文本
			if (!timeTXT) {
				// 如隐藏小时显示则赋值 h = NaN
				if (hideHour) h = NaN;
				// 如h不为NaN，则显示小时文本，如h不满两位，则补0
				if (h || h == 0) hTXT = h > 9 ? String(h) + " : " : "0" + h + " : ";
				// 如min不为NaN，则显示分文本，如min不满两位，则补0
				if (min || min == 0) minTXT = min > 9 ? String(min) + " : " : "0" + min + " : ";
				// 如sec不为NaN，则显示秒文本，如sec不满两位，则补0
				if (sec || sec == 0) secTXT = sec > 9 ? String(sec) : "0" + sec;
				timeTXT = hTXT + minTXT + secTXT;
			}
			return timeTXT;
		}

		/**
		 * Number类型的浮点小数为超级长，此方法可以获得指定小数位的小数文本用来显示
		 * @param num 浮点小数
		 * @param places 小数位
		 */
		public static function getfiniteDecimals(num : Number, places : int) : String {
			var ary : Array = String(num).split(".");
			return  ary[0] + "." + String(ary[1]).substr(0, places);
		}
	}
}
