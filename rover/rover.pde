/*
Sample code for RobotShop Rover v1.0
 www.RobotShop.com
 This code uses subroutines to explore all aspects of the RobotShop Rover, including the
 motors, motor controller, IR Sensor and Pan/Tilt. The Rover will proceed in a straight
 line and once it encounters an obstacle will stop, flash the LED, move the pan and tilt to a
 new location, reverse, rotate ~90 degrees, re-center the pan and tilt and proceed until the
 next obstacle. We encourage you to experiment with and improve the code.
 Note 1: The kit does not include a servo controller; however, the pan and tilt can be
 controlled directly from the Arduino. A servo needs to be refreshed at least once every
 500ms, though when working directly off the Arduino, it is difficult to refresh the servo
 especially if the delay() function is used. The system works best when using 1.2V
 rechargeable batteries (instead of 1.5V alkaline) as the servos retain their last position due
 to friction. For proper control of the pan and tilt, consider the RB-Pol-18 “Pololu Micro
 Serial 8 Servo Controller”.
 Note 2: The motor controller manual specifies that the controller should be OFF when
 uploading code to the microcontroller. Use one of the included ON/OFF switches to
 ensure the controller is OFF when uploading code (or physically disconnect the Tx/Rx
 wires to the controller). You only need to do this when uploading new code.
 Note 3: As with any electro-mechanical system, the ideal choice is to use high capacity
 rechargeable batteries. The rover should last for roughly 30minutes depending on many
 factors (terrain, incline, speed of motors). The 9V battery ONLY powers the Arduino
 microcontroller. If the system is behaving erratically, check the battery power; a
 minimum of 9V is required by the Arduino.
 Note 4: Triple check that all wires are properly connected before loading the code. Test
 each system individually by commenting the code using two backslashes.
 */
 
int servopulse1 = 1250; //test servo tilt position (0 to 180)
int servopulse2 = 1550; //test servo pan position (0 to 180)
int servopin1 = 9; //analog pin 1=15
int servopin2 = 10; //analog pin 3=17
int motor_reset = 2; //digital pin 2 assigned to motor reset
int irpin = 0;
int distance = 0;
int ledpin = 13;

void setup()
{
  pinMode(motor_reset, OUTPUT);
  pinMode(servopin1, OUTPUT);
  pinMode(servopin2, OUTPUT);
  Serial.begin(9600);
  digitalWrite(motor_reset, LOW);
  delay(50);
  digitalWrite(motor_reset, HIGH);
  delay(50);
  // reset motor controller
}
void loop()
{
  servoposition();
  delay(20);
  digitalWrite(servopin1, LOW);
  digitalWrite(servopin2, LOW);
  motorforward();
  irdetection();
}
//subroutine servoposition
void servoposition()
{
  for(int i=1; i<=20; i++) // Ensures the servos reach their final position
  {
    digitalWrite(servopin1, HIGH); // Turn the L motor on
    delayMicroseconds(servopulse1); // Length of the pulse sets the motor position
    digitalWrite(servopin1, LOW); // Turn the L motor off
    delay(20);
    digitalWrite(servopin2, HIGH); // Turn the L motor on
    delayMicroseconds(servopulse2); // Length of the pulse sets the motor position
    digitalWrite(servopin2, LOW); // Turn the L motor off
    delay(20);
  }
}
void irdetection()
{
  distance=analogRead(irpin); // Interface with the Sharp IR Sensor
  if (distance<=575&&distance>=425) // Detecting objects within roughly 10cm
  {
    motorstop(); // stop the rover
    ledwarning(); // light up the LED for 1 second
    delay(1000);
    servopulse1=1250; // move the pan/tilt
    servopulse2=2000;
    servoposition(); // refresh the servos
    delay(500);
    motorreverse(); // reverse the motors for 1 second
    delay(1000);
    motorstop(); // stop the motors
    delay(1000); // wait 1 second
    rotateccw(); // rotate for 2 seconds
    delay(2000);
    motorstop(); // stop the motors
    delay(1000);
    servopulse1=550; // move the servos
    servopulse2=1500;
    servoposition();
    delay(1000);
  }
}
void ledwarning()
{
  digitalWrite(ledpin, HIGH); // sets the LED on
  delay(1000);
  digitalWrite(ledpin, LOW); // sets the LED off
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

