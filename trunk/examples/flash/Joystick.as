import flash.external.*;

/**
 * Holds the data from a real joystick (or simulates one using keys).
 * Communication with the browser is via ExternalInterface. Any doubt that a
 * joystick isn't available (for example, one isn't connected or the plug-in
 * isn't installed) then a fallback to the keyboard occurs.
 */
class Joystick {
	/**
	 * Maximum value for the joystick's axes.
	 */
	public static var MAX_AXIS:Number = 8;
	
	/**
	 * Internal flag to denote that no joystick was found and values are taken
	 * from the keyboard fallback.
	 */
	private static var USE_KEYS:Number = Number.MIN_VALUE;
	
	/**
	 * ID by which the browser recognises this Flash wrapper.
	 */
	private var id;
	
	/**
	 * State of the joystick's x-axis (from -MAX_AXIS to MAX_AXIS).
	 */
	private var _x:Number;
	
	/**
	 * State of the joystick's y-axis (from -MAX_AXIS to MAX_AXIS).
	 */
	private var _y:Number;
	
	/**
	 * State of the joystick's designated 'a' button.
	 */
	private var _a:Boolean;
	
	/**
	 * State of the joystick's designated 'b' button.
	 */
	private var _b:Boolean;
	
	/**
	 * Creates the joystick wrapper.
	 * 
	 * @param idx joystick plug-in index on the browser side (defaults to zero)
	 */
	public function Joystick(idx:Number) {
		addBrowserScripts();
		if (ExternalInterface.available) {
			try {
				this.id = ExternalInterface.call("this._register_", idx);
			} catch (e) {
				this.id = Joystick.USE_KEYS;
			}
			if (this.id == null) {
				this.id = Joystick.USE_KEYS;
			}
		} else {
			this.id = Joystick.USE_KEYS;
		}
		/*
		 * The joysticks properties are shadowed and exposed via getters (effectively
		 * to make them read-only properties).
		 */
		this._x = 0;
		this._y = 0;
		this._a = false;
		this._b = false;
	}
	
	/**
	 * Exposes the joystick's x-axis property as read-only.
	 */
	public function get x():Number {
		return this._x;
	}
	
	/**
	 * Exposes the joystick's y-axis property as read-only.
	 */
	public function get y():Number {
		return this._y;
	}
	
	/**
	 * Exposes the joystick's 'a' button property as read-only.
	 */
	public function get a():Boolean {
		return this._a;
	}
	
	/**
	 * Exposes the joystick's 'b' button property as read-only.
	 */
	public function get b():Boolean {
		return this._b;
	}
	
	/**
	 * Polls the joystick plug-in (or reads the keys).
	 */
	public function poll():Void {
		if (this.id == Joystick.USE_KEYS) {
			this.readKeys();
		} else {
			this._x = this.readStick("x", true);
			this._y = this.readStick("y", true);
			this._a = Boolean(this.readStick("a", false));
			this._b = Boolean(this.readStick("b", false));
		}
	}
	
	/**
	 * Reads the named property from the browser plug-in.
	 */
	private function readStick(prop:String, axis:Boolean):Number {
		var res = ExternalInterface.call("this._read_", this.id, prop);
		if (typeof res == "number" && axis) {
			return res / (32768 / Joystick.MAX_AXIS) - Joystick.MAX_AXIS;
		}
		return Number(res);
	}
	
