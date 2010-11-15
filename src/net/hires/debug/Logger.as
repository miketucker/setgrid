/**
 * Hi-ReS! Logger
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php 
 * 
 * How to use:
 * 
 * 	addChild(new Logger());
 * 
 *	Logger.info("Info message");
 * 	Logger.debug("Debug message, result >", 1+2+3);
 * 	Logger.warning("This is just a warning!");
 * 	Logger.error("Ok, something crashed");
 * 	
 * 	//	or ...
 * 	
 * 	var customLogger:Logger = new Logger(1,"Custom Logger",false);
 *	addChild(customLogger);
 * 	customLogger.info("Info Message");
 * 
 * version log:
 *  09.07.23	1.6	Theo		+ Added getXMLDump() returning the FULL log as XML (the visible log being just a fragment)
 *  				Mr.doob		  Removed getLog (depreciated) 
 *  							+ Removed the global/monitor properties (not used, can be solved by inheritance)
 *  							  Now using master, getMaster to access the "static" Logger
 *  							+ Removed stack (this is now stored in XML)
 *  				
 *  09.02.04	1.5	Mr.doob		+ Included stringPadNumber as a method (no more dependencies)
 *					Theo		+ CDATA for message
 *								+ XML used for logging
 *								+ CSS applied to XML show colors
 *								+ Replaced level names by colors in the display
 *								+ added getLog() method
 *								+ Added maxMessages field
 *								+ The class now extends TextField
 *								+ Added DEFAULT_NAME and name argument for the constructor
 *								+ Comments / Todos to be checked ...
 *	08.11.21	1.4	Theo		+ fix : the specified output level wasn't considered
 *								+ enh : stripping the comas from arrays in the log method to 
 *								  make the log clearer.
 *	08.11.12	1.3	Mr.doob		+ Instance mode
 *					Theo		+ Info level added
 *								+ Stack
 *	08.11.04	1.2	Mr.doob		+ Introduced debug, warning and error methods
 *								+ added visible getter/setter
 *	08.11.02	1.1	Mr.doob		+ Changed the LEVEL handling
 *								+ Slightly refactored
 * 	07.10.12	1.0	Mr.doob		+ First version 
 **/
 
