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
	public static var MAX_AXIS:Number = 4;
	
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
	public function Joystick(idx) {
		if (ExternalInterface.available) {
			try {
				this.id = ExternalInterface.call("Joystick.register", (typeof idx == "number") ? idx : 0);
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
			var ext = ExternalInterface.call("Joystick.read", this.id, "x", "y", "a", "b");
			if (ext && ext.length >= 4) {
				this._x = Number( ext[0]) / (32768 / Joystick.MAX_AXIS) - Joystick.MAX_AXIS;
				this._y = Number( ext[1]) / (32768 / Joystick.MAX_AXIS) - Joystick.MAX_AXIS;
				this._a = Boolean(ext[2]);
				this._b = Boolean(ext[3]);
			}
		}
	}
	
	/**
	 * Fallback to read the joystick values from the keyboard (cursor keys for
	 * direction, SPACE for button 'a', and ENTER for button 'b').
	 */
	public function readKeys():Void {
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
}
