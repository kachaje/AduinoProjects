#include <NewSoftSerial.h>

NewSoftSerial mySerial(3, 4);

void setup(){
  Serial.begin(19200);
  mySerial.begin(19200);
}

void loop(){   
  if (mySerial.available()) {
      Serial.print((char)mySerial.read());
      delay(10);
  }
}
