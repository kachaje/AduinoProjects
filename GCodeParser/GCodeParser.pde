#include <WString.h>
#include <AFMotor.h>
#include <SoftwareSerial.h>

AF_Stepper motorx(48, 2);
AF_Stepper motory(48, 1);

#define rxPin 9
#define txPin 10
#define ledPin 13

SoftwareSerial mySerial =  SoftwareSerial(rxPin, txPin);

String inString = String(50);
String units = String(2);
String xstr = String(10);
String ystr = String(10);
String zstr = String(10);

float xstring;
float ystring;
float zstring;

float posx;
float posy;
float posz = min(posz, 0);

float targetx;
float targety;
float targetz;

float linex;
float liney;
float linez;

float DX;
float DY;
float DZ;

float dx;
float dy;
float dz;

float stepx = 80; // # of steps per mm
float stepy = 80;
float stepz = 80;

boolean command;
boolean zmark;
int type;
byte pinState = 0;
float scale = 1;
int zdirection = 1;

float feedRate = 80;

void setup() {
  Serial.begin(9600);
  motorx.setSpeed(60);
  motory.setSpeed(60);
  delay (1000);
  pinMode(rxPin, INPUT);
  pinMode(txPin, OUTPUT);
  mySerial.begin(9600);
  command = false;
  inString = "";
}

