package {
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	public class ReplaceStyle extends Sprite {
		// HTMLCSS
		public static const P_START : String = "<p>";
		public static const P_END : String = "</p>";
		public static const BR : String = "<br>";
		public static const SPAN_END : String = "</span>";
		public static const CLASS : String = "class";
		// HTMLCSS正则
		public static const R_SPAN_6 : RegExp = /{_SPAN_(.{6})_}/g;
		public static const R_SPAN_END : RegExp = /{_SPAN_END_}/g;
		public static const R_BR : RegExp = /{_BR_}/g;
		public static const INIT_CSS : String = "p{leading:2;text-align:center;}";
		private static const R_COLOR : RegExp = /{_COLOR_}/g;
		// 模板
		private static const T_CSS_SPAN : String = " .SPAN_{_COLOR_}{color:#{_COLOR_};} ";
		private static const T_HTML_SPAN : String = "<span class='SPAN_{_COLOR_}'>";

		public function ReplaceStyle() {
			var content : String = "{_SPAN_FFED89_}100万贝里、5万阅历、10点行动力{_SPAN_END_}{_BR_}{_SPAN_FF0000_}红色好感礼包*30，{_SPAN_END_}{_SPAN_fc00ff_}紫色好感礼包*10{_SPAN_END_}{_BR_}{_SPAN_00FF00_}称号：奥运形象大使{_SPAN_END_}";
			var regExps : Vector.<RegExp> = VectorUtilities.getFixedRegExp(new <RegExp>[R_BR, R_SPAN_END, R_SPAN_6]);
			var reps : Vector.<String> = VectorUtilities.getFixedString(new <String>[BR, SPAN_END, CLASS]);
			var repContent : Vector.<String>=replaceStyle(content, regExps, reps);
			createFieldHTMLText(220, 54, repContent, 0, 0, this, INIT_CSS);
		}

		/*替换HTML标签内容*/
		public static function replaceStyle(content : String, regExps : Vector.<RegExp>, reps : Vector.<String>) : Vector.<String> {
			var rep : String;
			var css : String = "";
			var color : String;
			var max : int = regExps.length - 1;
			for (var i : int = max; i > -1; i--) {
				content = content.replace(regExps[i], replFN);
				function replFN() : String {
					// 如替换内容为class，则执行提取色值，添加到CSS，把文本中相关地方替换成<span class='classname'>,classname为SPAN_加色值.

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
			return VectorUtilities.getFixedString(new <String>[content, css]);
		}

		/*创建HTMLText文本框*/
		public static function createFieldHTMLText(w : Number, h : Number, content : Vector.<String>, x : Number, y : Number, par : Sprite, initCSS : String = "", filter : Array = null) : TextField {
			var field : TextField = new TextField();
			field.filters = filter || [new GlowFilter(0x272727, 1, 2, 2, 10)];
			field.multiline = true;
			field.selectable = false;
			field.width = w;
			field.height = h;
			field.x = x;
			field.y = y;
			var css : String = initCSS + content[1];
			if (css) {
				var sheet : StyleSheet = new StyleSheet();
				sheet.parseCSS(css);
				field.styleSheet = sheet;
				field.htmlText = P_START + content[0] + P_END;
			} else {
				field.htmlText = content[0];
			}
			par.addChild(field);
			return field;
		}
	}
}
