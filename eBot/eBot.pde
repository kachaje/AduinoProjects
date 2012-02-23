#define WIRELESS_ON

#include <Cmd.h>

#include <ServoTimer2.h>
#include <WString.h>
#include <WiShield.h>

// Digital Pins configuration --------------------------------------------
const int rightWeelPin = 7;
const int leftWeelPin =  6;
const int headPin =      5;

//const int ledPin = 1;     // LED connected to digital pin 1
const int speakerPin =   4; // Speaker

// Analog Pins configuration ---------------------------------------------
const int vision = 5;

// Servo configuration----------------------------------------------------
#define CENTER 1500
#define CENTER_R CENTER
#define CENTER_L CENTER+1

#define LEFT   CENTER-650
#define RIGHT  CENTER+650

#define R_STOP 1450 
#define L_STOP 1450 

#define L_FULL_FORWARD L_STOP + 300
#define R_FULL_FORWARD R_STOP - 300

#define LSPEED L_STOP + 85 //100
#define RSPEED R_STOP - 100

#define L_FULL_REVERSE R_FULL_FORWARD
#define R_FULL_REVERSE L_FULL_FORWARD

#define L_REVERSE RSPEED
#define R_REVERSE LSPEED

#define LEFT_TURN  0
#define RIGHT_TURN 1
#define QUARTER_TURN_DELAY 800  // in milliseconds

#define DIST_ERR 50

#define DEBUG                   // enable debugging

#define BUMP_DELAY 125

int leftDist = 0;                          // the average
int rightDist = 0;
int forDist = 0;

boolean goingLeft = true;
boolean turnNow = false;

int curDist = 0;
int objDist = 0;
int objDir = 0;

// initialize weel motor speed variables with inital constants 
int r_stop = R_STOP; 
int l_stop = L_STOP; 
int l_full_forward = L_FULL_FORWARD;
int r_full_forward = R_FULL_FORWARD;
int lspeed = LSPEED;
int rspeed = RSPEED;
int l_full_reverse = L_FULL_REVERSE;
int r_full_reverse = R_FULL_REVERSE;
int l_reverse = L_REVERSE;
int r_reverse = R_REVERSE;


int leftSpeed  = LSPEED;    // variable to store the servo speed/position 
int rightSpeed = RSPEED;
int headPos    = CENTER;

// create servo objects to control servos 
ServoTimer2 leftWheel;  
ServoTimer2 rightWheel;
ServoTimer2 head;

// Wireless configuration parameters ----------------------------------------
// Note: pins in use - 2, 9 (LED is switch is set) 10, 11, 12, 13

#ifdef WIRELESS_ON

  // Setup the wireless mode
  #define WIRELESS_MODE_INFRA	1
  #define WIRELESS_MODE_ADHOC	2

  int port_number = 1000;                 // port number 

  /* WIRELESS_MODE_INFRA */
  unsigned char wireless_mode = WIRELESS_MODE_INFRA;    // infrastructure - connect to AP

  byte local_ip[]    = {10,12,12,123};	                // IP address of WiShield
  byte gateway_ip[]  = {10,12,12,1};	                // router or gateway IP address
  byte subnet_mask[] = {255,255,255,0};	                // subnet mask for the local network
  
  const prog_char ssid[] PROGMEM    = {"test_popo"};		// max 32 bytes
  unsigned char security_type = 0;	                // 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2


  /* WIRELESS_MODE_ADHOC 
  unsigned char wireless_mode = WIRELESS_MODE_ADHOC;    // adhoc - connect to another WiFi device

  byte local_ip[]    = {169,254,46,2};	                // IP address of WiShield
  byte gateway_ip[]  = {169,254,46,1};	                // router or gateway IP address
  byte subnet_mask[] = {255,255,0,0};	                // subnet mask for the local network

  prog_char ssid[] PROGMEM    = {"ARDUINO"};		// max 32 bytes
  unsigned char security_type = 0;	                // 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2
  */
  
  const prog_char security_passphrase[] PROGMEM = {"12345678"};	// WPA/WPA2 passphrase, max 64 characters
  
