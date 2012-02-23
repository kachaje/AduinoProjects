
#include <Wire.h>

#include <PololuQik2.h>
#include <NewSoftSerial.h>
#include <CRC7.h>
#include <Servo.h> 

#define TxPinSet1      4
#define RxPinSet1      5
#define ResetPinSet1   6
#define ErrorPinSet1   3      // Must be an interrupt pin

#define TxPinSet2      7
#define RxPinSet2      8  

#define TxPinSet3      9
#define RxPinSet3      10

#define LedPin     13

CRC7 crc = CRC7();
NewSoftSerial mySerial1 =  NewSoftSerial(RxPinSet1, TxPinSet1);
NewSoftSerial mySerial2 =  NewSoftSerial(RxPinSet2, TxPinSet2);
NewSoftSerial mySerial3 =  NewSoftSerial(RxPinSet3, TxPinSet3);
PololuQik2 motorSet1 = PololuQik2(&mySerial1,ResetPinSet1,ErrorPinSet1,true, &crc);
PololuQik2 motorSet2 = PololuQik2(&mySerial2,ResetPinSet1,ErrorPinSet1,true, &crc);
PololuQik2 motorSet3 = PololuQik2(&mySerial3,ResetPinSet1,ErrorPinSet1,true, &crc);
int speed = 127;

int delaytype = 25;

int delay1 = 25;
int delay2 = 45;
int delay3 = 75;
int delay4 = 95;
int delay5 = 155;

int irpin = 0;
int forwardpin = 12;
int reversepin = 13;
int distance = 0;

int pos = 0;
// int motor_reset = 2; //digital pin 2 assigned to motor reset

char z;

void M1Forward(){
  motorSet1.motor0Forward(speed);
  Serial.println("M1 grab");
  delay(25);
  motorSet1.begin();
}

void M1Reverse(){
  motorSet1.motor0Reverse(speed);
  Serial.println("M1 release");
  delay(25);
  motorSet1.begin();
}

void M2Forward(){
  motorSet1.motor1Forward(speed);
  Serial.println("M2 forward");
  // delay(delaytype);
  // motorSet1.begin();
}

void M2Reverse(){
  motorSet1.motor1Reverse(speed);
  Serial.println("M2 reverse");
  // delay(delaytype);
  // motorSet1.begin();
}

void M3Forward(){
  motorSet2.motor0Forward(speed);
  Serial.println("M3 forward");
  // delay(delaytype);
  // motorSet2.begin();
}

void M3Reverse(){
  motorSet2.motor0Reverse(speed);
  Serial.println("M3 reverse");
  // delay(delaytype);
  // motorSet2.begin();
}

void M4Forward(){
  motorSet2.motor1Forward(speed);
  Serial.println("M4 forward");
  // delay(delaytype);
  // motorSet2.begin();
}

void M4Reverse(){
  motorSet2.motor1Reverse(speed);
  Serial.println("M4 reverse");
  // delay(delaytype);
  // motorSet2.begin();
}

void forward(){
  digitalWrite(forwardpin, HIGH);   // set the LED on
  motorSet3.motor0Forward(speed);
  motorSet3.motor1Forward(speed);
  Serial.println("forward");
  // delay(155);
  // motorSet3.begin();
}

void reverse(){
  digitalWrite(reversepin, HIGH);   // set the LED on
  motorSet3.motor0Reverse(speed);
  motorSet3.motor1Reverse(speed);
  Serial.println("reverse");
  // delay(155);
  // motorSet3.begin();
}

void rotateccw()
{
  motorSet3.motor0Forward(speed);
  motorSet3.motor1Reverse(speed);
  Serial.println("counter clockwise");
  // delay(155);
  // motorSet3.begin();
}


void rotatecw()
{
  motorSet3.motor0Reverse(speed);
  motorSet3.motor1Forward(speed);
  Serial.println("clockwise");
  // delay(155);
  // motorSet3.begin();
}

void safetyOff(){
  digitalWrite(forwardpin, LOW);   // set the LED on
  digitalWrite(reversepin, LOW);   // set the LED on
  motorSet1.stopBothMotors();
  motorSet2.stopBothMotors();
  motorSet3.stopBothMotors();
  Serial.println("safety Off");
}

void reset(){
  digitalWrite(forwardpin, LOW);   // set the LED on
  digitalWrite(reversepin, LOW);   // set the LED on
  Serial.println("Reset");
  motorSet1.stopBothMotors();
  motorSet2.stopBothMotors();
  motorSet3.stopBothMotors();

  motorSet1.begin();
  motorSet2.begin();
  motorSet3.begin();
  
}

void resetBase(){
  Serial.println("Reset Base");
  motorSet3.stopBothMotors();

  motorSet3.begin();
  
}

void setup() {  
  Wire.begin(4);                // join i2c bus with address #4
  Wire.onReceive(receiveEvent); // register event
  Wire.onRequest(requestEvent); // register event
  Serial.begin(9600);
  mySerial1.begin(38400);
  mySerial2.begin(38400);
  mySerial3.begin(38400);
  motorSet1.begin();
  motorSet2.begin();
  motorSet3.begin();
  Serial.println("Robota Version 0.1a");
  // pinMode(13,OUTPUT);
  motorSet1.stopBothMotors();
  motorSet2.stopBothMotors();
  motorSet3.stopBothMotors();

  pinMode(forwardpin, OUTPUT);
  pinMode(reversepin, OUTPUT);     
     

}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int val) {
  z = Wire.receive();    // receive byte as char
  
  Serial.println(z);

  //z = '0';
}

// function that executes whenever data is requested by master
// this function is registered as an event, see setup()
void requestEvent()
{
  Wire.send(z);                       
}

void firmware(){
  Serial.println(motorSet1.getFirmwareVersion());
  Serial.println(motorSet2.getFirmwareVersion());
  Serial.println(motorSet3.getFirmwareVersion());
}

void loop() {  
  
  switch(z){
  case 'q':
    M1Forward();
    break;
  case 'w':
    M1Reverse();
    break;
  case 'e':
    M2Forward();
    break;
  case 't':
    M2Reverse();
    break;
  case 'a':
    M3Forward();
    break;
  case 's':
    M3Reverse();
    break;
  case 'd':
    M4Forward();
    break;
  case 'g':
    M4Reverse();
    break;
  case 'z':
    forward();
    break;
  case 'x':
    reverse();
    break;
  case 'r':
    reset();
    break;
  case 'f':
    firmware();
    break;
  case 'c':
    rotateccw();
    break;
  case 'v':
    rotatecw();
    break;
  case 'h':
    resetBase();
    break;
  case '1':
    delaytype = delay1;
  case '2':
    delaytype = delay2;
  case '3':
    delaytype = delay3;
  case '4':
    delaytype = delay4;
  case '5':
    delaytype = delay5;
  default:
    safetyOff();
  }  
  
  irdetection();
  
  delay(10);
}

void irdetection()
{
  distance=analogRead(irpin); // Interface with the Sharp IR Sensor
  if (distance<=575&&distance>=425) // Detecting objects within roughly 10cm
  {
     if(z == 'z'){
        reset();
        reverse();
        delay(1000);
        rotatecw();
        delay(1000);
        forward();
     } else if(z == 'x'){
        reset();
        forward();
        delay(1000);
        rotateccw();
        delay(1000);
        reverse();
     }
  }
}


