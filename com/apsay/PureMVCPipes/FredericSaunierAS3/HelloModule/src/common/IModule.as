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

	/**
	 * The interface that each Module must implement to be loaded
	 * and instanciated by the shell.
	 */
	public interface IModule {
		/**
		 * Ask the module to setup its PureMVC implementation.
		 *
		 * <P>
		 * It guarantees that PureMVC pipes setup will also be effective.
		 * </P>
		 */
		function setup() : void;

		/**
		 * Ask the module to teardown its PureMVC implementation.
		 *
		 * <P>
		 * It guarantees that PureMVC pipes teardown will also be effective.
		 * </P>
		 */
		function teardown() : void;

		/**
		 * Returns the unique ID of the module in this application.
		 */
		function getID() : String;
	}
}