// Enter your WEP 128-bit keys below:
  prog_uchar wep_keys[] PROGMEM = {    
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D,    // Key 0
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,    // Key 1
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,    // Key 2
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00     // Key 3
  };
  
  unsigned char ssid_len;
  unsigned char security_passphrase_len;

  Server server(port_number);
  Client client;

  const char s_WelcomeMessage[] = "WiFi eBot 1.0, Yuriy Shcherbakov (c) 2009";

  //Command configuration------------------------------------------------------
  
  // Define an output procedure that returns text string response. 
  void client_print(char text[]) { 
    client.print(text); 
  }

  // Declare an instance of Cmd here.
  Cmd cmd(client_print);

  // Keywords definition. The last array element must be "".
  const char keywords[][keywordMaxLen] PROGMEM =
    {"SET", "GET", "LED", "ON", "OFF", "DELAY", "PLAY",
     "GO", "STOP", "TURN", "LEFT", "RIGHT", "CENTER", 
     "DISTANCE", "BUMP", "LOOK", "AROUND", "REVERSE", 
     "HEAD", "SPEED", "INCREASE", "DECREASE", "FORWARD", "SCAN"
     ""};

  // Keyword index definition. Assign a numeric index to each keyword above. 
  #define kwdSET       1  
  #define kwdGET       kwdSET+1
  #define kwdLED       kwdGET+1
  #define kwdON        kwdLED+1
  #define kwdOFF       kwdON+1
  #define kwdDELAY     kwdOFF+1
  #define kwdPLAY      kwdDELAY+1
  #define kwdGO        kwdPLAY+1
  #define kwdSTOP      kwdGO+1
  #define kwdTURN      kwdSTOP+1
  #define kwdLEFT      kwdTURN+1
  #define kwdRIGHT     kwdLEFT+1
  #define kwdCENTER    kwdRIGHT+1
  #define kwdDISTANCE  kwdCENTER+1
  #define kwdBUMP      kwdDISTANCE+1
  #define kwdLOOK      kwdBUMP+1
  #define kwdAROUND    kwdLOOK+1
  #define kwdREVERSE   kwdAROUND+1
  #define kwdHEAD      kwdREVERSE+1
  #define kwdSPEED     kwdHEAD+1
  #define kwdINCREASE  kwdSPEED+1
  #define kwdDECREASE  kwdINCREASE+1
  #define kwdFORWARD   kwdDECREASE+1
  #define kwdSCAN      kwdFORWARD+1
  

  // Specify keywords that are followed by one or more keywords
  const prog_uchar processNextKeyword[] PROGMEM = {kwdSET, kwdGET, kwdLED, kwdTURN, kwdBUMP, kwdLOOK, kwdHEAD, kwdINCREASE, kwdDECREASE, kwdSPEED, kwdSCAN, 0};

  // Create multi-word commands. The last array element must be zero.
  const prog_uchar cmd_SET_LED_ON[] PROGMEM = {kwdSET, kwdLED, kwdON, 0};
  const prog_uchar cmd_SET_LED_OFF[] PROGMEM = {kwdSET, kwdLED, kwdOFF, 0};
  const prog_uchar cmd_DELAY[] PROGMEM = {kwdDELAY, 0};
  const prog_uchar cmd_PLAY[] PROGMEM = {kwdPLAY, 0};
  const prog_uchar cmd_GO[] PROGMEM = {kwdGO, 0};
  const prog_uchar cmd_STOP[] PROGMEM = {kwdSTOP, 0};
  const prog_uchar cmd_TURN_LEFT[] PROGMEM = {kwdTURN, kwdLEFT, 0};
  const prog_uchar cmd_TURN_RIGHT[] PROGMEM = {kwdTURN, kwdRIGHT, 0};
  const prog_uchar cmd_GET_DISTANCE[] PROGMEM = {kwdGET, kwdDISTANCE, 0};
  const prog_uchar cmd_BUMP_LEFT[] PROGMEM = {kwdBUMP, kwdLEFT, 0};
  const prog_uchar cmd_BUMP_RIGHT[] PROGMEM = {kwdBUMP, kwdRIGHT, 0};
  const prog_uchar cmd_LOOK_AROUND[] PROGMEM = {kwdLOOK, kwdAROUND, 0};
  const prog_uchar cmd_REVERSE[] PROGMEM = {kwdREVERSE, 0};
  const prog_uchar cmd_TURN_HEAD_LEFT[] PROGMEM = {kwdTURN, kwdHEAD, kwdLEFT, 0};
  const prog_uchar cmd_TURN_HEAD_RIGHT[] PROGMEM = {kwdTURN, kwdHEAD, kwdRIGHT, 0};
  const prog_uchar cmd_TURN_HEAD_FORWARD[] PROGMEM = {kwdTURN, kwdHEAD, kwdFORWARD, 0};
  const prog_uchar cmd_GET_SPEED[] PROGMEM = {kwdGET, kwdSPEED, 0};
  const prog_uchar cmd_INCREASE_SPEED_LEFT[] PROGMEM = {kwdINCREASE, kwdSPEED, kwdLEFT, 0};
  const prog_uchar cmd_INCREASE_SPEED_RIGHT[] PROGMEM = {kwdINCREASE, kwdSPEED, kwdRIGHT, 0};
  const prog_uchar cmd_DECREASE_SPEED_LEFT[] PROGMEM = {kwdINCREASE, kwdSPEED, kwdLEFT, 0};
  const prog_uchar cmd_DECREASE_SPEED_RIGHT[] PROGMEM = {kwdINCREASE, kwdSPEED, kwdRIGHT, 0};
  const prog_uchar cmd_SCAN_AROUND[] PROGMEM = {kwdSCAN, kwdAROUND, 0};

  // List of supported commands
  const prog_uchar *mapCommands[] = {
    cmd_SET_LED_ON, 
    cmd_SET_LED_OFF, 
    cmd_DELAY, 
    cmd_PLAY,         
    cmd_GO, 
    cmd_STOP, 
    cmd_TURN_LEFT, 
    cmd_TURN_RIGHT, 
    cmd_GET_DISTANCE, 
    cmd_BUMP_LEFT, 
    cmd_BUMP_RIGHT, 
    cmd_LOOK_AROUND, 
    cmd_REVERSE, 
    cmd_TURN_HEAD_LEFT, 
    cmd_TURN_HEAD_RIGHT, 
    cmd_TURN_HEAD_FORWARD,
    cmd_GET_SPEED,
    cmd_INCREASE_SPEED_LEFT,
    cmd_INCREASE_SPEED_RIGHT,
    cmd_DECREASE_SPEED_LEFT, 
    cmd_DECREASE_SPEED_RIGHT,
    cmd_SCAN_AROUND
  };

  const int mapCommandsSize = 22;  // Size of the array above

  // List of supported command procedures. Size of this array must be exactly the same as the aray above.
  const CommandProc mapCommandProcs[] = {
    &nothing,                      // cmd_SET_LED_ON, 
    &nothing,                      // cmd_SET_LED_OFF, 
    &delay,                        // cmd_DELAY, 
    &do_play_melody,               // cmd_PLAY,         
    &go,                           // cmd_GO, 
    &stop,                         // cmd_STOP, 
    &turn_left,                    // cmd_TURN_LEFT, 
    &turn_right,                   // cmd_TURN_RIGHT, 
    &get_distance,                 // cmd_GET_DISTANCE, 
    &bump_left,                    // cmd_BUMP_LEFT, 
    &bump_right,                   // cmd_BUMP_RIGHT, 
    &lookAround,                   // cmd_LOOK_AROUND, 
    &reverse,                      // cmd_REVERSE, 
    &turn_head_left,               // cmd_TURN_HEAD_LEFT, 
    &turn_head_right,              // cmd_TURN_HEAD_RIGHT
    &turn_head_forward,            // cmd_TURN_HEAD_FORWARD
    &get_speed,                    // cmd_GET_SPEED
    &increase_speed_left,          // cmd_INCREASE_SPEED_LEFT
    &increase_speed_right,         // cmd_INCREASE_SPEED_RIGHT
    &decrease_speed_left,          // cmd_DECREASE_SPEED_LEFT
    &decrease_speed_right,         // cmd_DECREASE_SPEED_RIGHT
    &scan_around,                  // cmd_SCAN_AROUND
  };

  // Stub procedure
  void nothing() {}

  // command procs

  void scan_around() {
   
    for(int i=(CENTER-650); i<(CENTER+650); i=i+13) {
      head.write(i);
      //delay(50);
      client.println(analogRead(vision));
    }
    turn_head_forward();
  }

  void increase_speed_left() {
    lspeed = lspeed + lspeed * 0.1;
    get_speed();
  }

  void increase_speed_right() {
    rspeed = rspeed + rspeed * 0.1;
    get_speed();
  }

  void decrease_speed_left() {
    lspeed = lspeed - lspeed * 0.1;
    get_speed();
  }

  void decrease_speed_right() {
    rspeed = rspeed - rspeed * 0.1;
    get_speed();
  }


  void get_speed() {
    client.print("r_stop         ");    client.println(r_stop);
    client.print("l_stop         ");    client.println(l_stop);
    client.print("l_full_forward ");    client.println(l_full_forward);
    client.print("r_full_forward ");    client.println(r_full_forward);
    client.print("lspeed         ");    client.println(lspeed);
    client.print("rspeed         ");    client.println(rspeed);
    client.print("l_full_reverse ");    client.println(l_full_reverse);
    client.print("r_full_reverse ");    client.println(r_full_reverse);
    client.print("l_reverse      ");    client.println(l_reverse);
    client.print("r_reverse      ");    client.println(r_reverse);
  }

  void get_distance() {
    client.println(analogRead(vision));
  }

  void turn_head_left() {
    head.write(RIGHT);    
  }
  
  void turn_head_right() {
    head.write(LEFT);    
  }

  void turn_head_forward() {
    head.write(CENTER);    
  }
  
  void turn_right() {
    turn(RIGHT_TURN, QUARTER_TURN_DELAY, false); 
  }

  void turn_left() {
    turn(LEFT_TURN, QUARTER_TURN_DELAY, false);
  }

  void bump_right() {
    bump(RIGHT_TURN);
  }

  void bump_left() {
    bump(LEFT_TURN);
  }

  void delay() { 
    delay(1000); 
  }

  //---------------------------------------------------------//

