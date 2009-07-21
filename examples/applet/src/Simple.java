import java.applet.Applet;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;

/**
 * Example implementation of adding joystick control to a Java applet.
 */
@SuppressWarnings("serial")
public class Simple extends Applet implements Runnable {
	/**
	 *	An instance of a Controller of any kind.
	 */
	Controller controller = null;
	
	/**
	 *	The 'game' thread.
	 */
	Thread thread = null;
	
	/**
	 * The sprite used in this example.
	 */
	Image sheep = null;
	int x = 50;	// sprite's x axis
	int y = 50;	// sprite's y axis
	
	/**
	 * The buffer's image context.
	 */
	Image bufferImage;
	
	/**
	 * Used for double buffering the applet's canvas.
	 */
	Graphics buffer;

	int width;	// applet's width
	int height;	// applet's width
	
	public void init() {
		try {
			sheep = getImage(getClass().getResource("killer_sheep.gif"));
		} catch (Exception e) {
			// ignore
		}
		controller = new Keyboard(this);
	}

	/**
	 * Sets up the back buffer, creates a joystick instance (if possible),
	 * then starts the timer.
	 */
	public void start() {
		setFocusable(true);
		requestFocusInWindow();

		if (buffer == null) {
			Dimension d = getSize();
			width  = d.width;
			height = d.height;
			bufferImage = createImage(width, height);
			buffer = bufferImage.getGraphics();
		}
		
		if (controller instanceof Joystick == false) {
			attach();
		}
		
		thread = new Thread(this);
		thread.start();
	}
	
	public void stop() {
		thread = null;
	}
		
	/**
	 * Tries to create a joystick plug-in instance, falling back to keyboard
	 * control if it fails.
	 */
	public void attach() {
		Controller ctrl = null;
		try {
			ctrl = Joystick.createJoystickInstance(this);
		} catch (Exception e) {
			System.err.println("Couldn't attach to joystick  so switching to key based control: " + e);
		}
		if (ctrl != null) {
			controller = ctrl;
		}
	}
	
	/**
	 *	The game loop.
	 */
	public void run() {
		while (Thread.currentThread() == thread) {
			if (controller.isConnected()) {
				// gets the axes
				int ctlX = controller.getX();
				int ctlY = controller.getY();
				
				// advances the sprite's position accordingly
				if (ctlX < 28672) {
					x += (ctlX - 32768) / 2048;
				} else {
					if (ctlX > 36864) {
						x += (ctlX - 32768) / 2048;
					}
				}
				if (x < 0) {
					x = 0;
				} else {
					if (x > width) {
						x = width;
					}
				}
				
				if (ctlY < 28672) {
					y += (ctlY - 32768) / 2048;
				} else {
					if (ctlY > 36864) {
						y += (ctlY - 32768) / 2048;
					}
				}
				if (y < 0) {
					y = 0;
				} else {
					if (y > height) {
						y = height;
					}
				}
			}
			
			repaint();
		
			try {
				Thread.sleep(40);
			} catch (InterruptedException e) {}
		}
	}
	
	public void update(Graphics g) {
		paint(g);
	}
	
	public void paint(Graphics g) {
		if (buffer != null) {
			buffer.setColor(getBackground());
			buffer.fillRect(0, 0, width, height);
			
			if (sheep != null) {
				buffer.drawImage(sheep, x, y, this);
			} else {
				buffer.setColor(Color.RED);
				buffer.drawRect(x, y, 64, 64);
			}
			g.drawImage(bufferImage, 0, 0, this);
		} else {
			super.paint(g);
		}
	}
}
