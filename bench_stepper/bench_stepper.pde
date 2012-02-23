// Adafruit Motor shield library
// copyright Adafruit Industries LLC, 2009
// this code is public domain, enjoy!

#include <AFMotor.h>

AF_Stepper motor1(48, 1);
AF_Stepper motor2(48, 2);

// constants won't change. They're used here to 
// set pin numbers:
const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin =  13;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status
int YDIR = BACKWARD;

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Stepper test!");

  motor1.setSpeed(200);  // 200 rpm 
  motor2.setSpeed(200);  // 200 rpm 

  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);       
}

void loop() {
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (buttonState == HIGH) {     
    // turn LED on:    
    digitalWrite(ledPin, HIGH);  
  } 
  else {
    // turn LED off:
    digitalWrite(ledPin, LOW); 
  }

  if(Serial.available()){
    char c = Serial.read();

    switch(c){
    case 'f':
      if(buttonState == HIGH && YDIR == BACKWARD){
        Serial.println("Go forward 100");
        motor1.step(100, FORWARD, SINGLE);
      } 
      else if(buttonState == LOW) {
        Serial.println("Go forward 100");
        motor1.step(100, FORWARD, SINGLE);  
        YDIR = FORWARD;
      }
      break;
    case 'b':
      if(buttonState == HIGH && YDIR == FORWARD){
        Serial.println("Go back 100");
        motor1.step(100, BACKWARD, SINGLE);
      } 
      else if(buttonState == LOW) {
        Serial.println("Go back 100");
        motor1.step(100, BACKWARD, SINGLE);  
        YDIR = BACKWARD;
      }
      break;    
    case 'g':
      if(buttonState == HIGH && YDIR == BACKWARD){
        Serial.println("Go forward 100");
        motor2.step(100, FORWARD, SINGLE);
      } 
      else if(buttonState == LOW) {
        Serial.println("Go forward 100");
        motor2.step(100, FORWARD, SINGLE);  
        YDIR = FORWARD;
      }
      break;
    case 'n':
      if(buttonState == HIGH && YDIR == FORWARD){
        Serial.println("Go back 100");
        motor2.step(100, BACKWARD, SINGLE);
      } 
      else if(buttonState == LOW) {
        Serial.println("Go back 100");
        motor2.step(100, BACKWARD, SINGLE);  
        YDIR = BACKWARD;
      }
      break;

    }
  }
  delay(1);
}