#endif // WIRELESS_ON


void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}

void playNote(char note, int duration) {
  char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };
  int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956 };
  
  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}

void play_notes(int length, // the number of notes
                char notes[], // a space represents a rest
                int beats[],
                int tempo )
{
  for (int i = 0; i < length; i++) {
    if (notes[i] == ' ') {
      delay(beats[i] * tempo); // rest
    } else {
      playNote(notes[i], beats[i] * tempo);
    }
    
    // pause between notes
    delay(tempo / 2); 
  }
}

void do_play_melody() {
  int beats[] = { 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 4 };
  play_notes(15, "ccggaagffeeddc ", beats, 100);
}

//---------------------------------------------------------//

/*******************************************************
* turn - Executes an in-place turn for <duration> miliseconds
* QUARTER_TURN_DELAY gets you about 90 deg
********************************************************/
void turn(int dir, int duration, boolean keepMoving){
  // Store previous speeds
  //rightSpeed = rightWheel.read();
  //leftSpeed = leftWheel.read();
  
  if(dir == RIGHT_TURN){
    rightWheel.write(r_full_reverse);
    leftWheel.write(l_full_forward);
  }
  else {
     rightWheel.write(r_full_forward);
     leftWheel.write(l_full_reverse);
  }
  delay(duration);  
  
  if (keepMoving) 
  {
    // restore previous speeds
    rightWheel.write(rightSpeed);
    leftWheel.write(leftSpeed);
  } 
  else 
    stop();
}

