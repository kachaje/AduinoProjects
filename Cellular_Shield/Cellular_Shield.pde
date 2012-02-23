
#include <NewSoftSerial.h>  //Include the NewSoftSerial library to send serial commands to the cellular module.
#include <string.h>         //Used for string manipulations

#define LINEBUF_SIZE 220

char databuffer[LINEBUF_SIZE];

char incoming_char=0;      //Will hold the incoming character from the Serial Port.

NewSoftSerial cell(2,3);  //Create a 'fake' serial port. Pin 2 is the Rx pin, pin 3 is the Tx pin.

void setup()
{
  //Initialize serial ports for communication.
  Serial.begin(9600);
  cell.begin(9600);

  int i = 0;
  for(i = 0; i < 5; i++){
    delay(5000);
  }
  //Let's get started!
  //Serial.println("Starting SM5100B Communication...");
  cell.println("AT+CMGF=1");
  delay(1500);
}

void loop() {

  SendGsmCommand("AT+CMGL=\"ALL\"", 220, databuffer); 

  //Serial.println("out1");

  int i = 0;

  for(i = 0; i < 3; i++){
    delay(5000); 
  }

  String output = "";

  for(i = 0; i < sizeof(databuffer); i++){
    if(databuffer[i]){
      output += databuffer[i];
    }
  }

  output = output.trim();

  int comma = output.indexOf(',');
  String substr = "";
  String pos = "";

  if(comma > 0){
    substr = output.substring(0, comma);

    int space = output.substring(0, comma).indexOf(' ');

    if(space > 0){
      pos = output.substring(0, comma).substring(space).trim();
    }
  }

  if(pos != ""){
    SendGsmCommand("AT+CMGR=" + pos, 220, databuffer); 
  }

  for(i = 0; i < 3; i++){
    delay(5000); 
  }

  output = "";

  for(i = 0; i < sizeof(databuffer); i++){
    if(databuffer[i]){
      output += databuffer[i];
    }
  }

  output = output.trim();

  String msg = "";
  int LF = output.indexOf('\n');

  msg = output.substring(LF).trim();

  if(msg.trim().endsWith("OK")){
    msg = msg.substring(0, msg.length() - 2); 
    msg = msg.trim();
  }

  if(msg.trim().length() > 0){
    msg = msg.replace('\r', ".");
    msg = msg.replace('\n', " ");

    Serial.println(msg);

    int line = 55;
    int j = 0;
    int row = 0;
    String currentline = "";

    //msg = "A40,80,0,2,2,2,N,\"" + msg + "\"";

    delay(1000);
    Serial.println();
    // print a sample string of text similar to what is sent to the printer
    Serial.println("N");
    Serial.println("q801");
    Serial.println("Q329,026");
    Serial.println("ZT");

    while(j < (msg.trim().length())){
      int currentrow = 50 + (26 * row);

      //if(msg.substring(j, line).trim().length() > 0){
      currentline = "A40,";
      currentline += currentrow;
      currentline += ",0,2,1,1,N,\"";

      if(msg.trim().length() < (j + line)){
        currentline += msg.substring(j);
      } 
      else {
        currentline += msg.substring(j, (j + line));  
      }

      currentline += "\"";
      Serial.println(currentline); 

      //}

      j += line;
      row++;
      //delay(200);
    }

    Serial.println("P1");
    Serial.println("");

    delay(1500);

    if(pos != ""){
      SendGsmCommand("AT+CMGD=" + pos, 220, databuffer); 
    }

    delay(5000);     

  }

}

int SendGsmCommand(String command, int size, char *lineArray) {
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
  // Serial.flush();
  while (cell.available()) {
    c = cell.read();
    delay(200);
  }
  //  delay(50);

  cell.println(command); // send the command to the modem

  // fill the rx_buff with characters until a OK or ERROR or '>' is read
  i = 0;
  int timeout = 1200; //WAIT 24 SECONDS (1200 * 20)
  boolean eol = false;

  while (timeout > 0 && i < size && eol == false) {

    //Serial.println(lineArray);

    if (cell.available() > 0) {
      c = cell.read();
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



