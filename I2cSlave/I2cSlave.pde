// Wire Slave Receiver
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Receives data as an I2C/TWI slave device
// Refer to the "Wire Master Writer" example for use with this

// Created 29 March 2006

#include <Wire.h>

#define LED_OUT 13

int x;

void setup() {
  Wire.begin(4);                // join i2c bus with address #4
  Wire.onReceive(receiveEvent); // register event
  Serial.begin(9600);           // start serial for output
  pinMode(LED_OUT, OUTPUT);
  digitalWrite(LED_OUT, LOW);
  x = 0;
}

void loop() {
  if (x > 0) {
    for (int i=0; i<x; i++) {
      digitalWrite(LED_OUT, HIGH);
      delay(200);
      digitalWrite(LED_OUT, LOW);
      delay(200);
    }
    x = 0;
    delay(1000);
  }
  delay(100);
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany) {
  x = Wire.receive();    // receive byte as an integer
}