void AcquireXYZ(){
  if(Serial.available() > 0) {

    char inChar = Serial.read();

    if (inChar == '!'){
      Serial.print("Sending ");
      Serial.println(inString);
      
      char firstChar = inString.charAt(0);

      if (firstChar == 'G'){
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

  if (inString.startsWith("G0")){
    type = 0;
  }

  if (inString.startsWith("G1")){
    type = 1;
    if (inString.indexOf("X") && inString.indexOf("Y") && inString.indexOf("Z")){
      int xcharloc = inString.indexOf('X'); //find where the X code starts
      int ycharloc = inString.indexOf('Y'); //find where the Y code starts
      int zcharloc = inString.indexOf('Z'); //find where the Z code starts

      xcharloc = xcharloc + 1;
      ycharloc = ycharloc - 1;
      xstr = inString.substring(xcharloc, ycharloc);
      ycharloc = ycharloc + 1;

      ycharloc = ycharloc + 1;
      zcharloc = zcharloc - 1;
      ystr = inString.substring(ycharloc, zcharloc);
      zcharloc = zcharloc + 1;

      int zlast = inString.length();
      zcharloc = zcharloc + 1;
      zstr = inString.substring(zcharloc, zlast);
      zcharloc = zcharloc - 1;

      char txstr[10];
      char tystr[10];
      char tzstr[10];

      xstr.toCharArray(txstr, 10);
      ystr.toCharArray(tystr, 10);
      zstr.toCharArray(tzstr, 10);

      xstring = atof(txstr);
      ystring = atof(tystr);
      zstring = atof(tzstr);

      targetx = xstring * scale;
      targety = ystring * scale;
      targetz = -1 * zstring * zdirection * scale;

      DX = targetx - posx;
      DY = targety - posy;
      DZ = targetz - posz;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
    if (inString.indexOf("X") && inString.indexOf("Y") && !inString.indexOf("Z")){
      int xcharloc = inString.indexOf('X'); //find where the X code starts
      int ycharloc = inString.indexOf('Y'); //find where the Y code starts

      xcharloc = xcharloc + 1;// Code for finding what X is in the code
      ycharloc = ycharloc - 1;
      xstr = inString.substring(xcharloc, ycharloc);
      ycharloc = ycharloc + 1;

      int ylast = inString.length();
      ycharloc = ycharloc + 1;
      ystr = inString.substring(ycharloc, ylast);
      ycharloc = ycharloc - 1;

      char txstr[10];
      char tystr[10];

      xstr.toCharArray(txstr, 10);
      ystr.toCharArray(tystr, 10);

      xstring = atof(txstr);
      ystring = atof(tystr);

      targetx = xstring * scale;
      targety = ystring * scale;
      targetz = posz;//posz + DZ;

      DX = targetx - posx;
      DY = targety - posy;
      DZ = 0;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
    if (inString.indexOf("X") && !inString.indexOf("Y") && inString.indexOf("Z")){
      int xcharloc = inString.indexOf('X');
      int zcharloc = inString.indexOf('Z');

      xcharloc = xcharloc + 1;
      zcharloc = zcharloc - 1;
      xstr = inString.substring(xcharloc, zcharloc);
      zcharloc = zcharloc + 1;

      int zlast = inString.length();
      zcharloc = zcharloc + 1;
      zstr = inString.substring(zcharloc, zlast);
      zcharloc = zcharloc - 1;

      char txstr[10];
      char tzstr[10];

      xstr.toCharArray(txstr, 10);
      zstr.toCharArray(tzstr, 10);

      xstring = atof(txstr);
      zstring = atof(tzstr);

      xstring = atof(txstr);
      zstring = atof(tzstr);

      targetx = xstring * scale;
      targety = posy;
      targetz = -1 * zstring * zdirection * scale;

      DX = targetx - posx;
      DY = 0;
      DZ = targetz - posz;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
    if (!inString.indexOf("X") && inString.indexOf("Y") && inString.indexOf("Z")){

      int ycharloc = inString.indexOf('Y');
      int zcharloc = inString.indexOf('Z');

      ycharloc = ycharloc + 1;
      zcharloc = zcharloc - 1;
      ystr = inString.substring(ycharloc, zcharloc);
      zcharloc = zcharloc + 1;

      int zlast = inString.length();
      zcharloc = zcharloc + 1;
      zstr = inString.substring(zcharloc, zlast);
      zcharloc = zcharloc - 1;

      char tystr[10];
      char tzstr[10];

      ystr.toCharArray(tystr, 10);
      zstr.toCharArray(tzstr, 10);

      ystring = atof(tystr);
      zstring = atof(tzstr);

      targetx = posx;
      targety = ystring * scale;
      targetz = -1 * zstring * zdirection * scale;

      DX = 0;
      DY = targety - posy;
      DZ = targetz - posz;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
    if (!inString.indexOf("X") && !inString.indexOf("Y") && inString.indexOf("Z")){


      int zcharloc = inString.indexOf('Z');

      int zlast = inString.length();
      zcharloc = zcharloc + 1;
      zstr = inString.substring(zcharloc, zlast);
      zcharloc = zcharloc - 1;

      char tzstr[10];

      zstr.toCharArray(tzstr, 10);

      zstring = atof(tzstr);

      targetx = posx;
      targety = posy;
      targetz = -1 * zstring * zdirection * scale;

      DX = 0;
      DY = 0;
      DZ = targetz - posz;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
    if (!inString.indexOf("X") && inString.indexOf("Y") && !inString.indexOf("Z")){
      int ycharloc = inString.indexOf('Y');
      ycharloc = ycharloc + 1;
      int ylast = inString.length();
      ystr = inString.substring(ycharloc, ylast);
      ycharloc = ycharloc - 1;

      char tystr[10];

      ystr.toCharArray(tystr, 10);

      ystring = atof(tystr);
      targetx = posx;
      targety = ystring * scale;
      targetz = posz;

      DX = 0;
      DY = targety - posy;
      DZ = 0;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
    if (inString.indexOf("X") && !inString.indexOf("Y") && !inString.indexOf("Z")){
      int xcharloc = inString.indexOf('X');

      int xlast = inString.length();
      xcharloc = xcharloc + 1;
      xstr = inString.substring(xcharloc, xlast);
      xcharloc = xcharloc - 1;

      char txstr[10];

      xstr.toCharArray(txstr, 10);

      xstring = atof(txstr);

      targetx = xstring * scale;
      targety = posy;
      targetz = posz;

      DX = targetx - posx;
      DY = 0;
      DZ = 0;
      linex = posx;
      liney = posy;
      delay (1000);
      command = true;
    };
  }

}
void plotting(){
  if (type == 1){

    if (DX == 0 && DY != 0){
      DrawY();
      posz = targetz;
      Reportz();
    }
    else if (DX != 0 && DY == 0){
      DrawX();
      posz = targetz;
      Reportz();
    }
    else if (DX != 0 && DY != 0 && abs(DY) >= abs(DX)){
      DrawYX();
      posz = targetz;
      Reportz();
    }
    else if (DX != 0 && DY != 0 && abs(DX) > abs(DY)){
      DrawXY();
      posz = targetz;
      Reportz();
    }
    else if (DX == 0 && DY == 0){
      posz = targetz;
      Reportz();
      report();
      delay (abs(1000*scale));
    }
  }
  report();
}

void DrawY(){
  dy = feedRate ;
  if (DY > 0) {
    if (posy < targety ) {
      motory.step(dy, BACKWARD, SINGLE);
      posx = posx;
      posy = posy + dy / stepy;
      report();
    }
  }
  else {
    if (posy > targety ){
      motory.step(dy, FORWARD, SINGLE);
      posx = posx;
      posy = posy - dy / stepy;
      report();
    }
  }
}

void DrawX(){
  dx = feedRate;
  if (DX > 0) {
    if (posx < targetx) {
      motorx.step(dx, BACKWARD, SINGLE);
      posx = posx + dx / stepx;
      posy = posy;
      report();
    }
  }
  else {
    if (posx > targetx){
      motorx.step(dx, FORWARD, SINGLE);
      posx = posx - dx / stepx;
      posy = posy;
      report();
    }
  }
}

void DrawXY(){
  //unit on y
  float slope = abs(DX / DY);
  dy = feedRate;
  if (DY > 0){
    if (DX > 0){
      if (posy < targety){
        motory.step(dy, BACKWARD, SINGLE);
        posy = posy + dy / stepy;
        linex = linex + dy * slope / stepy;
        int dx = (int) ((linex - posx) * stepx);
        motorx.step(dx, BACKWARD, SINGLE);
        posx = posx + dx / stepx;
        report();
      }
    }
    else {
      if (posy < targety){
        motory.step(dy, BACKWARD, SINGLE);
        posy = posy + dy / stepy;
        linex = linex - dy * slope / stepy;
        int dx = (int) (abs(linex - posx) * stepx);
        motorx.step(dx, FORWARD, SINGLE);
        posx = posx - dx / stepx;
        report();
      }
    }
  }
  else{
    if (DX > 0){
      if (posy > targety){
        motory.step(dy, FORWARD, SINGLE);
        posy = posy - dy / stepy;
        linex = linex + dy * slope / stepy;
        int dx = (int) ((linex - posx) * stepx);
        motorx.step(dx, BACKWARD, SINGLE);
        posx = posx + dx / stepx;
        report();
      }
    }
    else {
      if (posy > targety){
        motory.step(dy, FORWARD, SINGLE);
        posy = posy - dy / stepy;
        linex = linex - dy * slope / stepy;
        int dx = (int) (abs(linex - posx) * stepx);
        motorx.step(dx, FORWARD, SINGLE);
        posx = posx - dx / stepx;
        report();
      }
    }
  }
}

void DrawYX(){
  //unit on x
  float slope = abs(DY / DX);
  dx = feedRate;
  if (DX > 0){
    if (DY > 0){
      if (posx < targetx){
        motorx.step(dx, BACKWARD, SINGLE);
        posx = posx + dx / stepx;
        liney = liney + dx * slope / stepx;
        int dy = (int) ((liney - posy) * stepy);
        motory.step(dy, BACKWARD, SINGLE);
        posy = posy + dy / stepy;
        report();
      }
    }
    else {
      if (posx < targetx){
        motorx.step(dx, BACKWARD, SINGLE);
        posx = posx + dx / stepx;
        liney = liney - dx * slope / stepx;
        int dy = (int) (abs(liney - posy) * stepy);
        motory.step(dy, FORWARD, SINGLE);
        posy = posy - dy / stepy;
        report();
      }
    }
  }
  else{
    if (DY > 0){
      if (posx > targetx){
        motorx.step(dx, FORWARD, SINGLE);
        posx = posx - dx / stepx;
        liney = liney + dx * slope / stepx;
        int dy = (int) ((liney - posy) * stepy);
        motory.step(dy, BACKWARD, SINGLE);
        posy = posy + dy / stepy;
        report();
      }
    }
    else{
      if (posx > targetx){
        motorx.step(dx, FORWARD, SINGLE);
        posx = posx - dx / stepx;
        liney = liney - dx * slope / stepx;
        int dy = (int) (abs(liney - posy) * stepy);
        motory.step(dy, FORWARD, SINGLE);
        posy = posy - dy / stepy;
        report();
      }
    }
  }
}

void report(){
  Serial.print ("X:");
  Serial.println (posx);
  Serial.print("\t");
  Serial.print ("targetX:");
  Serial.println (targetx);
  Serial.print("\t");
  Serial.print ("Y:");
  Serial.println (posy);
  Serial.print("\t");
  Serial.print ("targetY:");
  Serial.println (targety);
  Serial.print("\t");
  Serial.print ("Z:");
  Serial.println (posz);
  Serial.print("\t");
  Serial.print ("targetZ:");
  Serial.println (targetz);
  Serial.print ("\n");
}

void CheckArrive(){

  if ((abs(targetx-posx) + abs(targety-posy) + abs(targetz-posz))<= 0.02 && command == true){
    command = false;
    Serial.print("*");
  }
}

void Reportz(){
  int intposz = (int)(posz * 100);
  mySerial.print("@");
  mySerial.print (intposz);
  mySerial.print("#");
  delay(1000);
}

void loop() {

  AcquireXYZ();
  if (command == true){
    plotting();
  }
  CheckArrive();
}




