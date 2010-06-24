/**
 * Defines the basic requirements for an input method.
 */
public interface Controller {
	/**
	 * Value of an axis when centred.
	 */
	public final static int CENTRE = 32768;
	
	/**
	 * Returns {@code true} if a controller is connected.
	 * 
	 * @return {@code true} if a controller is connected
	 */
	public boolean isConnected();
	
	/**
	 * Sends an explicit poll to the controller (forces a read).
	 * {@code autoPoll} needs to be set to {@code false} for this to have any
	 * effect.
	 */
	public void poll();
	
	/**
	 * Reads the x-axis (left/right).
	 * 
	 * @return a value between 0 and 65535 (with 0 being extreme left and 65535 extreme right)
	 */
	public int getX();
	
	/**
	 * Reads the y-axis (up/down).
	 * 
	 * @return a value between 0 and 65535 (with 0 being extreme top and 65535 extreme bottom)
	 */
	public int getY();
	
	/**
	 * Reads the throttle (or z-axis). The exact values returned are dependent
	 * on the controller; some map shoulder buttons to the throttle, some
	 * foot pedals, etc.
	 * 
	 * @return a value between 0 and 65535
	 */
	public int getZ();
	
	/**
	 * Reads the state of all the devices's non-directional buttons.
	 * 
	 * @return the buttons represented as bits in an integer
	 */
	public int getButtons();
}