#include <WString.h>
#include <AFMotor.h>
#include <NewSoftSerial.h>

AF_Stepper motorz(48, 1);

#define rxPin 10
#define txPin 9
#define ledPin 13

NewSoftSerial mySerial(rxPin, txPin);

String inString = String(50);
String units = String(2);
String zstr = String(10);
float zstring;

float posz = min(posz, 0);

float targetz;

float linez;

float DZ;

float dz;

float stepz = 80; // # of steps per mm

boolean command;
boolean zmark;
int type;
byte pinState = 0;
float scale = 1;
int zdirection = 1;

float feedRate = 80;

void setup() {
  Serial.begin(9600);
  motorz.setSpeed(60);
  delay (1000);
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  mySerial.begin(9600);
  inString = "";
}

void loop() {

  AcquireXYZ();
  if (command == true){
    DrawZ();
  }
  CheckArrive();
}

void AcquireXYZ(){
  if(mySerial.available() > 0) {

    char inChar = mySerial.read();

    if (inChar == '#'){
      Serial.print("Sending ");
      Serial.println(inString);

      char firstChar = inString.charAt(0);

      if (firstChar == '@'){
        GCodeParse();
      }

      else{
      }
      inString = "";
    }
    else{
      inString += inChar;
    }
  }
}

void GCodeParse(){

  type = 1;
  if (inString.charAt(0) == '@'){

    Serial.println("in");

    int startcharloc = 0; //find where the @ code starts
    int endcharloc = inString.length(); //find where the # code starts

    startcharloc = startcharloc + 1;
    endcharloc = endcharloc - 1;
    zstr = inString.substring(startcharloc, endcharloc);

    char tzstr[10];

    zstr.toCharArray(tzstr, 10);

    zstring = atof(tzstr);

    // to be able to send the original value, it was multiplied 
    // by 100 so we divide here to get our value
    zstring = zstring / 10;

    targetz = zstring * scale;

    DZ = targetz - posz;
    linez = posz;
    delay (1000);
    command = true;
  };
}

void DrawZ(){
  dz = feedRate;
  if (DZ > 0) {
    if (posz < targetz ) {
      motorz.step(dz, BACKWARD, SINGLE);
      posz = posz + dz / stepz;
      report();
    }
  }
  else {
    if (posz > targetz ){
      motorz.step(dz, FORWARD, SINGLE);
      posz = posz - dz / stepz;
      report();
    }
  }
  DZ = targetz - posz; 
}

void report(){
  Serial.print ("Z:");
  Serial.println (posz);
  Serial.print("\t");
  Serial.print ("targetZ:");
  Serial.println (targetz);
  Serial.print ("\n");
}

void CheckArrive(){
  //Serial.println(abs(targetz-posz));

  if (abs(targetz-posz) <= 0.01 && command == true){
    command = false;
    Serial.print("*");
  } 
}



