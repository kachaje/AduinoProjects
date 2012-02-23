//Created August 23 2006
//Heather Dewey-Hagborg
//http://www.arduino.cc

#include <ctype.h>

#define bit9600Delay 104  
#define halfBit9600Delay 42
#define bit4800Delay 188 
#define halfBit4800Delay 94 

byte rx = 6;
byte tx = 7;
byte SWval;

void setup() {
  Serial.begin(9600);
  pinMode(rx,INPUT);
  pinMode(tx,OUTPUT);
  digitalWrite(tx,HIGH);
  digitalWrite(13,HIGH); //turn on debugging LED
  
  SWprint('h');  //debugging hello
  SWprint('i');
  
  SWprint('a');
  SWprint('b');
  SWprint('c');
  SWprint('d');
  SWprint('e');
  SWprint('f');
  SWprint('g');
  SWprint('h');
  SWprint('i');
  SWprint('j');
  SWprint('k');
  SWprint('l');
  SWprint('m');
  SWprint('n');
  SWprint('o');
  SWprint('p');
  SWprint('q');
  SWprint('r');
  SWprint('s');
  SWprint('t');
  SWprint('u');
  SWprint('v');
  SWprint('w');
  SWprint('x');
  SWprint('y');
  SWprint('z');
  
  //SWprint('hello world');
  
  //Serial.println(byte(int('h')));
  
  //SWprint(10); //carriage return
}

void SWprint(byte data)
{
  byte mask;
  boolean found;
  
  Serial.println(data, BIN);
  
  //startbit
  digitalWrite(tx,LOW);
  delayMicroseconds(bit9600Delay);
  /*for (mask = 0x01; mask>0; mask <<= 1) {
   if (data & mask){ // choose bit
   digitalWrite(tx,HIGH); // send 1
   }
   else{
   digitalWrite(tx,LOW); // send 0
   }
   delayMicroseconds(bit9600Delay);
   }*/

  mask = 0x01;
  found = false;
  while (found == false) {
    if (data & mask){ // choose bit
      digitalWrite(tx,HIGH); // send 1
    }
    else{
      digitalWrite(tx,LOW); // send 0
    }
    delayMicroseconds(bit9600Delay);

    if(mask == 0){
       found = true; 
    }
    mask <<= 1;
  } 

  //digitalWrite(tx, LOW);
  //delayMicroseconds(bit9600Delay);
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
    for (int offset = 0; offset < 8; offset++) {
      delayMicroseconds(bit9600Delay);
      val |= digitalRead(rx) << offset;
    }
    //wait for stop bit + extra
    delayMicroseconds(bit9600Delay); 
    delayMicroseconds(bit9600Delay);
    Serial.println(val, BIN);
    return val;
  }
}

void loop()
{
  SWval = SWread(); 
  //SWprint(toupper(SWval));
  SWprint(SWval);
}


