// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <xscope.h>
#include <print.h>
#include <stdio.h>
#include "capsens.h"
#include "slider.h"

[[distributable]]
void absolute_slider(server absolute_slider_if i, port cap, const clock k,
                     static const int n_elements,
                     static const int N,
                     int threshold_press, int threshold_unpress) {
  int pressed = 0;
  unsigned int base[n_elements];
  unsigned int t[n_elements];
  setupNbit(cap, k);
  measureAverage(cap, base, n_elements, N);
  for(int k = 0; k < n_elements; k++) {
    base[k] >>= 1;
  }
  while (1) {
    select {
    case i.get_coord() -> int coord:
      int avg = 0, n = 0;
      int minoffset = 999;

      measureAverage(cap, t, n_elements, N);
      for(int k = 0; k < n_elements; k++) {
        t[k] >>= 1;
      }
#if 0
      for(int k = 0; k < n_elements; k++) {
        int offset = t[k]-base[k];
        if (offset < minoffset) {
          minoffset = offset;
        }
      }
#endif
      for(int k = 0; k < n_elements; k++) {
        int offset = (t[k]-base[k]);// - minoffset;
        unsigned int h, l, correctionSpeed;
        //            printf(" %8d ", t[k] - base[k]);
        avg = avg + k * offset;
        n += offset;
        if (base[k] > t[k]) {
          correctionSpeed = 10;        // Lower sample found - adapt quickly
        } else {
          correctionSpeed = 10;       // Higher sample found - adapt slowly
        }                               // compute base = ((2^cs - 1) * base + t) 2^-cs
        {h,l} = mac( (1<<correctionSpeed) - 1, base[k], 0, t[k]);
        base[k] = h << (32-correctionSpeed) | l >> correctionSpeed;
      }
      if (pressed) {
        if (n < threshold_unpress) {
          pressed = 0;
        }
      } else {
        if (n > threshold_press) {
          pressed = 1;
        }
      }
      coord = pressed ? ABSOLUTE_SLIDER_ELEMENT*avg/n : 0;
      //    printf("%6d %d %8d %8d\n", coord, pressed, avg, n);
      break;
    }
  }
}

[[distributable]]
void slider(server slider_query_if i, client absolute_slider_if abs)
{
  timer tt;
  int state = IDLE;
  int lastTime;
  tt :> lastTime;
  int prev_coord = 0;
  int nomoves = 0, lefts = 0, rights = 0;
  while (1) {
    select {
    case i.get_coord() -> int coord:
      coord = abs.get_coord();
      break;
    case i.filter() -> sliderstate ret:
      int coord;
      unsigned time, timePassed;
      timer tt;
      ret = IDLE;

      tt :> time;
      timePassed = time - lastTime;
      coord = abs.get_coord();

      switch (state) {
      case IDLE:
        if (coord) {
          state = PRESSING;
          lastTime = time;
          prev_coord = coord;
          nomoves = lefts = rights = 0;
        }
        break;
      case PRESSING:
        if (timePassed > 500000 && coord) {
          int ms = timePassed / 100000;
          int speed = (coord - prev_coord)*1000/ms;
          //            printf("%3d %08x coord %4d speed %7d %2d %2d %2d\n", ms, cap, coord, speed, lefts, rights, nomoves);
          if (speed > 5000) {
            nomoves--;
            lefts--;
            rights+=2;
          } else if (speed < -5000) {
            lefts+=2;
            nomoves--;
            rights--;
          } else if (speed < 2000 && speed > -2000) {
            lefts--;
            rights--;
            nomoves+=2;
          }
          //            printf("%d %d %d\n", lefts, rights, nomoves);
          lastTime = time;
          prev_coord = coord;
          //     if (nomoves > lefts+3 && nomoves > rights+3 || abs(lefts - rights) < 3 && (lefts+rights) > 15) {
          //             state = PRESSED;
          //             ret = PRESSED;
          //         }
          if (rights > 6) {
            //                printf("Left\n");
            state = LEFTING;
            ret = LEFTING;
          }
          if (lefts > 6) {
            //                printf("Right\n");
            state = RIGHTING;
            ret = RIGHTING;
          }
        } else if (timePassed > 20000000 && !coord) {
          state = IDLE;
        } else {
          //printf("%3d %08x coord ---- speed ------- %2d %2d %2d\n", timePassed / 100000, cap, lefts, rights, nomoves);
        }
        break;
      case PRESSED:
      case LEFTING:
      case RIGHTING:
        if (!coord && (time - lastTime) > 10000000) {
          state = IDLE;
          lastTime = time;
          ret = RELEASED;
        }
        break;
      case RELEASED:
        // not reached
        break;
      }
      break;
    }
  }
}


