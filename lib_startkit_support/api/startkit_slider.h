// Copyright (c) 2015, XMOS Ltd, All rights reserved

#ifndef _STARTKIT_SLIDER_H_
#define _STARTKIT_SLIDER_H_

#include <xs1.h>

/** 
 * Type that enumerates the possible activities that may have happened on a slider.
 */
typedef enum {IDLE, PRESSING, PRESSED, LEFTING, RIGHTING, RELEASED} sliderstate;

/** 
 * Interface for querying the slider value and state.
 */
typedef interface slider_if {
  [[notification]] slave void changed_state();
  [[clears_notification]] sliderstate get_slider_state();
  int get_coord();
} slider_if;

/** 
 * Function to implement a slider task.
 *
 * \param i        interface used to communicate with this task.    
 *
 * \param cap      port on which the cap sense is connected
 *
 * \param clk      clock block to be used.
 * 
 * \param n_elements number of segments on this slider. Typically 4 or 8.
 * Note that at present this is hardcoded in the capsens.h file too and set
 * to 4.
 *
 * \param N
 *
 * \param threshold_pressed   Value above which something is pressed. Set to 1000
 *
 * \param threshold_unpressed Value below which something is no longer pressed. Set to 200
 */
[[combinable]]
void slider_task(server slider_if i, port cap, const clock clk,
                 static const int n_elements,
                 static const int N,
                 int threshold_pressed, 
                 int threshold_unpressed);

#endif // _STARTKIT_SLIDER_H_

