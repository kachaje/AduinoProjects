#include <Wire.h>

//volatile int state = 0;
int state = 0;
const int ledPin =  9;      // the number of the LED pin
const int buttonPin = 2;     // the number of the pushbutton pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status
char c = '?';

void setup() {
  Wire.begin(); // join i2c bus (address optional for master)

  pinMode(ledPin, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);   
  
  Serial.begin(9600);           // start serial for output
  attachInterrupt(0, lowState, FALLING);
  attachInterrupt(0, highState, RISING);

  delay(1000);
}

void loop() {
  if(state == 1){
    digitalWrite(ledPin, HIGH);
  } else if(state == 0) {
    digitalWrite(ledPin, LOW);
  }
  
  //read in characters if we got them.
  if (Serial.available())
  {
    c = Serial.read();

    switch(c){
    case '1':
      Serial.println(c);
    
      Wire.beginTransmission(1); // transmit to device #4
      Wire.send(1);              // sends one byte  
      Wire.endTransmission();    // stop transmitting
      break;
    case '2':
      Serial.println(c);
    
      Wire.beginTransmission(1); // transmit to device #4
      Wire.send(2);              // sends one byte  
      Wire.endTransmission();    // stop transmitting
      break;
    case '3':
      Serial.println(c);
    
      Wire.beginTransmission(1); // transmit to device #4
      Wire.send(3);              // sends one byte  
      Wire.endTransmission();    // stop transmitting
      break;
    case '4':
      Serial.println(c);
    
      Wire.beginTransmission(1); // transmit to device #4
      Wire.send(4);              // sends one byte  
      Wire.endTransmission();    // stop transmitting
      break;
    case '5':
      Serial.println(c);
    
      Wire.beginTransmission(2); // transmit to device #4
      Wire.send(5);              // sends one byte  
      Wire.endTransmission();    // stop transmitting
      break;
    case '6':
      Serial.println(c);
    
      Wire.beginTransmission(2); // transmit to device #4
      Wire.send(6);              // sends one byte  
      Wire.endTransmission();    // stop transmitting
      break;
    } 
  }
  //delay(100);

}

void lowState()
{   
  state = 0;
}

void highState()
{   
  state = 0;
}






