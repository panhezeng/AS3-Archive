/*
 PureMVC AS3 MultiCore Pipes Demo – Flash Modules and Pipes Demo
 Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>

 Parts originally from:
 
 PureMVC AS3 MultiCore Demo – Flex PipeWorks
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>

 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package common {
	public class PipeNames {
		/**
		 * Standard output pipe name constant.
		 */
		public static const STDOUT : String = 'standardOutput';
		/**
		 * Standard input pipe name constant.
		 */
		public static const STDIN : String = 'standardInput';
		/**
		 * Standard Shell input pipe name constant.
		 */
		public static const ANY_MODULE_TO_SHELL : String = 'anyModuleToShell';
		/**
		 * HelloModule to HelloModule output pipe name constant.
		 */
		public static const HELLO_OUT_TO_HELLO : String = 'helloToHelloOut';
	}
}