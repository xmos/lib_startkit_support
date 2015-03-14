// Copyright (c) 2015, XMOS Ltd, All rights reserved

#include <xs1.h>
#include <xscope.h>
#include <print.h>
#include <stdio.h>
#include "capsens.h"
#include "slider.h"

#define SLIDER_POLL_PERIOD 200000

[[combinable]]
static void slider_periodic(server slider_if i,
                            client slider_query_if q)
{
  timer tmr;
  int t;
  sliderstate state = IDLE;
  tmr :> t;
  while (1) {
    select {
    case tmr when timerafter(t) :> void:
      sliderstate new_state = q.filter();
      if (new_state != state) {
        i.changed_state();
        state = new_state;
      }
      t += SLIDER_POLL_PERIOD;
      break;
    case i.get_slider_state() -> sliderstate ret:
      ret = state;
      break;
    case i.get_coord() -> int coord:
      coord = q.get_coord();
      break;
    }
  }
}

[[combinable]]
void slider_task(server slider_if i, port cap, const clock clk,
                 static const int n_elements,
                 static const int N,
                 int threshold_pressed, int threshold_unpressed)
{
  slider_query_if i_query;
  absolute_slider_if abs;
  [[combine]]
  par {
    absolute_slider(abs, cap, clk, n_elements, N, threshold_pressed,
                    threshold_unpressed);
    slider(i_query, abs);
    slider_periodic(i, i_query);
  }
}
