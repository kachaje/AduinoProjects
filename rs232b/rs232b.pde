//Created August 23 2006
//Heather Dewey-Hagborg
//http://www.arduino.cc

#include <ctype.h>

#define bit9600Delay 104  
#define halfBit9600Delay 42
#define bit4800Delay 188 
#define halfBit4800Delay 94 

byte rx = 0;
byte tx = 1;
byte SWval;

void setup() {
  Serial.begin(9600);
  pinMode(rx,INPUT);
  pinMode(tx,OUTPUT);
  digitalWrite(tx,HIGH);
  digitalWrite(13,HIGH); //turn on debugging LED
    
  /*SWprint('h');  //debugging hello
  SWprint('i');
    
  SWprint(0x0D); //carriage return*/
  
  //SWsplit("arduino");
  SWprint(0x0D);
  SWprint(0x0A); 
  SWprint('N');
  SWprint(0x0D);
  SWprint(0x0A);
  SWsplit("A40,50,0,2,1,1,N,\"Gerry'S World!\"");
  SWprint(0x0D);
  SWprint(0x0A); 
  SWsplit("P1");
  SWprint(0x0D);
  SWprint(0x0A);
  
}

void SWsplit(char sentence[])
{
    Serial.println(sentence);
    
    int i = 0;
    for(i = 0; i < strlen(sentence); i++){
      SWprint(sentence[i]);
      Serial.println(sentence[i]);
    }
}

void SWprint(byte data)
{
  Serial.println(data, BIN);
  byte mask;
  //startbit
  digitalWrite(tx,LOW);
  delayMicroseconds(bit9600Delay);

  //staff a zero at the beginning  
  //digitalWrite(tx,LOW);
  //delayMicroseconds(bit9600Delay);
  
  int zeros = 0;
  int ones = 0;
  int last = 0;
  
  for (mask = 0x01; mask>0; mask <<= 1) {
    
    //Serial.println(mask, BIN);
    
    if (data & mask){ // choose bit
     digitalWrite(tx,HIGH); // send 1
     ones += 1;
     last = 1;
    }
    else{
     digitalWrite(tx,LOW); // send 0
     zeros += 1;
     last = 0;
    }
    
    delayMicroseconds(bit9600Delay);
  }
  //Serial.println(ones);
  //Serial.println(zeros);
  //Serial.println(last);
    
  //stop bit
  digitalWrite(tx, HIGH);
  delayMicroseconds(bit9600Delay);
}

int SWread()
{
  byte val = 0;
  while (digitalRead(rx));
  //wait for start bit
  if (digitalRead(rx) == LOW) {
    delayMicroseconds(halfBit9600Delay);
    for (int offset = 0; offset < 7; offset++) {
     delayMicroseconds(bit9600Delay);
     val |= digitalRead(rx) << offset;
    }
    //wait for stop bit + extra
    delayMicroseconds(bit9600Delay); 
    delayMicroseconds(bit9600Delay);
    return val;
  }
}

void loop()
{
    SWval = SWread(); 
    SWprint(toupper(SWval));
}

