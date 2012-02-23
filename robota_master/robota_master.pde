// Wire Master Writer
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Writes data to an I2C/TWI slave device
// Refer to the "Wire Slave Receiver" example for use with this

// Created 29 March 2006

#include <Wire.h>

#define LED_OUT 13

char z = 'r';

//int motor_reset = 2; //motor reset pin connected to digital pin 2

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);
  Serial.println("Robota Version 0.1a");
  delay(50); // reset delay
}

void loop()
{  
  while (!Serial.available()); // wait for input

  z = Serial.read();
  
  Serial.println("bagalazi!");
  Wire.beginTransmission(4); // transmit to device #4
  Wire.send(z);              // sends one byte  
  Wire.endTransmission();    // stop transmitting

  //delay(10);

}

