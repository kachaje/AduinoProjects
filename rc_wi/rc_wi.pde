/*
    * Socket App to control Radio Control Car
 *
 * Loosly based off the simple socket application example using the WiShield 1.0
 */

#include <WiShield.h>
#include <Servo.h>

#define WIRELESS_MODE_INFRA   1
#define WIRELESS_MODE_ADHOC   2

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {
  192,168,10,2};   // IP address of WiShield
unsigned char gateway_ip[] = {
  192,168,10,1};   // router or gateway IP address
unsigned char subnet_mask[] = {
  255,255,255,0};   // subnet mask for the local network
const prog_char ssid[] PROGMEM = {
  "R500eN"};      // max 32 bytes

unsigned char security_type = 0;   // 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = {
  "12345678"};   // max 64 characters

// WEP 128-bit keys
// sample HEX keys
prog_uchar wep_keys[] PROGMEM = {   
  0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,   // Key 0
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   0x00,   // Key 1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   0x00,   // Key 2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   0x00   // Key 3
};

// setup the wireless mode
// infrastructure - connect to AP
// adhoc - connect to another WiFi device
unsigned char wireless_mode = WIRELESS_MODE_ADHOC;

unsigned char ssid_len;
unsigned char security_passphrase_len;
//---------------------------------------------------------------------------
char buffer[20];

int pinArray[4] = {
  3, 4, 5, 6}; // digital pins for the servos
int minPulse = 500;             // minimum servo position
int maxPulse = 2500;            // maximum servo position
int refreshTime =  20;          // time (ms) between pulses (50Hz)

int i;              // iterator
int servoPin;       // control pin for current servo
int pulseWidth;     // servo pulse width
int servoPosition;  // commanded servo position, 0-180 degrees
int pulseRange;     // maxPulse - minPulse
int centerServo;    // servo starting point
long lastPulse = 0; // recorded time (ms) of the last pulse
int servo;          // which servo to pulse
int servo1[2];      // servo #1 array{pin, pulsewidth}
int servo2[2];      // servo #2 array{pin, pulsewidth}
int pin;            // digital pin for pulse() function
int puls;           // pulsewidth for pulse() function
int posout;
int pos[2];

void setup()
{
  WiFi.init();
  // loop through all 4 servo pins
  // and set them as OUTPUT
  for (i=0;i<4;i++) {
    pinMode(pinArray[i], OUTPUT);
  } 
  // servo starting point (center)
  pulseRange  = maxPulse - minPulse;
  centerServo = maxPulse - ((pulseRange)/2);
  pulseWidth  = centerServo;
  // map pins to servos
  servo1[0] = pinArray[0];  // servo #1 is pin 3
  servo2[0] = pinArray[1];  // servo #2 is pin 4
  // center all servos
  servo1[1] = pulseWidth;
  servo2[1] = pulseWidth;
}

void loop()
{
  WiFi.run(); 

  if(buffer[0] == 'A'){
    //Get position from string
    pos[0] = servopos(buffer[1]);
    pos[1] = servopos(buffer[2]);
    //Calculate Pulse Position
    servo1[1] = calpulse(pos[0]);
    servo2[1] = calpulse(pos[1]);

    memset(buffer, 0x00, sizeof(buffer));
  }
  //pulse each servo
  if (millis() - lastPulse >= refreshTime) {
    pulse(servo1[0], servo1[1]);
    pulse(servo2[0], servo2[1]);
    // save the time of the last pulse
    lastPulse = millis();
  }
}

void pulse(int pin, int puls) {
  digitalWrite(pin, HIGH); // start the pulse
  delayMicroseconds(puls); // pulse width
  digitalWrite(pin, LOW);  // stop the pulse
}

int calpulse(int srvpos) {
  if (srvpos == 255) { 
    servo = 255; 
  }
  // compute pulseWidth from servoPosition
  pulseWidth = minPulse + (srvpos * (pulseRange/180));
  // stop servo pulse at min and max
  if (pulseWidth > maxPulse) { 
    pulseWidth = maxPulse; 
  }
  if (pulseWidth < minPulse) { 
    pulseWidth = minPulse; 
  }
  return pulseWidth;
}

int servopos(int srvpos){
  if(srvpos == 'A'){
    posout = 0;
  }
  else if(srvpos == 'B'){
    posout = 0;
  }
  else if(srvpos == 'C'){
    posout = 10;
  }
  else if(srvpos == 'D'){
    posout = 20;
  }
  else if(srvpos == 'E'){
    posout = 30;
  }
  else if(srvpos == 'F'){
    posout = 40;
  }
  else if(srvpos == 'G'){
    posout = 50;
  }
  else if(srvpos == 'H'){
    posout = 60;
  }
  else if(srvpos == 'I'){
    posout = 70;
  }
  else if(srvpos == 'J'){
    posout = 80;
  }
  else if(srvpos == 'K'){
    posout = 90;
  }
  else if(srvpos == 'L'){
    posout = 100;
  }
  else if(srvpos == 'M'){
    posout = 110;
  }
  else if(srvpos == 'N'){
    posout = 120;
  }
  else if(srvpos == 'O'){
    posout = 130;
  }
  else if(srvpos == 'P'){
    posout = 140;
  }
  else if(srvpos == 'Q'){
    posout = 150;
  }
  else if(srvpos == 'R'){
    posout = 160;
  }
  else if(srvpos == 'S'){
    posout = 170;
  }
  else if(srvpos == 'T'){
    posout = 180;
  }
  else if(srvpos == 'U'){
    posout = 180;
  }
  return posout;
}

