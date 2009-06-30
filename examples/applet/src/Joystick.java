import java.applet.Applet;

import netscape.javascript.JSException;
import netscape.javascript.JSObject;

/**
 * Enables Java to read joystick values via JavaScript using LiveConnect.
 */
public class Joystick implements Controller {
	/**
	 * The JavaScript object that wraps around the joystick 'plug-in'.
	 */
	JSObject player = null;
	
	/**
	 *	Creates a joystick instance in the applet's containing page.
	 *
	 *	@param applet the calling applet
	 */
	public Joystick(Applet applet) {
		player = createPluginInstance(applet);
	}
	
	public void poll() {
		try {
			player.call("poll", null);
		} catch (Exception e) {}
	}
	
	/**
	 *	Reads the joystick's x axis.
	 *
	 *	@return a value between 0 and 65535.
	 */
	public int getX() {
		int x = CENTRE;
		try {
			x = ((Number) player.getMember("x")).intValue();
		} catch (Exception e) {}
		return 	x;
	}
	
	/**
	 *	Reads the joystick's y axis.
	 *
	 *	@return a value between 0 and 65535.
	 */
	public int getY() {
		int y = CENTRE;
		try {
			y = ((Number) player.getMember("y")).intValue();
		} catch (Exception e) {}
		return 	y;
	}
	
	/**
	 *	Reads the state of all the joystick's buttons.
	 *
	 *	@return the buttons represented as bits in an integer
	 */
	public int getButtons() {
		int buttons = 0;
		try {
			buttons = ((Number) player.getMember("buttons")).intValue();
		} catch (Exception e) {}
		return buttons;
	}
	
	public static JSObject createPluginInstance(Applet applet) {
		JSObject win = null;
		try {
			win = (JSObject) JSObject.getWindow(applet);
		} catch (JSException e) {}
		return createPluginInstance(win);
	}
	
	/**
	 * Creates an instance of the plug-in object in the browser.
	 * 
	 * @param win browser's window object
	 * @return plug-in instance or {@code null} if one cannot be created
	 */
	public static JSObject createPluginInstance(JSObject win) {
		if (win == null) {
			/*
			 * Early exit, since not all browsers support the LiveConnect API.
			 */
			return null;
		}
		
		JSObject obj = (JSObject) win.eval("document.createElement('object')");
		try {
			obj.setMember("classid", "CLSID:3AE9ED90-4B59-47A0-873B-7B71554B3C3E");
			if (obj.call("setDevice", new Object[] {new Integer(0)}) != null) {
				/*
				 * IE always returns a Boolean for this call, so any non-null
				 * value is success at this point/
				 */
				return obj;
			}
		} catch (JSException e) {
			/*
			 * Either we're not using IE or the plug-in is not installed,
			 * so ignore any exceptions and try the next method.
			 */
		}
		
		obj = (JSObject) win.eval("document.createElement('embed')");
		if (obj != null) {
			JSObject doc = (JSObject) win.eval("document.body");
			try {
				obj.setMember("type", "application/x-vnd.numfum-joystick");
				obj.setMember("width",  0);
				obj.setMember("height", 0);
				/*
				 * Before accessing the plug-in's script interface it needs to
				 * be added to the page. If the 'setDevice' call fails, the
				 * plug-in is assumed to either not be installed or not working
				 * in this browser, in which case it is removed in the catch.
				 */
				doc.call("appendChild", new Object[] {obj, doc});
				if (obj.call("setDevice", new Object[] {new Double(0)}) != null) {
					/*
					 * As with the code for IE, any non-null value is a
					 * success. Note that doubles are passed for the index due
					 * to workarounds for Firefox and Safari (internal to the
					 * plug-in.
					 */
					return obj;
				}
			} catch (JSException e) {
				if (obj != null) {
					doc.call("removeChild", new Object[] {obj});
				}
			}
		}
		
		return null;
	}
}
