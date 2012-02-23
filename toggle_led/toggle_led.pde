
#define LedPin     13

void setup() {  
  Serial.begin(9600);
 
  Serial.println("Welcome to Shoe-Box Labs!"); 
  digitalWrite(LedPin, LOW);
}

void loop() {
  while (!Serial.available()); // wait for input

  char z = Serial.read();

  switch(z){
    case 'n': 
      digitalWrite(LedPin, HIGH);
      delay(1000);
      break;
    case 'f': 
      digitalWrite(LedPin, LOW);
      delay(1000);
      break;
  }
}
