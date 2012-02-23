#include <NewSoftSerial.h>

#define rxPin 3
#define txPin 4

NewSoftSerial mySerial = NewSoftSerial(rxPin, txPin);

void setup()
{
  mySerial.begin(38400);
  mySerial.print(0xAA, BYTE);  // let qik learn the baud rate
  mySerial.print(0x88, BYTE);  // M0 forward command byte
  mySerial.print(0x7F, BYTE);  // M0 speed = 127 (full speed in 7-bit mode)
}

void loop()
{
}


