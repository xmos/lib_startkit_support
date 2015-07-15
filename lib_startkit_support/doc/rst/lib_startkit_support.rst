.. include:: ../../../README.rst

Usage
-----

To access any of the library functionality the application
``Makefile`` needs to add ``lib_startkit_support`` to its build
modules::

  USED_MODULES = ... lib_startkit_support ...

The GPIO functions can be found by using the following header::

  #include <startkit_gpio.h>

The ADC functions can be found by usings the following header::

  #include <startkit_adc.h>

The capacitive sensing functions can be found by usings the following header::

  #include <startkit_slider.h>

Simple LED control
..................

The ``startkit_led_driver`` task allows your program to drive LEDS on
and off in the 3x3 LED array on the startKIT. This task only allows
simple on-off control but has low resource usage.

The driver is instantiated as a parallel task that run in a
``par`` statement. The application communicates to this tasks using
the ``startkit_led_if`` interface.

.. figure:: images/simple_led_task_diag.*

   Simple LED control task diagram

For example, the following code instantiates the LED driver component
and connects to it::

  #include <platform.h>
  #include <startkit_gpio.h>

  port p_gpio = XS1_PORT_32A;

  int main() {
    interface startkit_led_if i_led[1];
    par {
      on tile[0]: startkit_led_driver(i_led, 1, p_gpio);
      on tile[0]: app(i_led[0]);
    }
  }

The task must be passed port 32A. The interface connection is an array
(so several tasks can access the LEDs).

|newpage|

The application can then communicate with the task via the interface
e.g.::

 void app(client startkit_led_if led)
 {
   ...
   // Set the middle LED (row 1, col 1) on
   led.set(1, 1, LED_ON);
   // Set the top left LED (row 0, col 0) off
   led.set(0, 0, LED_OFF);
   ...

Controlling LEDs, buttons and capacitive sensing together
.........................................................

On the startKIT board, the LEDs, buttons and capacitive sensors are
all either on the same xCORE ports or are routed close enough on the
board to cause possible cross-talk. For this reason, they all need to
be controlled synchronized together so they do not intefere.

The ``startkit_gpio_driver`` gives your application access to all
these hardware interfaces. It is a task that supplies several software
interfaces to the application:

.. figure:: images/gpio_task_diag.*

   GPIO task diagram

The driver tasks can be instatiated in the top level of the program as
in this example::

  // The port structure required for the GPIO task
  startkit_gpio_ports gpio_ports =
    {XS1_PORT_32A, XS1_PORT_4B, XS1_PORT_4A, XS1_CLKBLK_1};

  int main() {
    startkit_button_if i_button;
    startkit_led_if i_led;
    slider_if i_slider_x, i_slider_y;
    par {
      on tile[0]: startkit_gpio_driver(i_led, i_button,
                                       i_slider_x, i_slider_y,
                                       gpio_ports);
      on tile[0]: app(i_led, i_button, i_slider_x, i_slider_y);
    }
    return 0;
  }

The slider interface is described in :ref:`lib_startkit_support_slider`.

|newpage|

The PWM LED interface
~~~~~~~~~~~~~~~~~~~~~

When using the GPIO driver. The LED interface can set a level for the
LED which is driven via a PWM signal. For each LED, the interface
accepts a range from ``0`` to ``LED_ON``. So for example, the
following code will set an LED to 50% illumination::

  void app(client startkit_led_if led, ...) {

      ...
      led.set(1, 1, LED_ON/2);


The button interface
~~~~~~~~~~~~~~~~~~~~

The button interface causes an ``changed`` event that can be selected
on using  xC ``select`` construct whenever a change occurs in the
button.  The ``get_value`` function can then be used to get the button
state e.g.::

  void app(.., client startkit_button_if button, ...) {
     ..
     select {
       case button.changed():
          if (button.get_value() == BUTTON_DOWN) {
             // handle button down event
          } else {
             // handle button up event
          }
          break;
       ...
     }
     ...

.. _lib_startkit_support_slider:

Using the capacative sensor
...........................

The capacitive sensor can be access via the ``slider_if``
interface. Two interfaces are provided - one in the horizontal (``x``)
direction and one in the vertical (``y``) direction.

The interface will cause a ``changed_state`` event when it changes
state that can be reacted to in an xC ``select`` statement e.g.::

  void app(.., client slider_if i_slider_x, ...) {
     ..
     select {
        case i_slider_x.changed_state():
           sliderstate state = i_slider_x.get_slider_state();
           if (state == LEFTING) {
              // handle the event when the user swipes left
           } else if (state == RIGHTING) {
              ...

|newpage|

Accessing the ADC
.................

The ADC functions can be found by using the following header::

  #include <startkit_adc.h>

The ADC component is instantiated as a parallel task that run in a
``par`` statement. The application communicates to this tasks using
the ``startkit_adc_if`` interface. The ``adc_task`` then needs to be
connected to the special ``startkit_adc`` service which attaches to
the analogue hardware.

.. figure:: images/adc_task_diag.*

   ADC task diagram

For example, the following code instantiates the ADC component
and connects to it::

  #include <platform.h>
  #include <startkit_adc.h>

  out port adc_sample = ADC_TRIG_PORT;

  int main() {
    chan c_adc;
    interface startkit_adc_if i_adc;
    par {
      startkit_adc(c_adc);
      on tile[0]: adc_task(i_adc, c_adc, 0, adc_sample);
      on tile[0]: app(i_adc);
    }
  }

The application can then communicate with the task via the interface
e.g.::

 void app(client startkit_adc_if adc)
 {
   ...
   adc.trigger();  // Fire the ADC!
   select {        // Wait for the ADC to complete.
     case adc.complete():
        short vals[4];
        adc.read(vals); // Read analogue data into vals array
        ...

More information on interfaces and tasks can be be found in
the :ref:`XMOS Programming Guide<programming_guide>`.


Startkit ADC API
----------------

.. doxygeninterface:: startkit_adc_if
.. doxygenfunction:: adc_task

Startkit GPIO API
-----------------

.. doxygenenum:: led_val
.. doxygeninterface:: startkit_led_if

|newpage|

.. doxygenenum:: button_val
.. doxygeninterface:: startkit_button_if

|newpage|

.. doxygenfunction:: startkit_led_driver

|newpage|

.. doxygenstruct:: startkit_gpio_ports
.. doxygenfunction:: startkit_gpio_driver

Startkit Slider API
-------------------

.. doxygenenum:: sliderstate
.. doxygeninterface:: slider_if
.. doxygenfunction:: slider_task

|appendix|

Known Issues
------------

No known issues.

.. include:: ../../../CHANGELOG.rst


