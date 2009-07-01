import java.awt.Container;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

/**
 * Example keyboard class as a fallback for when no joystick is connected.
 *
 * @param applet the calling applet
 */
public class Keyboard implements Controller, KeyListener {
	private boolean up = false;
	private boolean down = false;
	private boolean left = false;
	private boolean right = false;
	
	public Keyboard(Container container) {
		container.addKeyListener(this);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyPressed(java.awt.event.KeyEvent)
	 */
	public void keyPressed(KeyEvent e) {
		this.check(e.getKeyCode(), true);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyReleased(java.awt.event.KeyEvent)
	 */
	public void keyReleased(KeyEvent e) {
		this.check(e.getKeyCode(), false);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyTyped(java.awt.event.KeyEvent)
	 */
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

	/*
	 * (non-Javadoc)
	 * @see Controller#isConnected()
	 */
	public boolean isConnected() {
		return true;
	}
	
	/*
	 * (non-Javadoc)
	 * @see Controller#poll()
	 */
	public void poll() {}
	
	/*
	 * (non-Javadoc)
	 * @see Controller#getX()
	 */
	public int getX() {
		if (this.left) {
			return 0;
		} else {
			if (this.right) {
				return 65535;
			} else {
				return CENTRE;
			}
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see Controller#getY()
	 */
	public int getY() {
		if (this.up) {
			return 0;
		} else {
			if (this.down) {
				return 65535;
			} else {
				return CENTRE;
			}
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see Controller#getZ()
	 */
	public int getZ() {
		return CENTRE;
	}
	
	/*
	 * (non-Javadoc)
	 * @see Controller#getButtons()
	 */
	public int getButtons() {
		return 0;
	}
}
