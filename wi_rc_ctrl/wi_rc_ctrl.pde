#include <WiServer.h>
#include <Servo.h>

#define WIRELESS_MODE_INFRA   1
#define WIRELESS_MODE_ADHOC   2

int leftmotor1 = 3;  // left motor logic terminal 1
int leftmotor2 = 4;  // left motor logic terminal 2
int rightmotor1 = 7; // right motor logic terminal 1
int rightmotor2 = 8; // right motor logic terminal 2
int panservopin = 14;  // analog pin 0 to control panning servo for camera
int tiltservopin = 15; // analog pin 1 to control tilting servo for camera
Servo panservo; 
Servo tiltservo;  // handles for panning and tilting
int panposition = 90;  // initialize pan position to middle (range 0-180)
int tiltposition = 90;  // initialize tilt position to middle (range 0-180)
int servoincrements = 10; // panning and tilting increments in degrees

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {
  192,168,1,10};   // IP address of WiShield
unsigned char gateway_ip[] = {
  192,168,1,1};   // router or gateway IP address
unsigned char subnet_mask[] = {
  255,255,255,0};   // subnet mask for the local network
const prog_char ssid[] PROGMEM = {
  "boris"};      // max 32 bytes

unsigned char security_type = 2;   // 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = {
  "Chickens"};   // max 64 characters

// WEP 128-bit keys
// sample HEX keys
prog_uchar wep_keys[] PROGMEM = { 
  0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,   // Key 0
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // Key 1
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // Key 2
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // Key 3
};

// setup the wireless mode
// infrastructure - connect to AP
// adhoc - connect to another WiFi device
unsigned char wireless_mode = WIRELESS_MODE_INFRA;

unsigned char ssid_len;
unsigned char security_passphrase_len;
// End of wireless configuration parameters ----------------------------------------


// This is our page serving function that generates web pages
boolean sendMyPage(char* URL) {

  // Check if the requested URL matches "/"
  if (strcmp(URL, "/") == 0) {
    // Use WiServer's print and println functions to write out the page content
    links ();
    // URL was recognized
    return true;
  } 
  else if (strcmp(URL, "/left") == 0) {
    // Use WiServer's print and println functions to write out the page content
    digitalWrite(leftmotor1, LOW);
    digitalWrite(leftmotor2, LOW);
    digitalWrite(rightmotor1, HIGH);
    digitalWrite(rightmotor2, LOW);   
    links ();
    // URL was recognized
    return true;
  } 
  else if (strcmp(URL, "/right") == 0) {
    // Use WiServer's print and println functions to write out the page content
    digitalWrite(leftmotor1, HIGH);
    digitalWrite(leftmotor2, LOW);
    digitalWrite(rightmotor1, LOW);
    digitalWrite(rightmotor2, LOW);
    links ();
    // URL was recognized
    return true;
  } 
  else if (strcmp(URL, "/forward") == 0) {
    // Use WiServer's print and println functions to write out the page content
    digitalWrite(leftmotor1, HIGH);
    digitalWrite(leftmotor2, LOW);
    digitalWrite(rightmotor1, HIGH);
    digitalWrite(rightmotor2, LOW);
    links ();
    // URL was recognized
    return true;
  } 
  else if (strcmp(URL, "/back") == 0) {
    // Use WiServer's print and println functions to write out the page content
    digitalWrite(leftmotor1, LOW);
    digitalWrite(leftmotor2, HIGH);
    digitalWrite(rightmotor1, LOW);
    digitalWrite(rightmotor2, HIGH);   
    links ();
    // URL was recognized
    return true;
  } 
  else if (strcmp(URL, "/stop") == 0) {
    // Use WiServer's print and println functions to write out the page content
    digitalWrite(leftmotor1, LOW);
    digitalWrite(leftmotor2, LOW);
    digitalWrite(rightmotor1, LOW);
    digitalWrite(rightmotor2, LOW);
    links ();
    // URL was recognized
    return true;
  }
  else if (strcmp(URL, "/tiltup") == 0) {
    tiltposition = tiltposition + servoincrements;
    if (tiltposition > 180) {
      tiltposition = 170;
    }
    tiltservo.write(tiltposition);
    links ();
    return true;
  }
  else if (strcmp(URL, "/tiltdown") == 0) {
    tiltposition = tiltposition - servoincrements;
    if (tiltposition < 0) {
      tiltposition = 10;
    }
    tiltservo.write(tiltposition);
    links ();
    return true;
  }
  else if (strcmp(URL, "/center") == 0) {
    tiltposition = 90;
    panposition = 90;
    tiltservo.write(tiltposition);
    panservo.write(panposition);
    links ();
    return true;
  }
  else if (strcmp(URL, "/panleft") == 0) {
    panposition = panposition + servoincrements;
    if (panposition > 180) {
      tiltposition = 170;
    }
    panservo.write(panposition);
    links ();
    return true;
  }
  else if (strcmp(URL, "/panright") == 0) {
    panposition = panposition - servoincrements;
    if (panposition < 0) {
      tiltposition = 10;
    }
    panservo.write(panposition);
    links ();
    return true;
  }
  // URL not found
  return false;
}

void links () {
  WiServer.print("<html>");
  WiServer.print("<style type=\"text/css\">body {background-color:gray;color:white;font-size:150%} a:link,a:visited {color:blue;} a:hover {color:blue; background-color:brown;}</style>");
  WiServer.print("<head><center><h1>Robo-Rat</h1></center></head>");

  WiServer.print("<body>");
  WiServer.print("<center><u>Mouse Control</u><br />");
  WiServer.print("[ <a href=\"/forward\">Forward</a> ]<br />");
  WiServer.print("[ <a href=\"/left\">Left</a> ] ");
  WiServer.print("[ <a href=\"/stop\">Stop</a> ] ");
  WiServer.print("[ <a href=\"/right\">Right</a> ]<br />");
  WiServer.print("[ <a href=\"/back\">Back</a> ]<br /><br /><br />");

  WiServer.print("<u>Camera Control</u><br />");
  WiServer.print("[ <a href=\"/tiltup\">Tilt Up</a> ]<br />");
  WiServer.print("[ <a href=\"/panleft\">Pan Left</a> ]");
  WiServer.print("[ <a href=\"/center\">Center</a> ]");
  WiServer.print("[ <a href=\"/panright\">Pan Right</a> ]<br />");
  WiServer.print("[ <a href=\"/tiltdown\">Tilt Down</a> ]</center>");
  WiServer.print("</body>");
  WiServer.print("</html>");
}

void setup() {
  // Initialize WiServer and have it use the sendMyPage function to serve pages
  WiServer.init(sendMyPage);
  pinMode(leftmotor1, OUTPUT);
  pinMode(leftmotor2, OUTPUT);
  pinMode(rightmotor1, OUTPUT);
  pinMode(rightmotor2, OUTPUT);
  panservo.attach(panservopin);  // attach pan function to analog pin
  tiltservo.attach(tiltservopin);  // attach tilt function to analog pin
  panservo.write(90);
  tiltservo.write(90);
  // Enable Serial output and ask WiServer to generate log messages (optional)
  Serial.begin(57600);
  WiServer.enableVerboseMode(true);
}

void loop(){
  // Run WiServer
  WiServer.server_task();
}

