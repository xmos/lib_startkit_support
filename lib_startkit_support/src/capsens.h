// Copyright (c) 2016, XMOS Ltd, All rights reserved

#ifndef CAPSENS_H
#define CAPSENSE_H 1

#include <xs1.h>
#ifdef __capsense_conf_h_exists__
#include "capsense_conf.h"
#endif

#ifndef CAPSENSE_PULLDOWN
#define CAPSENSE_PULLDOWN   1    // Set to zero for pull-ups.
#endif

void capsenseInitClock(clock k);

void setupNbit(port cap, const clock k);

void measureNbit(port cap, unsigned int times[width],
                 static const unsigned width,
                 static const unsigned N);

void measureAverage(port cap, unsigned int avg[width],
                    static const unsigned width,
                    static const unsigned N);

void measureAveragePrint(port cap, unsigned int avg[width],
                         static const unsigned width,
                         static const unsigned N);

#endif
