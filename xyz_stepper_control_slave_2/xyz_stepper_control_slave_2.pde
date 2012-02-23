#include <Wire.h>
#include <AFMotor.h>


AF_Stepper motor3(200, 1);
int state = 0;

void setup() {
  Wire.begin(2);                // join i2c bus with address #4
  Wire.onReceive(receiveEvent); // register event

    motor3.setSpeed(60);  // 10 rpm   

  motor3.step(1000, FORWARD, SINGLE); 
  motor3.release();

  Serial.begin(9600);           // start serial for output
  // attachInterrupt(0, changeState, RISING);

  delay(1000);
}

void loop() 
{  
  switch(state){
  case 5:
    forward();
    break;
  case 6:
    reverse();
    break;
  }  
  //delay(5);
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int intValue) {
  state = Wire.receive();    // receive byte as an integer
}

void forward(){
    state = 0;
    motor3.step(5, FORWARD, MICROSTEP); 
    motor3.release();
    //delay(5000);
}

void reverse(){
    state = 0;
    motor3.step(5, BACKWARD, MICROSTEP); 
    motor3.release();
    //delay(5000);
}
