#include <Wire.h>
#include <AFMotor.h>


AF_Stepper motor3(200, 1);
int state = 0;

void setup() {
  Wire.begin(2);                // join i2c bus with address #4
  Wire.onReceive(receiveEvent); // register event
    
  motor3.setSpeed(50);  // 10 rpm   

  motor3.step(100, FORWARD, SINGLE); 
  motor3.release();
  
  Serial.begin(9600);           // start serial for output
  // attachInterrupt(0, changeState, RISING);
  
  delay(1000);
}

void loop() {
  if(state == 0){
    Serial.println("FORWARD, SINGLE");
    motor3.step(1, FORWARD, SINGLE); 
  }
  else if(state == 1){
    Serial.println("BACKWARD, SINGLE");
    motor3.step(1, BACKWARD, SINGLE);
  }
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int intValue) {
  motor3.release();
  state = Wire.receive();    // receive byte as an integer
}

void changeState()
{  
  motor3.release();
  if(state == 1){
    state = 2;
  } else if(state == 2){
    state = 0;
  } else {
    state = !state; 
  }
}
