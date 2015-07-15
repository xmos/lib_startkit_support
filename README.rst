Startkit support library
========================

Summary
-------

This library provides support for accessing the available functionaility
of the startKIT development board.

Features
........

 * Ability to access on-board ADC.
 * Ability to access LEDs and buttons.
 * Ability to access the board's capacitive sensors.


Resource usage
..............

.. resusage::
  :widths: 30 10 30 10 20 10

  * - configuration: Simple LED control
    - globals: port p = XS1_PORT_32A;
    - target: STARTKIT
    - flags:
    - locals: interface startkit_led_if i_led[1];
    - fn: startkit_led_driver(i_led, 1, p);
    - pins: 9
    - ports: 1 (32-bit)

  * - configuration: LED, buttons and cap-sense
    - globals: startkit_gpio_ports p = {XS1_PORT_32A, XS1_PORT_4B, XS1_PORT_4A, XS1_CLKBLK_1};
    - target: STARTKIT
    - flags:
    - locals: interface startkit_led_if i_led;
              interface startkit_button_if i_button;
              interface slider_if i_slider_x;
              interface slider_if i_slider_y
    - fn: startkit_gpio_driver(i_led, i_button, i_slider_x, i_slider_y, p);
    - pins: 9
    - ports: 1 (32-bit), 2 (4-bit)

  * - configuration: ADC
    - globals: out port adc_sample = ADC_TRIG_PORT;
    - target: STARTKIT
    - flags:
    - locals: interface startkit_adc_if i_adc; chan c_adc;
    - fn: adc_task(i_adc, c_adc, 10, adc_sample);
    - pins: 5
    - ports: 1 (1-bit)

  * - configuration: Cap-sense slider
    - globals: port p = XS1_PORT_32A; clock clk = XS1_CLKBLK_1;
    - target: STARTKIT
    - flags:
    - locals: interface slider_if i;
    - fn: slider_task(i, p, clk, 4, 80, 100, 50);
    - pins: 9
    - ports: 1 (4-bit)

Software version and dependencies
.................................

.. libdeps::

Related application notes
.........................

The following application notes use this library:

  * AN00173 - A startKIT accelerometer demo
  * AN00174 - A startKIT glowing LED demo
  * AN00175 - A startKIT LED demo
  * AN00176 - A startKIT noughts and crosses game (tic-tac-toe)
  * AN00177 - A startKIT ADC example