	/**
	 * Fallback to read the joystick values from the keyboard (cursor keys for
	 * direction, SPACE for button 'a', and ENTER for button 'b').
	 */
	private function readKeys():Void {
		if (Key.isDown(Key.LEFT)) {
			if (this._x > -Joystick.MAX_AXIS) {
				this._x -= 1;
			}
		} else {
			if (Key.isDown(Key.RIGHT)) {
				if (this._x < Joystick.MAX_AXIS) {
					this._x += 1;
				}
			} else {
				/*
				 * If neither left nor right is pressed start returning the x-axis to the
				 * centre (incrementing or decrementing per tick).
				 */
				if (this._x != 0) {
					if (this._x < 0) {
						this._x += 1;
					} else {
						this._x -= 1;
					}
				}
			}
		}
		
		if (Key.isDown(Key.UP)) {
			if (this._y > -Joystick.MAX_AXIS) {
				this._y -= 1;
			}
		} else {
			if (Key.isDown(Key.DOWN)) {
				if (this._y < Joystick.MAX_AXIS) {
					this._y += 1;
				}
			} else {
				/*
				 * As per the x-axis, start centering the y-axis if no key is pressed.
				 */
				if (this._y != 0) {
					if (this._y < 0) {
						this._y += 1;
					} else {
						this._y -= 1;
					}
				}
			}
		}
		
		this._a = Key.isDown(Key.SPACE);
		this._b = Key.isDown(Key.ENTER);
	}
	
	/**
	 * Returns a debug string.
	 */
	public function toString():String {
		return "joystick wrapper object";
	}
	
	//**************************** Browser Helpers *****************************/
	
	/**
	 * Flags if the helper scripts need adding to the browser.
	 */
	private static var needScripts:Boolean = true;
	
	/**
	 * Adds the scripts into the owning web page (and they're only added once).
	 */
	private static function addBrowserScripts():Void {
		if (ExternalInterface.available && needScripts) {
			/*
			 * See the Joystick.createPlugin in joystick.js for how this works.
			 */
			ExternalInterface.call("eval", "if (!this._createPlugin_) {this._createPlugin_ = function()\
{\
	var ctrlIE = document.createElement('object');\
	if (ctrlIE) {\
		try {\
			ctrlIE.classid = 'CLSID:3AE9ED90-4B59-47A0-873B-7B71554B3C3E';\
			if (ctrlIE.setDevice(0) != null) {\
				return ctrlIE;\
			}\
		} catch (e) {}\
	}\
	var ctrlFF = document.createElement('embed');\
	if (ctrlFF) {\
		if (navigator && navigator.plugins) {\
			var found = false;\
			for (var n = 0; n < navigator.plugins.length; n++) {\
				if (navigator.plugins[n].name.indexOf('Joystick') != -1) {\
					found = true;\
					break;\
				}\
			}\
			if (!found) {\
				return null;\
			}\
		}\
		try {\
			ctrlFF.type = 'application/x-vnd.numfum-joystick';\
			ctrlFF.width  = 0;\
			ctrlFF.height = 0;\
			document.body.appendChild(ctrlFF, document.body);\
			if (ctrlFF.setDevice(0) != null) {\
				return ctrlFF;\
			}\
		} catch (e) {}\
		document.body.removeChild(ctrlFF);\
	}\
	return null;\
}}");
			/*
			 * See the Joystick.register in joystick.js for how this works.
			 */
			ExternalInterface.call("eval", "if (!this._register_) {this._register_ = function(idx)\
{\
	if (!this._registered_) {\
		 this._registered_ = [];\
	}\
	idx = Number(idx);\
	if (idx < 0) {\
		var stick = this._createPlugin_();\
		if (stick) {\
			return this._registered_[stick] - 1;\
		}\
	} else {\
		if (this._registered_[idx]) {\
			return idx;\
		}\
		var stick = this._createPlugin_();\
		if (stick) {\
			this._registered_[idx] = stick;\
			return idx;\
		}\
	}\
	return -1;\
}}");
			ExternalInterface.call("eval", "if (!this._read_) {this._read_ = function(idx, prop)\
{\
	if (!this._registered_) {\
		return null;\
	}\
	var stick = this._registered_[Number(idx)];\
	if (stick) {\
		switch (prop) {\
		case 'x':\
			return stick.x;\
		case 'y':\
			return stick.y;\
		case 'a':\
			return stick.a;\
		case 'b':\
			return stick.b;\
		default:\
			return 0;\
		}\
	}\
	return undefined;\
}}");
		}
		needScripts = false;
	}
}
