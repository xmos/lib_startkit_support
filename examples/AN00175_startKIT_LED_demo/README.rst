A startKIT LED demo
===================

.. version:: 1.0.1

Summary
-------

This application shows a very simple program running on the XMOS
startKIT development board. It displays an animated pattern on the
LEDS on the board by directly writing to the port which is connected
to the LEDs.

Required tools and libraries
............................

* xTIMEcomposer Tools - Version 14.0 

Required hardware
.................

This application note is designed to run on any XMOS multicore microcontroller.

The example code provided with the application has been implemented and tested
on the XMOS startKIT. It depends on the specific mapping of ports to
hardware but is quite general in its nature.

Prerequisites
.............

  - This document assumes familiarity with the XMOS xCORE architecture, the XMOS GPIO library, 
    the XMOS tool chain and the xC language. Documentation related to these aspects which are 
    not specific to this application note are linked to in the references appendix.
  - For descriptions of XMOS related terms found in this document please see the XMOS Glossary [#]_.


  .. [#] http://www.xmos.com/published/glossary

  .. [#] http://www.xmos.com/published/xmos-gpio-lib

