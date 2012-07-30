package com.raytoon.cannonfodder.tools.net {
	import com.hurlant.crypto.symmetric.AESKey;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIName;
	import com.raytoon.cannonfodder.tools.utils.UIState;
	import com.raytoon.cannonfodder.tools.utils.UIXML;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class ClientSocket extends Socket {
		protected static var instance : ClientSocket;
		protected const SINGLETON_MSG : String = "socket单例请用getInstance获得!";
		private var _host : String;
		private var _port : int;
		private var _dataEventCount : uint = 0;
		private var _realDataCount : uint = 0;
		private var _readDataLen : Boolean = true;
		private var _dataLenByte : ByteArray = new ByteArray();
		private var _dataContentLen : uint = 0;
		private var _readDataContent : Boolean = false;
		private var _dataContentByte : ByteArray = new ByteArray();
		private var _resultsData : String = "";
		private var _flushDataType : Array = [];
		private var _aes : AESKey;

		public function ClientSocket() {
			if (instance == null) {
				_host = ConstPath.DATA_SERVER_URL;
				_port = ConstPath.DATA_SERVER_PORT;
				configureListeners();
				logger("Connecting to socket server on " + _host + ":" + _port);
			} else {
				throw Error(SINGLETON_MSG);
			}
		}

		public static function getInstance() : ClientSocket {
			if (instance == null) {
				instance = new ClientSocket();
			}
			return instance;
		}

		private function configureListeners() : void {
			var _key : ByteArray = new ByteArray();
			_key.writeUTFBytes("sdfgsdfgsdgfdsfg");
			_aes = new AESKey(_key);
			// this.objectEncoding = ObjectEncoding.AMF3;
			// Security.loadPolicyFile("xmlsocket://" + _host + ":" + _port);
			this.connect(_host, _port);
			this.addEventListener(Event.CLOSE, _socketHandler);
			this.addEventListener(Event.CONNECT, _socketHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR, _socketHandler);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _socketHandler);
			this.addEventListener(ProgressEvent.SOCKET_DATA, _socketHandler);
		}

		public function writeSend(params : String, dataType : String) : void {
			var bytes : ByteArray = new ByteArray();
			try {
				// bytes.writeObject(params);
				bytes.writeUTFBytes(params);
				bytes.compress();
				//_aes.encrypt(bytes);
				this.writeUnsignedInt(bytes.length);
				this.writeBytes(bytes);
			} catch (e : IOError) {
				switch (e.errorID) {
					case 2002 :
						// reconnect when connection timed out
						if (!this.connected) {
							this.connect(_host, _port);
							logger("Reconnecting...");
						}
						break;
					default :
						logger(e.toString());
						break;
				}
			}

			flush();
			_flushDataType.push(dataType);
			// logger(_flushAry[_flushAry.length - 1]);
		}

		private function _socketHandler(event : Event) : void {
			switch (event.type) {
				case Event.CLOSE :
					dispatchEvent(new ClientSocketEvent(ClientSocketEvent.DISCONNECTED));
					logger("连接关闭.\n");
					break;
				case Event.CONNECT :
					dispatchEvent(new ClientSocketEvent(ClientSocketEvent.CONNECTED));
					logger("已连接.\n");
					break;
				case IOErrorEvent.IO_ERROR :
					logger("IOErrorEvent.IO_ERROR.\n");
					try {
						if (UICommand.t.stage.getChildAt(UICommand.t.stage.numChildren - 1).name.indexOf(UIClass.POPUP_PROMPT + UIState.SOCKET) == -1) UICreate.popupPrompt(String(UIXML.uiXML.socketDisconnect[0]), UIState.SOCKET);
					} catch (error : Error) {
						if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 0);
						trace(error.toString() + "socket");
					}
					break;
				case SecurityErrorEvent.SECURITY_ERROR :
					logger("连接失败.\n");
					try {
						if (UICommand.t.stage.getChildAt(UICommand.t.stage.numChildren - 1).name.indexOf(UIClass.POPUP_PROMPT + UIState.SOCKET) == -1) UICreate.popupPrompt(String(UIXML.uiXML.socketDisconnect[0]), UIState.SOCKET);
					} catch (error : Error) {
						if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 0);
						trace(error.toString() + "socket");
					}
					break;
				case ProgressEvent.SOCKET_DATA :
					// _dataEventCount++;
					// trace(_dataEventCount);
					_readData();
					break;
			}
		}

		private function _readData() : void {
			if (_readDataLen) {
				// trace("_readDataLen:"+this.bytesAvailable);
				while (!(_dataLenByte.length == 4)) {
					this.readBytes(_dataLenByte, _dataLenByte.length, 1);
				}
				if (_dataLenByte.length == 4) {
					_dataContentLen = _dataLenByte.readUnsignedInt();
					// trace(_dataContentLen);
					_dataLenByte.clear();
					_readDataLen = false;
					_readDataContent = true;
					if (this.bytesAvailable == 0) return;
				}
			}
			if (_readDataContent) {
				// trace("_readDataContent:"+this.bytesAvailable);
				if (this.bytesAvailable != 0) {
					if (this.bytesAvailable < _dataContentLen) {
						this.readBytes(_dataContentByte, _dataContentByte.length, this.bytesAvailable);
					} else {
						this.readBytes(_dataContentByte, _dataContentByte.length, _dataContentLen);
					}
					if (_dataContentByte.length == _dataContentLen) {
						_parseDataReceived(_dataContentByte);
						_readDataLen = true;
						_readDataContent = false;
					}
					if (this.bytesAvailable > 0) {
						_readData();
					}
				}
			}
		}

		private function _parseDataReceived(bytes : ByteArray) : void {
			try {
				//_aes.decrypt(bytes);
				bytes.uncompress();
			} catch (error : Error) {
				logger("解压缩数据失败");
				if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 2);
				return;
			}
			bytes.position = 0;
			_resultsData = bytes.readUTFBytes(bytes.length);
			bytes.clear();
			// _realDataCount++;
			// trace("\n:" + _realDataCount);
			// trace(_resultsData + ";\n");
			if (_flushDataType.length) {
				/*客户端给服务器端发数据后的回应数据*/
				switch (_flushDataType[0]) {
					case ClientSocketEvent.XML_DATA_OK :
						dispatchEvent(new ClientSocketEvent(ClientSocketEvent.XML_DATA_OK, _resultsData));
						// logger("XML_DATA_OK.\n");
						break;
					case ClientSocketEvent.JSON_DATA_OK:
						dispatchEvent(new ClientSocketEvent(ClientSocketEvent.JSON_DATA_OK, _resultsData));
						break;
				}
				_flushDataType.shift();
			} else {
				/*服务器端直接给客户端发数据(客户端没有事先请求)*/
			}
		}

		private function logger(msg : String) : void {
			trace(msg + '\n');
		}

		public function get host() : String {
			return _host;
		}

		public function get port() : uint {
			return _port;
		}
	}
}