#include <AikoEvents.h>

using namespace Aiko;

#define LINEBUF_SIZE 1024

char databuffer[LINEBUF_SIZE];

String value;
int onModulePin = 2;        // the pin to switch on the module (without press on button) 
char incoming_char=0; 

int reading = 0;

void switchModule(){
  digitalWrite(onModulePin,HIGH);
  delay(2000);
  digitalWrite(onModulePin,LOW);
}

void readMessages(){
  if(!reading){    
    Serial.println("AT+CMGL=\"ALL\""); 
  }  
}

void printMessages(){
  if(reading){
    return;  
  }

  value = "";
  int len = Serial.available();
  //int i = 0;

  Serial.println(len);

  //if(len > 0){
  //for(i = 0; i < len; i++){
  while(Serial.available() > 0){ 
    reading = 1; 
    incoming_char=Serial.read();

    value += incoming_char;       
  } 
  //}

  reading = 0;

  //delay(1000);
  Serial.println();
  // print a sample string of text similar to what is sent to the printer
  Serial.println("N");
  Serial.println("q817");
  Serial.println("Q305,026");
  Serial.println("ZT");
  Serial.print("A40,80,0,2,2,2,N,\"");

  value = value.trim();

  Serial.println(value + "\"");

  Serial.println("P1");
  Serial.println("");

  delay(1500);

  int comma = value.indexOf(',');

  if(comma > 0){
    String substr = "This is it: ";
    substr += value.substring(0, comma);

    int space = value.substring(0, comma).indexOf(' ');

    String pos = value.substring(0, comma).substring(space).trim();

    Serial.println(pos);

    //printMessage(pos);

    Serial.println(substr);  

    Serial.println("done");  
  }

  Serial.println(value);  
}

void printMessage(String index){
  String command = "AT+CMGR=";

  command += index;

  Serial.println(command);
  delay(1500); 
}

void setup() {

  pinMode(onModulePin, OUTPUT);

  Serial.begin(19200);               // the GPRS baud rate

  switchModule();                    // swith the module ON

  for (int i=0;i<2;i++){
    delay(5000);                        
  } 

  value = ""; 

  //Serial.println("ATE0");

  //delay(1500);

  Serial.println("AT+CMGF=1");         // set the SMS mode to text
  delay(1500);  

  //Events.addHandler(printMessages,  1500);
  //Events.addHandler(readMessages,   12000);
}

void loop() {
  //Serial.println("in");
  //Events.loop(); 
  SendGsmCommand("AT+CMGL=\"ALL\"", 13, databuffer); 

  Serial.println("out");

  Serial.println(databuffer);

  int i = 0;

  for(i = 0; i < 3; i++){
    delay(10000); 
  }

  String output = databuffer;

  Serial.println("past out and printing starts.");

  Serial.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

  Serial.println(databuffer);

  delay(3000);

  Serial.println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");

  Serial.println("printing ends");

  Serial.println("should be printed now");

  //for(i = 0; i < 3; i++){
  //  delay(10000); 
  //}

}

int SendGsmCommand(char *command, int size, char *lineArray) {
  int success = false;
  int c;
  byte i;
  //initialize the rx_buff to nulls
  i = 0;
  while (i < size) {
    lineArray[i] = 0;
    i++;
  }
  // flush the rx serial buffer
  Serial.flush();
  while (Serial.available()) {
    c = Serial.read();
    delay(200);
  }
  //  delay(50);

  Serial.println(command); // send the command to the modem

  // fill the rx_buff with characters until a OK or ERROR or '>' is read
  i = 0;
  int timeout = 1200; //WAIT 24 SECONDS (1200 * 20)
  boolean eol = false;

  while (timeout > 0 && i < size && eol == false) {
    if (Serial.available() > 0) {
      c = Serial.read();
      lineArray[i] = c;
      if ((char) c == 'K') {
        if ((char) lineArray[i - 1] == 'O') { //OK
          lineArray[i + 1] = 0; //terminate the buffer with a NULL
          success = true;
          eol = true;
        }
      }
      if ((char) c == 'R') {
        if ((char) lineArray[i - 1] == 'O') { //ERROR
          lineArray[i + 1] = 0;
          success = false;
          eol = true;
        }
      }
      if ((char) c == '>') {
        lineArray[i + 1] = 0;
        success = -10;
        eol = true;
      }

      i++;
    } 
    else {
      delay(20); //give chars a chance to come in
      timeout--;
    }
  }
  return success;
}







