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
	 * An instance of a Controller of any kind.
	 */
	private Controller controller;
	
	/**
	 * The 'game' thread.
	 */
	private Thread thread;
	
	/**
	 * The sprite used in this example.
	 */
	private Image sheep;
	
	/**
	 * Sheep sprite's x-axis.
	 */
	private int x;
	
	/**
	 * Sheep sprite's y-axis.
	 */
	private int y;
	
	/**
	 * The buffer's image context.
	 * 
	 * @see #buffer
	 */
	private Image bufferImage;
	
	/**
	 * Used for double buffering the applet's canvas.
	 */
	private Graphics buffer;
	
	/**
	 * Applet width at startup.
	 */
	private int width;
	
	/**
	 * Applet height at startup.
	 */
	private int height;
	
	/**
	 * Creates the applet and initialises the sheep's start position.
	 */
	public Simple() {
		x = 50;
		y = 50;
	}
	
	public void init() {
		try {
			sheep = getImage(getClass().getResource("killer_sheep.gif"));
		} catch (Exception e) {
			// ignore
		}
		controller = new Keyboard(this);
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
		
		if (!(controller instanceof Joystick)) {
			attach();
		}
		
		thread = new Thread(this);
		thread.start();
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.applet.Applet#stop()
	 */
	public void stop() {
		thread = null;
	}
	
	/**
	 * The game loop.
	 */
	public void run() {
		while (Thread.currentThread() == thread) {
			if (controller.isConnected()) {
				/*
				 * Reads the axes (either from a joystick or, if none is
				 * connected, the keyboard).
				 */
				int ctlX = controller.getX();
				int ctlY = controller.getY();
				/*
				 * Updates the sprite's position (with a little deadzone,
				 * taking values from 28672 to 36864 as being within the
				 * stick's centre).
				 */
				if (ctlX < 28672) {
					x += (ctlX - 32768) / 2048;
				} else {
					if (ctlX > 36864) {
						x += (ctlX - 32768) / 2048;
					}
				}
				/*
				 * Clamp the sprite between the left and right of the applet.
				 */
				if (x < 0) {
					x = 0;
				} else {
					if (x > width) {
						x = width;
					}
				}
				/*
				 * Do the same as above for the y-axis.
				 */
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
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.Container#update(java.awt.Graphics)
	 */
	public void update(Graphics g) {
		paint(g);
	}
	
	/*
	 * (non-Javadoc)
	 * @see java.awt.Container#paint(java.awt.Graphics)
	 */
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
