#include <AFMotor.h>


AF_Stepper motor1(200, 1);
AF_Stepper motor2(200, 2);

//volatile int state = 0;
int state = 0;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Stepper test!");

  motor1.setSpeed(50);  // 10 rpm   
  motor2.setSpeed(50);  // 10 rpm   

  motor1.step(100, FORWARD, SINGLE); 
  motor2.step(100, FORWARD, SINGLE); 
  motor1.release();
  motor2.release();
  attachInterrupt(0, changeState, RISING);

  delay(1000);
}

void loop() {
  if(state == 0){
    Serial.println("FORWARD, DOUBLE");
    motor1.step(1, FORWARD, DOUBLE); 

    Serial.println("BACKWARD2, DOUBLE");
    motor2.step(1, BACKWARD, DOUBLE);
  }
  else if(state == 1){
    Serial.println("FORWARD2, DOUBLE");
    motor2.step(1, FORWARD, DOUBLE); 

    Serial.println("BACKWARD1, DOUBLE");
    motor1.step(1, BACKWARD, DOUBLE);
  }
}

void changeState()
{  
  motor1.release();
  motor2.release();
  if(state == 1){
    state = 2;
  } else if(state == 2){
    state = 0;
  } else {
    state = !state; 
  }
  Serial.println(state);
}

