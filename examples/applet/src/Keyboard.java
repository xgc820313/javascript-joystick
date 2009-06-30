import java.awt.*;
import java.awt.event.*;

/**
 *	Example keyboard class as a fallback for when no joystick is connected.
 *
 *	@param applet the calling applet
 */
public class Keyboard implements Controller, KeyListener {
	private boolean up = false;
	private boolean down = false;
	private boolean left = false;
	private boolean right = false;
	
	public Keyboard(Container container) {
		container.addKeyListener(this);
	}
	
	public void poll() {}
	
	public void keyPressed(KeyEvent e) {
		this.check(e.getKeyCode(), true);
	}
	
	public void keyReleased(KeyEvent e) {
		this.check(e.getKeyCode(), false);
	}
	
	public void keyTyped(KeyEvent e) {}
	
	private void check(int keyCode, boolean status) {
		switch (keyCode) {
		case KeyEvent.VK_UP:
			this.up = status;
			break;
		case KeyEvent.VK_DOWN:
			this.down = status;
			break;
		case KeyEvent.VK_LEFT:
			this.left = status;
			break;
		case KeyEvent.VK_RIGHT:
			this.right = status;
			break;
		}
	}
	
	public int getX() {
		int x = CENTRE;
		
		if (this.left) {
			x = 0;
		} else {
			if (this.right) {
				x = 65535;
			}
		}
		
		return 	x;
	}
	
	public int getY() {
		int y = CENTRE;
		
		if (this.up) {
			y = 0;
		} else {
			if (this.down) {
				y = 65535;
			}
		}
		
		return 	y;
	}
	
	public int getButtons() {
		return 0;
	}
}
