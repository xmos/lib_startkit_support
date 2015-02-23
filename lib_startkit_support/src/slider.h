// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#ifndef _SLIDER_H_
#define _SLIDER_H_

#include "startkit_slider.h"

#define ABSOLUTE_SLIDER_ELEMENT 1000

typedef interface absolute_slider_if  {
  int get_coord();
} absolute_slider_if;

[[distributable]]
void absolute_slider(server absolute_slider_if i, port cap, const clock clk,
                     static const int n_elements,
                     static const int N,
                     int threshold_pressed, int threshold_unpressed);
                   
typedef interface slider_query_if {
  sliderstate filter();
  int get_coord();
} slider_query_if;

[[distributable]]
void slider(server slider_query_if i, client absolute_slider_if abs);

#endif // _SLIDER_H_

