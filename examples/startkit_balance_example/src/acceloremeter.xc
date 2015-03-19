// Copyright (c) 2015, XMOS Ltd, All rights reserved

#include "i2c.h"
#include "ball.h"
#include <xs1.h>
#include <print.h>
#include <xscope.h>
#include "debug_print.h"

/** Function that reads out an acceleration; out of two registers and makes
 * it two's complements.
 */
int read_acceleration(client interface i2c_master_if i2c, int reg) {
  int r;
  i2c_regop_res_t result;
  uint8_t value = i2c.read_reg(0x1D, reg, result);
  r = value << 2;
  value = i2c.read_reg(0x1D, reg+1, result);
  r |= (value >> 6);
  if(r & 0x200) {
    r -= 1023;
  }
  return r;
}

/** Function that reads acceleration in 3 dimensions and outputs them onto a channel end
 */
void accelerometer(client ball_if ball, client interface i2c_master_if i2c) {
  uint8_t data;

  // Set up dividers
  data = 0x01;                                 // Set up dividers
  i2c.write_reg(0x1D, 0x0E, data);
  data = 0x01;
  i2c.write_reg(0x1D, 0x2A, data);
  while(1) {
    i2c_regop_res_t result;
    do {
      data = i2c.read_reg(0x1D, 0x00, result);
    } while (!data & 0x08);
    int x, y, z;
    x = read_acceleration(i2c, 1);
    y = read_acceleration(i2c, 3);
    z = read_acceleration(i2c, 5);

    // Once the position is read use it to set the ball position
    ball.new_position(x, y, z);
  }
}
