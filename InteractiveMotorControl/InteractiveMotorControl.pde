/*************************************************************
 * CompactQik2s9v1 - basic class to control Pololu's Qik2s9v1
 * motor controller (http://www.pololu.com/catalog/product/1110)
 * 
 * This uses the default settings for the motor controller and the 
 * Compact Protocol to communicate to it.
 * 
 * This library also depends on the NewSoftSerial library which
 * can be found at: http://arduiniana.org.
 * 
 * Sketch allows for motor control via serial connection to the 
 * Arduino.  PC -> serial -> Arduino -> serial -> Qik2s9v1
 * 
 *************************************************************/

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
  // motor.stopBothMotors();
}



void loop() 
{
  if ( Serial.available() > 0 )
  {
    motorSelection = Serial.read();
    Serial.println(getSpeedByte());
    
    switch(motorSelection)
    {
      case '0':
        motor.motor0Forward(int(127)); //getSpeedByte());
        break;
      case '1':
        motor.motor0Reverse(getSpeedByte());
        break;
      case '2':
        motor.motor1Forward(getSpeedByte());
        break;
      case '3':
        motor.motor1Reverse(getSpeedByte());
        break;        
      case '4':
        motor.motor0Coast();      
        break;
      case '5':
        motor.motor1Coast();
        break;
      case '6':
        motor.stopBothMotors();
        break;
      default:
        showHelp();
        break;
    }     
  }
}

byte getSpeedByte()
{
  return Serial.read();
}

void showHelp()
{
  Serial.println("Send 1 or 2 bytes: ");
  Serial.println("<motor selection> (<speed>)");
  Serial.println("motor selection choices:");
  Serial.println("0 - m0 forward");
  Serial.println("1 - m0 reverse");  
  Serial.println("2 - m1 forward");
  Serial.println("3 - m1 reverse");    
  Serial.println("4 - m0 coast (no speed byte)");
  Serial.println("5 - m1 coast (no speed byte)");
  Serial.println("6 - stop both (no speed byte)");
}
