#include <Wire.h>
#include <AFMotor.h>


AF_Stepper motor1(200, 1);
AF_Stepper motor2(200, 2);

//volatile int state = 0;
int state = 0;

void setup() {
  Wire.begin(1); // join i2c bus (address optional for master)
  Wire.onReceive(receiveEvent); // register event
   
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Stepper test!");

  motor1.setSpeed(60);  // 10 rpm   
  motor2.setSpeed(60);  // 10 rpm   

  motor1.step(1000, FORWARD, SINGLE); 
  motor2.step(1000, FORWARD, SINGLE); 
  motor1.release();
  motor2.release();
  // attachInterrupt(0, changeState, RISING);

  delay(1000);
}

void loop() 
{  
  switch(state){
  case 1:
    motor1_forward();
    break;
  case 2:
    motor1_reverse();
    break;
  case 3:
    motor2_forward();
    break;
  case 4:
    motor2_reverse();
    break;
  }  
  //delay(5);
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int intValue) {
  state = Wire.receive();    // receive byte as an integer
}

void motor1_forward(){
    state = 0;
    motor1.step(5, FORWARD, DOUBLE); 
    motor1.release();
    //delay(5000);
}

void motor1_reverse(){
    state = 0;
    motor1.step(5, BACKWARD, DOUBLE); 
    motor1.release();
    //delay(5000);
}

void motor2_forward(){
    state = 0;
    motor2.step(5, FORWARD, DOUBLE); 
    motor2.release();
    //delay(5000);
}

void motor2_reverse(){
    state = 0;
    motor2.step(5, BACKWARD, DOUBLE); 
    motor2.release();
    //delay(5000);
}