void go(){
  rightWheel.write(RSPEED);
  leftWheel.write(LSPEED);
}

void reverse(){
  rightWheel.write(leftSpeed);
  leftWheel.write(rightSpeed);
}

void stop(){
  rightWheel.write(r_stop);
  leftWheel.write(l_stop);
}

/***************************************************
* scan - This function is called every cycle
* it turns the head a click and records a distance and
* heading.  It only saves the closest object info.
* objDist and objDir hold the closest object data
****************************************************/
void scan(){

  if(goingLeft){
    head.write(head.read()-10);
  }
  else{
    head.write(head.read()+10);
  }
  
  if(head.read() <= LEFT){
    goingLeft = false;
    forDist = 0;
    objDist = 0;
    turnNow = true;
  }
  
  if(head.read() >= RIGHT){
    goingLeft = true;
    forDist = 0; 
    objDist = 0; 
    turnNow = true;
  }

  curDist = analogRead(vision); 
  if(curDist > objDist){
    objDist = curDist;
    objDir  = head.read();
    
 #ifdef DEBUG
      Serial.print("New close obj at Dist: ");
      Serial.print(objDist);
      Serial.print(" heading: ");
      Serial.println(objDir);
 #endif
  }
  
  delay(10);
  
} 
  

/**********************************************************
* bump
* Executes a nudge to a given side 
* Pass in LEFT_TURN or RIGHT_TURN
***********************************************************/
void bump(int dir){
#define BUMP 100 
  if(dir == LEFT_TURN){
    rightWheel.write(rightWheel.read()-BUMP);
    delay(BUMP_DELAY);
    rightWheel.write(rightWheel.read()+BUMP);
  }
  else {
    leftWheel.write(leftWheel.read()+BUMP);
    delay(BUMP_DELAY);
    leftWheel.write(leftWheel.read()-BUMP);
  }  
}
  
