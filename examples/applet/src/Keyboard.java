import java.awt.Container;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

/**
 * Example keyboard class as a fallback for when no joystick is connected.
 */
public class Keyboard implements Controller, KeyListener {
	/**
	 * Current state of the up key.
	 */
	private boolean up;
	
	/**
	 * Current state of the down key.
	 */
	private boolean down;
	
	/**
	 * Current state of the left key.
	 */
	private boolean left;
	
	/**
	 * Current state of the right key.
	 */
	private boolean right;
	
	/**
	 * Creates a keyboard controller receiving key events from the specified
	 * container.
	 * 
	 * @param container AWT container receiving key events
	 */
	public Keyboard(Container container) {
		container.addKeyListener(this);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyPressed(java.awt.event.KeyEvent)
	 */
	public void keyPressed(KeyEvent e) {
		check(e.getKeyCode(), true);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyReleased(java.awt.event.KeyEvent)
	 */
	public void keyReleased(KeyEvent e) {
		check(e.getKeyCode(), false);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.event.KeyListener#keyTyped(java.awt.event.KeyEvent)
	 */
	public void keyTyped(KeyEvent e) {}
	
	/**
	 * Converts keycodes to the joystick position equivalents.
	 * 
	 * @param keyCode Java keycode
	 * @param status {@code true} for key down, {@code false} for key up
	 */
	private void check(int keyCode, boolean status) {
		switch (keyCode) {
		case KeyEvent.VK_UP:
			up = status;
			break;
		case KeyEvent.VK_DOWN:
			down = status;
			break;
		case KeyEvent.VK_LEFT:
			left = status;
			break;
		case KeyEvent.VK_RIGHT:
			right = status;
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
		if (left) {
			return 0;
		} else {
			if (right) {
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
		if (up) {
			return 0;
		} else {
			if (down) {
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
