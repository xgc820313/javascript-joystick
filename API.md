# JavaScript API #

The plug-in currently works with Firefox, IE, Opera and Safari on Windows, and Safari on OS X. The API is the same across all browsers.

## Methods ##
|boolean|`setDevice(int index)`<br>Select the game device the plug-in instance is connected to; returns <code>true</code> if a controller is connected.<br>
<tr><td>int    </td><td><code>getDevice()</code><br>Returns the index of the game device currently set.                                                               </td></tr>
<tr><td>boolean</td><td><code>isConnected()</code><br>Returns <code>true</code> if a controller is connected.                                                         </td></tr>
<tr><td>void   </td><td><code>setAutoPoll(boolean autoPoll)</code><br>Normally the device state is automatically polled every time a property is read, which may be too slow for the older analogue interface. Setting this to false only polls the device when a <code>poll()</code> is issued, and the property values are taken from that time. (It may also allow for better sync in longer game loops.)</td></tr>
<tr><td>void   </td><td><code>poll()</code><br>An explicit poll to the game device.                                                                                   </td></tr>
<tr><td>string </td><td><code>getProductName()</code><br>Returns the OEM name of the game device.                                                                     </td></tr></tbody></table>

<h2>Properties</h2>
<table><thead><th>int    </th><th>x<br>Joystick x-axis</th></thead><tbody>
<tr><td>int    </td><td>y<br>Joystick y-axis</td></tr>
<tr><td>int    </td><td>z<br>Throttle (or z-axis)</td></tr>
<tr><td>int    </td><td>r<br>Rudder (or r-axis)</td></tr>
<tr><td>int    </td><td>u<br>Joystick u-axis</td></tr>
<tr><td>int    </td><td>v<br>Joystick v-axis</td></tr>
<tr><td>boolean</td><td>a<br><code>true</code> if the A button is pressed (the A button can be reassigned to any of the controller's buttons)</td></tr>
<tr><td>boolean</td><td>b<br><code>true</code> if the B button is pressed (the B button can be reassigned to any of the controller's buttons)</td></tr>
<tr><td>int    </td><td>buttons<br>An integer representing the state of all the game controller's buttons as individual bits</td></tr>
<tr><td>int    </td><td>pov<br>Hat-switch, in degrees multiplied by 100</td></tr></tbody></table>

<h2>Embedding</h2>
For IE (or other ActiveX containers) the class ID is <code>3AE9ED90-4B59-47A0-873B-7B71554B3C3E</code>. For all other browsers the MIME-type is <code>application/x-vnd.numfum-joystick</code>. Sample code to follow.