/**********************************************************
* bumpSteer
* Nudges us back on coarse if we see something off to the 
* side.  Relies on objDist and objDir to be updated by scan()
*
***********************************************************/
void bumpSteer(){
  // One bump per scan
  if(!turnNow || objDist < 470)
    return;  

  if(objDir > CENTER){
    bump(RIGHT_TURN);
  }
  else if(objDir <= CENTER){
    bump(LEFT_TURN);
  }
  // No turn till next scan  
  turnNow = false;
}

void lookAround(){
  head.write(LEFT);
  delay(400);
  leftDist = analogRead(vision);
  head.write(CENTER);
  delay(400);
  forDist = analogRead(vision);
  head.write(RIGHT);
  delay(400);
  rightDist = analogRead(vision);
  head.write(CENTER);
  delay(200);
}

int cornerNav(){
  if(objDist > 600 && objDir > CENTER - 350 && objDir < CENTER + 200){

#ifdef DEBUG 
      Serial.println("Check:");
      Serial.println(objDist);
      Serial.println(objDir);
#endif

    stop();
    lookAround();
    if(leftDist > rightDist + DIST_ERR){
        turn(LEFT_TURN, QUARTER_TURN_DELAY, true);
    }
    else {
        turn(RIGHT_TURN, QUARTER_TURN_DELAY, true);
    }
    go();
    objDist = 0;
    return 1;
  }
  return 0;
}

void explore()
{
  scan();   
  if(!cornerNav()){
    bumpSteer();
  }
}

//---------------------------------------------------------//

void setup()
{

#ifdef DEBUG
    Serial.begin(9600);
#endif

  pinMode(speakerPin, OUTPUT);

  // attaches servos pins to servo objects 
  leftWheel.attach(leftWeelPin);  
  rightWheel.attach(rightWeelPin);
  head.attach(headPin);
  stop();
  
  //rightWheel.write(rightSpeed); // Stop Wheels
  //leftWheel.write(leftSpeed);  // Stop Wheels
  //head.write(headPos);

#ifdef WIRELESS_ON
  WiFi.begin(local_ip, gateway_ip, subnet_mask);
  server.begin();
#else
  do_play_melody(); 
#endif  
  
}

void loop()
{  
 
#ifdef WIRELESS_ON

  if(!client.connected()) {
     server.available(&client);
     client.println(s_WelcomeMessage);
  } else {
      if(client.available()) {
        cmd.addChar((char)client.read());
    }
  }

#else
  explore();
#endif  
 
}

