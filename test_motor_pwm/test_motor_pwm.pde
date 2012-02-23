/*Testing the Pololu library to see if I can get the motors controlled
I'm shooting for a test that will have Herbert move forward, backward, etc*/

#include <CompactQik2s9v1.h>
#include <NewSoftSerial.h>

/*
    Important Note:
        The rxPin goes to the Qik's "TX" pin
        The txPin goes to the Qik's "RX" pin
*/
#define rxPin 3
#define txPin 4
#define rstPin 5

NewSoftSerial mySerial =  NewSoftSerial(rxPin, txPin);
CompactQik2s9v1 motor = CompactQik2s9v1(&mySerial,rstPin);

byte motorSelection;
byte motorSpeed;

void setup() 
{
  Serial.begin(9600);
  mySerial.begin(9600);
  motor.begin();
  motor.stopBothMotors();
}



void loop()
{
 
    motorSelection = Serial.read();
    motor.motor0Forward(byte(127));
    motor.motor1Forward(byte(127));
    delay(4000);
    motor.motor0Coast();     
    motor.motor1Coast();
    delay(2000);
    motor.motor0Reverse(byte(127));
    motor.motor1Reverse(byte(127));
    delay(4000);
   
}

//byte getSpeedByte()
//{
//  return Serial.read();
//}

//void showHelp()
//{
//  Serial.println("Send 1 or 2 bytes: ");
//  Serial.println("<motor selection> (<speed>)");
//  Serial.println("motor selection choices:");
//  Serial.println("0 - m0 forward");
//  Serial.println("1 - m0 reverse"); 
//  Serial.println("2 - m1 forward");
//  Serial.println("3 - m1 reverse");   
//  Serial.println("4 - m0 coast (no speed byte)");
//  Serial.println("5 - m1 coast (no speed byte)");
//  Serial.println("6 - stop both (no speed byte)");
//}
