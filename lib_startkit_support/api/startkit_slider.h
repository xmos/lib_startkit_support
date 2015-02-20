// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#ifndef _SLIDER_H_
#define _SLIDER_H_

#include "startkit_absolute.h"

/** Type that enumerates the possible activities that may have happened on
    a slider.
 */
typedef enum {IDLE, PRESSED, LEFTING, RIGHTING, RELEASED, PRESSING} sliderstate;

typedef interface slider_query_if {
  sliderstate filter();
  int get_coord();
} slider_query_if;

[[distributable]]
void slider(server slider_query_if i, client absolute_slider_if abs);

/** Interface for querying the slider value and state.
 */
typedef interface slider_if {
  [[notification]] slave void changed_state();
  [[clears_notification]] sliderstate get_slider_state();
  int get_coord();
} slider_if;

/** Function to implement a slider task.
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

#endif // _SLIDER_H_

