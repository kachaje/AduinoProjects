/**
 *	@file		FunnelRover.pde
 *	@author		Edward Wilson (edwilson1989@gmail.com)
 *  	@date 		03-08-10
 *      @brief		Rover controlled by Xbee and a polulu motor controller 
 */
 
#include <PololuQik2.h>
#include <NewSoftSerial.h>
#include <CRC7.h>
#include <Servo.h> 

#define TxPin      4
#define RxPin      5
#define ResetPin   6
#define ErrorPin   3      // Must be an interrupt pin
#define LedPin     13


CRC7 crc = CRC7();
NewSoftSerial mySerial =  NewSoftSerial(RxPin, TxPin);
PololuQik2 motor = PololuQik2(&mySerial,ResetPin,ErrorPin,true, &crc);
Servo myservo;
int speed = 127;
int pos = 0;



void forward(){
   motor.motor0Forward(speed);
   motor.motor1Forward(speed);
   Serial.println("Forwards");
}

void reverse(){
   motor.motor0Reverse(speed);
   motor.motor1Reverse(speed);
   Serial.println("Reverse");
}

void turnLeft(){
   motor.motor0Forward(speed);
   motor.motor1Reverse(speed);
   Serial.println("turnLeft");
}

void turnRight(){
   motor.motor0Reverse(speed);
   motor.motor1Forward(speed);
   Serial.println("turnRight");
}

void safetyOff(){
   motor.stopBothMotors();
   Serial.println("safety Off");
}

void reset(){
   Serial.println("Reset");
   motor.begin();
}

void up(){
  myservo.write(pos++);
}

void down(){
 myservo.write(pos--); 
}

void setup() {  
  Serial.begin(115200);
  mySerial.begin(38400);
  motor.begin();
  Serial.println("Rover Interpretter Version 0.1a (Xbee)");
  pinMode(13,OUTPUT);
  motor.stopBothMotors();
  myservo.attach(7); 
}

void firmware(){
   Serial.println(motor.getFirmwareVersion());
}

void loop() {
  while (!Serial.available()); // wait for input
   
  char z = Serial.read();
  
  switch(z){
    case 'a':
      turnLeft();
      break;
    case 'd':
      turnRight();
      break;
    case '[':
      up();
      break;
    case ']':
      down();
      break;
    case 'w':
      forward();
      break;
    case 's':
      reverse();
      break;
    case '<':
      if(speed < 127)
         speed++;
      break;
    case '>':
      if(speed > 1)
         speed--;
      break;
    case 'r':
      reset();
      break;
    case 'f':
      firmware();
      break;
    default:
      safetyOff();
  }  
    digitalWrite(LedPin,digitalRead(LedPin) ? LOW : HIGH);
}
