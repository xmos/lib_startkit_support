A startKIT ADC demo
===================

.. version:: 1.0.1

Summary
-------

This applications provides a very simple example of using the ADC
module.  It uses the on-chip ADC in one shot mode (a trigger is called every
200ms from a timer) and then reads the 4 values after conversion
complete notification received. It also shows an example of a select
(wait on multiple events) because it also listens to the button, and
lights additional LEDs when that is pressed.

Required tools and libraries
............................

* xTIMEcomposer Tools - Version 14.0
* startKIT support library (lib_startkit_support) - Version 1.0.0

Required hardware
.................

This application note is designed to run on the XMOS startKIT.

Prerequisites
.............

  - This document assumes familiarity with the XMOS xCORE architecture, the XMOS GPIO library, 
    the XMOS tool chain and the xC language. Documentation related to these aspects which are 
    not specific to this application note are linked to in the references appendix.
  - For descriptions of XMOS related terms found in this document please see the XMOS Glossary [#]_.


  .. [#] http://www.xmos.com/published/glossary


