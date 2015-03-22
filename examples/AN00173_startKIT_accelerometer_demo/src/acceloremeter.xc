// Copyright (c) 2015, XMOS Ltd, All rights reserved

#include "i2c.h"
#include "ball.h"
#include <xs1.h>
#include <xscope.h>
#include "debug_print.h"

// FXOS8700EQ register address defines
#define FXOS8700EQ_I2C_ADDR 0x1E
#define FXOS8700EQ_XYZ_DATA_CFG_REG 0x0E
#define FXOS8700EQ_CTRL_REG_1 0x2A
#define FXOS8700EQ_DR_STATUS 0x0
#define FXOS8700EQ_OUT_X_MSB 0x1
#define FXOS8700EQ_OUT_X_LSB 0x2
#define FXOS8700EQ_OUT_Y_MSB 0x3
#define FXOS8700EQ_OUT_Y_LSB 0x4
#define FXOS8700EQ_OUT_Z_MSB 0x5
#define FXOS8700EQ_OUT_Z_LSB 0x6

/** Function that reads out an acceleration; out of two registers and makes
 * it two's complements.
 */
int read_acceleration(client interface i2c_master_if i2c, int reg) {
    i2c_regop_res_t result;
    int accel_val = 0;
    unsigned char data = 0;

    // Read MSB data
    data = i2c.read_reg(FXOS8700EQ_I2C_ADDR, reg, result); 
    if (result != I2C_REGOP_SUCCESS) {
      debug_printf("I2C read reg failed\n");
      return 0;
    }

    accel_val = data << 2;

    // Read LSB data
    data = i2c.read_reg(FXOS8700EQ_I2C_ADDR, reg+1, result);
    if (result != I2C_REGOP_SUCCESS) {
      debug_printf("I2C read reg failed\n");
      return 0;
    }

    accel_val |= (data >> 6);

    if (accel_val & 0x200) {
      accel_val -= 1023;
    }

    return accel_val;
}

/** Function that reads acceleration in 3 dimensions and outputs them
    to the LED display task.a channel end
 */
void accelerometer(client ball_if ball, client interface i2c_master_if i2c) {
  uint8_t data;
  i2c_regop_res_t result;
  // Configure FXOS8700EQ
  result = i2c.write_reg(FXOS8700EQ_I2C_ADDR, FXOS8700EQ_XYZ_DATA_CFG_REG, 0x01);
  if (result != I2C_REGOP_SUCCESS) {
    debug_printf("I2C write reg failed\n");
  }
  
  // Enable FXOS8700EQ
  result = i2c.write_reg(FXOS8700EQ_I2C_ADDR, FXOS8700EQ_CTRL_REG_1, 0x01);
  if (result != I2C_REGOP_SUCCESS) {
    debug_printf("I2C write reg failed\n");
  }

  while(1) {
    i2c_regop_res_t result;
    // Wait for data ready from FXOS8700EQ
    do {
      data = i2c.read_reg(FXOS8700EQ_I2C_ADDR, FXOS8700EQ_DR_STATUS, result);
    } while (!data & 0x08);
    int x, y, z;
    x = read_acceleration(i2c, 1);
    y = read_acceleration(i2c, 3);
    z = read_acceleration(i2c, 5);

    // Once the position is read use it to set the ball position
    ball.new_position(x, y, z);
  }
}