package net.hires.debug 
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;	

	public class Logger extends TextField 
	{	

		
		private static const DEFAULT_NAME:String = "Hi-ReS! Logger";

		public static const LEVEL_INFO:int = 0;
		public static const LEVEL_DEBUG:int = 1;
		public static const LEVEL_WARNING:int = 2;
		public static const LEVEL_ERROR:int = 3;
		public static const LEVEL_SILENT:int = 4;

		/**
		 * The names of the log XML Nodes 
		 * NOTE : Could this be an associative array with levels/names/colors ?
		 */
		private static const _LEVEL_NAMES:Array = ['info','debug','warning','error'];
		private var _LEVEL_COLOURS:Array = ['#ffffff','#99E1FF','#00CC33','#FF3300','#FF0000'];

		/**
		 * The level below which the messages wouldn't be logged.
		 */
		public var level:int;

		/**
		 * Maximum number of messages to store simultaneously.
		 */
		private var maxMessages:int;

		/**
		 * XML containing the log messages
		 */
		private var xmlLog:XML;
		private var xmlFullLog:XML;

		private static var master:Logger;

		
		/**
		 * @param level			int			The level below which the messages wouldn't be logged
		 * @param name			String		An id for the logger, if not specified the DEFAULT_NAME will be used
		 * @param isMaster		Boolean		Indicates whether the logger should be notified by messages
		 * 									coming from the main 'static' Logger
		 * @param maxMessages	int			Maximum number of messages to store simultaneously.
		 * 									Set to zero to keep ALL the messages.
		 */
		public function Logger(level:int = 1, name:String = DEFAULT_NAME, isMaster:Boolean = true, maxMessages:int = 50) 
		{
			this.name = name;
			this.level = level;
			this.maxMessages = maxMessages;
			
			if(isMaster)
				master = this;
			
			initDisplay();
			clear();
		}
		
		public function set colors(array:Array):void{
			_LEVEL_COLOURS = array;
			initDisplay();
		}
		
		
		/**
		 * Initializes the display
		 */
		protected function initDisplay():void 
		{
			autoSize = "left";
			
			// TODO : 	- Check colors (maybe white/grey for info? to make it bit less rainbowy)
			// 			- Default system 'monospace' doesn't seem to work 

			var style:StyleSheet = new StyleSheet();
			
			style.setStyle("log", {color:_LEVEL_COLOURS[0], fontSize:"9px", leading:"-5px", fontFamily:"Monaco, Courier, monospace", wordWrap:"true"});
			style.setStyle("info", {color:_LEVEL_COLOURS[1]});
			style.setStyle("debug", {color:_LEVEL_COLOURS[2]});
			style.setStyle("warning", {color:_LEVEL_COLOURS[3], textWeight:"bold"});
			style.setStyle("error", {color:_LEVEL_COLOURS[4]});
			
			styleSheet = style;
		}

		
		// .. STATICS 

		
		public static function info( ...msg:* ):void 
		{
			getMaster().log(msg, LEVEL_INFO);
		}

		
		public static function debug( ...msg:* ):void 
		{
			getMaster().log(msg, LEVEL_DEBUG);
		}

		
		public static function warning( ...msg:* ):void 
		{
			getMaster().log(msg, LEVEL_WARNING);
		}

		
		public static function error( ...msg:* ):void 
		{
			getMaster().log(msg, LEVEL_ERROR);
		}

		
		public static function clear():void 
		{
			getMaster().clear();
		}

		
		public function getXMLDump():String
		{
			return xmlFullLog;
		}

		
		public static function getMaster():Logger
		{
			if(master == null)
				master = new Logger();
				
			return master;
		}

		
		// .. INSTANCE METHODS

		public function info( ...msg:* ):void 
		{
			log(msg, LEVEL_INFO);
		}

		
		public function debug( ...msg:* ):void 
		{
			log(msg, LEVEL_DEBUG);
		}

		
		public function warning( ...msg:* ):void 
		{
			log(msg, LEVEL_WARNING);
		}

		
		public function error( ...msg:* ):void 
		{
			log(msg, LEVEL_ERROR);
		}		

		
		protected function log( msg:*, level:int = 0 ):void 
		{
		
			// If the message is an array, tidies up the comas
			if(msg is Array)
				msg = (msg as Array).join(" ");		
			
			// Adds the time / message formatting
			msg = getTimestamp(new Date()) + " :: " + msg;
			
			// Creates the XML node to add to the log
			var node:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, _LEVEL_NAMES[level]);
			var cdata:XMLNode = new XMLNode(XMLNodeType.CDATA_NODE, msg);
			node.appendChild(cdata);
			
			xmlFullLog.prependChild(node);
			
			// Skips dumping
			// Note: the filtering could now be done via e4x at the display ...
			if (level < this.level)
				return;
			
			// Adds the message to the top of the list
			xmlLog.prependChild(node);
			
			
			// Removes the last message if the list is bigger than the limit.
			if(xmlLog.children().length() > maxMessages && maxMessages > 0)
				delete xmlLog.children()[maxMessages];
			
			// Updates finally!
			htmlText = xmlLog;
		}

		
		
		/**
		 * Resets the log data and clears the view
		 * 
		 * NOTE : Maybe "reset" is more apropriate now as the log is now
		 * not only related to the console view but also stores data?
		 */
		public function clear():void 
		{
			// Creates the base node for the log
			//
			// TODO : Could be nice to have some atttributes with system infos etc.
			// in case the log is saved...

			xmlLog = new XML("<log />");
			xmlFullLog = new XML("<log />");
			
			xmlLog.info = getTimestamp(new Date()) + " :: " + name + " > " + _LEVEL_NAMES[level] + " mode.";
			xmlFullLog.info = xmlLog.info;
			
			htmlText = xmlLog;
		}

		
		
		// .. UTILS 

		private static function getTimestamp(d:Date):String 
		{
			return "[" + stringPadNumber(d.hours, 2) + ":" + stringPadNumber(d.minutes, 2) + ":" + stringPadNumber(d.seconds, 2) + "::" + stringPadNumber(d.milliseconds, 3) + "]";
		}

		
		private static function stringPadNumber( num:Number, padding:Number ):String
		{
			var stringNum:String = String(num);

			while(stringNum.length < padding)
				stringNum = "0" + stringNum;
			
			return stringNum;
		}
	}
}