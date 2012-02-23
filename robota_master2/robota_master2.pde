// Wire Master Writer
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Writes data to an I2C/TWI slave device
// Refer to the "Wire Slave Receiver" example for use with this

// Created 29 March 2006

#include <Wire.h>

#define LED_OUT 13

int motor_reset = 2; //motor reset pin connected to digital pin 2

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  pinMode(LED_OUT, OUTPUT);
  digitalWrite(LED_OUT, LOW);
  pinMode(motor_reset, OUTPUT); //sets pin as output
  digitalWrite(motor_reset, LOW); //do not activate motor driver
  Serial.begin(9600);
  // reset motor controller
  digitalWrite(motor_reset, LOW);
  delay(50);
  digitalWrite(motor_reset, HIGH);
  delay(50); // reset delay
  Serial.println("Robota Version 0.1a");
}

void loop()
{
  while (!Serial.available()); // wait for input

  char z = Serial.read();

  Serial.println(z);
  
  switch(z){
  case 'j':
    Serial.println("forward");
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
    Serial.println("bagalazi!");
    Wire.beginTransmission(4); // transmit to device #4
    Wire.send(z);              // sends one byte  
    Wire.endTransmission();    // stop transmitting

    motorstop();        
    delay(1000);
  }

  Serial.println(z);

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


