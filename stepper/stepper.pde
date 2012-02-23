#include <AFMotor.h>


AF_Stepper motor1(200, 1);
AF_Stepper motor2(200, 2);

//volatile int state = 0;
int state = 0;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Stepper test!");

  motor1.setSpeed(10);  // 10 rpm   
  motor2.setSpeed(10);  // 10 rpm   

  motor1.step(100, FORWARD, SINGLE); 
  motor2.step(100, FORWARD, SINGLE); 
  motor1.release();
  motor2.release();
  attachInterrupt(0, changeState, RISING);

  delay(1000);
}

void loop() {
  if(state == 0){
    Serial.println("FORWARD, SINGLE");
    motor1.step(200, FORWARD, SINGLE); 

    Serial.println("BACKWARD, SINGLE");
    motor1.step(200, BACKWARD, SINGLE); 

    Serial.println("FORWARD, DOUBLE");
    motor1.step(200, FORWARD, DOUBLE); 

    Serial.println("BACKWARD, DOUBLE");
    motor1.step(200, BACKWARD, DOUBLE);

    Serial.println("FORWARD, INTERLEAVE");
    motor1.step(200, FORWARD, INTERLEAVE); 

    Serial.println("BACKWARD, INTERLEAVE");
    motor1.step(200, BACKWARD, INTERLEAVE); 

    Serial.println("FORWARD, MICROSTEP");
    motor1.step(200, FORWARD, MICROSTEP); 

    Serial.println("BACKWARD, MICROSTEP");
    motor1.step(200, BACKWARD, MICROSTEP); 
  }
  else if(state == 1){
    Serial.println("FORWARD2, SINGLE");
    motor2.step(200, FORWARD, SINGLE); 

    Serial.println("BACKWARD2, SINGLE");
    motor2.step(200, BACKWARD, SINGLE); 

    Serial.println("FORWARD2, DOUBLE");
    motor2.step(200, FORWARD, DOUBLE); 

    Serial.println("BACKWARD2, DOUBLE");
    motor2.step(200, BACKWARD, DOUBLE);

    Serial.println("FORWARD2, INTERLEAVE");
    motor2.step(200, FORWARD, INTERLEAVE); 

    Serial.println("BACKWARD2, INTERLEAVE");
    motor2.step(200, BACKWARD, INTERLEAVE); 

    Serial.println("FORWARD2, MICROSTEP");
    motor2.step(200, FORWARD, MICROSTEP); 

    Serial.println("BACKWARD2, MICROSTEP");
    motor2.step(200, BACKWARD, MICROSTEP); 
  }
}

void changeState()
{  
  motor1.release();
  motor2.release();
  state = !state; 
  Serial.println(state);
}

