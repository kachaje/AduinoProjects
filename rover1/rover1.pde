/*
Arduino Code
The following demo code is complied in Arduino (www.arduino.cc) and uses two
subroutines. You are free to copy/paste the code into the Arduino compiler.
Ensure the motor controller is connected properly before use.
The serial data line of the motor controller should be connected to pin 1 (Tx) on the
Arduino.
*/
int servopulse1 = 1250; //test servo tilt position (0deg =0 to 180deg =1500)
int servopulse2 = 1500; //test servo pan position (0deg =0 to 180deg =1500)
int servopin1 = 9; //yellow wire from servo 1 to digital pin 9
int servopin2 = 10; //yellow wire from servo 2 to digital pin 10
int motor_reset = 2; //motor reset pin connected to digital pin 2
void setup()
{
pinMode(motor_reset, OUTPUT); //sets pin as output
pinMode(servopin1, OUTPUT); //sets pin as output
pinMode(servopin2, OUTPUT); //sets pin as output
//digitalWrite(motor_reset, LOW); //do not activate motor driver
Serial.begin(9600); //communication at 9600 baud
// reset motor controller
digitalWrite(motor_reset, LOW);
delay(50);
digitalWrite(motor_reset, HIGH);
delay(50); // reset delay
}
void loop()
{
servoposition(); // subroutine servoposition
motorcontrol(); // subroutine motor control
}
//subroutine servoposition
void servoposition()
{
digitalWrite(servopin1, HIGH); // Start the pulse to servo 1
delayMicroseconds(servopulse1); // Length of the pulse sets the servo position
digitalWrite(servopin1, LOW); // Stop the pulse
digitalWrite(servopin2, HIGH); // Start the pulse to servo 2
delayMicroseconds(servopulse2); // Length of the pulse sets the motor position
digitalWrite(servopin2, LOW); // Stop the pulse
}
//subroutine motor control
void motorcontrol()
{
//left motor
unsigned char buff1[6];
buff1[0]=0x80; //start byte specific to Pololu motor controller
buff1[1]=0x00; //Device type byte specific to Pololu controller
buff1[2]=0x01; //Motor number and direction byte; motor one =00,01
buff1[3]=0x7F; //Motor speed "0 to 128" (ex 100 is 64 in hex)
for(int i=0;i<4;i++) {Serial.print(buff1[i],BYTE);}
//right motor
unsigned char buff2[6];
buff2[0]=0x80; //start byte - do not change
buff2[1]=0x00; //Device type byte
buff2[2]=0x03; //Motor number and direction byte; motor two=02,03
buff2[3]=0x7F; //Motor speed "0 to 128" (ex 100 is 64 in hex)
for(int i=0;i<4;i++) {Serial.print(buff2[i],BYTE);}
}
