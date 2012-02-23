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
int pos = 0;
int motor_reset = 2; //digital pin 2 assigned to motor reset
char z;

int irpin = 0;
int forwardpin = 12;
int reversepin = 13;
int distance = 0;

void M1Forward(){
  motorSet1.motor0Forward(speed);
  Serial.println("M1 grab @ ");
  
  double v = analogRead(TxPinSet1);
  
  v = (4.83 * v/1024) * 12.0131291;
  
  Serial.println(v);
  
  delay(150);
  motorSet1.begin();
}

void M1Reverse(){
  motorSet1.motor0Reverse(speed);
  Serial.println("M1 release @ ");
  
  double v = analogRead(TxPinSet1);
  
  v = (4.83 * v/1024) * 12.0131291;
  
  Serial.println(v);
  
  delay(150);
  motorSet1.begin();
}

void M2Forward(){
  motorSet1.motor1Forward(speed);
  Serial.println("M2 forward");
}

void M2Reverse(){
  motorSet1.motor1Reverse(speed);
  Serial.println("M2 reverse");
}

void M3Forward(){
  motorSet2.motor0Forward(speed);
  Serial.println("M3 forward");
}

void M3Reverse(){
  motorSet2.motor0Reverse(speed);
  Serial.println("M3 reverse");
}

void M4Forward(){
  motorSet2.motor1Forward(speed);
  Serial.println("M4 forward");
}

void M4Reverse(){
  motorSet2.motor1Reverse(speed);
  Serial.println("M4 reverse");
}

void M5Forward(){
  motorSet3.motor0Forward(speed);
  Serial.println("M5 forward");
}

void M5Reverse(){
  motorSet3.motor0Reverse(speed);
  Serial.println("M5 reverse");
}

void safetyOff(){
  motorSet1.stopBothMotors();
  motorSet2.stopBothMotors();
  motorSet3.stopBothMotors();
  Serial.println("safety Off");
}

void reset(){
  Serial.println("Reset");
  motorSet1.begin();
  motorSet2.begin();
  motorSet3.begin();
}

void setup() {  
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

  // base motors
  pinMode(motor_reset, OUTPUT);
  digitalWrite(motor_reset, LOW);
  delay(50);
  digitalWrite(motor_reset, HIGH);
  delay(50);
  // reset motor controller
}

void firmware(){
  Serial.println(motorSet1.getFirmwareVersion());
  Serial.println(motorSet2.getFirmwareVersion());
  Serial.println(motorSet3.getFirmwareVersion());
}

void loop() {
  while (!Serial.available()); // wait for input

  z = Serial.read();

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
    M5Forward();
    break;
  case 'x':
    M5Reverse();
    break;
  case 'r':
    reset();
    break;
  case 'f':
    firmware();
    break;
  case 'j':
    motorforward();
    break;
  case 'k':
    motorreverse();
    break;
  case 'h':
    motorstop();
    break;
  case 'c':
    rotateccw();
    break;
  case 'v':
    rotatecw();
    break;
  default:
    safetyOff();
  }  
  irdetection();
  // digitalWrite(LedPin,digitalRead(LedPin) ? LOW : HIGH);
}

void irdetection()
{
  distance=analogRead(irpin); // Interface with the Sharp IR Sensor
  
  Serial.println(distance);
  
  if (distance<=575&&distance>=425) // Detecting objects within roughly 10cm
  {
     if(z == 'j'){
        reset();
        motorreverse();
        delay(1000);
        rotatecw();
        delay(1000);
        motorforward();
     } else if(z == 'k'){
        reset();
        motorforward();
        delay(1000);
        rotateccw();
        delay(1000);
        motorreverse();
     }
  }
}


//subroutine motor forward
void motorforward()
{
  //left motor
  unsigned char buff1[6];
  buff1[0]=0x80; //start byte - do not change
  buff1[1]=0x00; //Device type byte
  buff1[2]=0x00; //Motor number and direction byte; motor one =00,01
  buff1[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff1[i], BYTE);
  }
  //right motor
  unsigned char buff2[6];
  buff2[0]=0x80; //start byte - do not change
  buff2[1]=0x00; //Device type byte
  buff2[2]=0x02; //Motor number and direction byte; motor two=02,03
  buff2[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff2[i], BYTE);
  }
}
//subroutine reverse at half speedd
void motorreverse()
{
  //left motor
  unsigned char buff3[6];
  buff3[0]=0x80; //start byte - do not change
  buff3[1]=0x00; //Device type byte
  buff3[2]=0x01; //Motor number and direction byte; motor one =00,01
  buff3[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff3[i], BYTE);
  }
  //right motor
  unsigned char buff4[6];
  buff4[0]=0x80; //start byte - do not change
  buff4[1]=0x00; //Device type byte
  buff4[2]=0x03; //Motor number and direction byte; motor two=02,03
  buff4[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff4[i], BYTE);
  }
}
//Motor all stop
void motorstop()
{
  //left motor
  unsigned char buff3[6];
  buff3[0]=0x80; //start byte - do not change
  buff3[1]=0x00; //Device type byte
  buff3[2]=0x00; //Motor number and direction byte; motor one =00,01
  buff3[3]=0x00; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff3[i], BYTE);
  }
  //right motor
  unsigned char buff4[6];
  buff4[0]=0x80; //start byte - do not change
  buff4[1]=0x00; //Device type byte
  buff4[2]=0x02; //Motor number and direction byte; motor two=02,03
  buff4[3]=0x00; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff4[i], BYTE);
  }
}
void rotateccw()
{
  //left motor
  unsigned char buff1[6];
  buff1[0]=0x80; //start byte - do not change
  buff1[1]=0x00; //Device type byte
  buff1[2]=0x01; //Motor number and direction byte; motor one =00,01
  buff1[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff1[i], BYTE);
  }
  //right motor
  unsigned char buff2[6];
  buff2[0]=0x80; //start byte - do not change
  buff2[1]=0x00; //Device type byte
  buff2[2]=0x02; //Motor number and direction byte; motor two=02,03
  buff2[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff2[i], BYTE);
  }
}


void rotatecw()
{
  //left motor
  unsigned char buff1[6];
  buff1[0]=0x80; //start byte - do not change
  buff1[1]=0x00; //Device type byte
  buff1[2]=0x00; //Motor number and direction byte; motor one =00,01
  buff1[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff1[i], BYTE);
  }
  //right motor
  unsigned char buff2[6];
  buff2[0]=0x80; //start byte - do not change
  buff2[1]=0x00; //Device type byte
  buff2[2]=0x03; //Motor number and direction byte; motor two=02,03
  buff2[3]=0x64; //Motor speed "0 to 128" (ex 100 is 64 in hex)
  for(int i=0; i<4; i++) {
    Serial.print(buff2[i], BYTE);
  }
}



