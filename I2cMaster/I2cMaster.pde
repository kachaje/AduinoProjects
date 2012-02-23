// Wire Master Writer
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Writes data to an I2C/TWI slave device
// Refer to the "Wire Slave Receiver" example for use with this

// Created 29 March 2006

#include <Wire.h>

#define LED_OUT 13

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  pinMode(LED_OUT, OUTPUT);
  digitalWrite(LED_OUT, LOW);
}

byte x = 0;

void loop()
{
  for (int i=0; i<x; i++) {
    digitalWrite(LED_OUT, HIGH);
    delay(200);
    digitalWrite(LED_OUT, LOW);
    delay(200);
  }
  
  Wire.beginTransmission(4); // transmit to device #4
  Wire.send(x);              // sends one byte  
  Wire.endTransmission();    // stop transmitting
  
  x++;
  if (x == 10)
    x = 0;

  delay(5000);
}
