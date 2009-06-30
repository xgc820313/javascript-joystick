/**
 *	Defines the basic requirements for an input method.
 */
public interface Controller {
	/**
	 *	Value of an axis when centred.
	 */
	public final static int CENTRE = 32768;
	
	/**
	 *	Forces a read of the input device.
	 */
	public void poll();
	
	/**
	 *	Reads the X axis (left/right).
	 */
	public int getX();
	
	/**
	 *	Reads the Y axis (up/down).
	 */
	public int getY();
	
	/**
	 *	Reads the state of all the devices's non-directional buttons.
	 */
	public int getButtons();
}