/*
   *  Sending SMS using GPRS module from Libelium for Arduino
 *  Basic program, just sends an SMS
 *  Copyright (C) 2008 Libelium Comunicaciones Distribuidas S.L.
 *  http://www.libelium.com
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Version 0.1
 *  Author: Marcos Yarza <m.yarza [at] libelium [dot] com>
 */

int led = 13;
int ad = 0;
int onModulePin = 2;        // the pin to switch on the module (without press on button)

int timesToSend = 1;        // Numbers of SMS to send
int count = 0;
#define LINEBUF_SIZE 10
#define INLENGTH 16
char inString[INLENGTH+1];
int inCount;
int i = 0;
char databuffer[LINEBUF_SIZE];

void switchModule(){
  digitalWrite(onModulePin,HIGH);
  delay(2000);
  digitalWrite(onModulePin,LOW);
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
  // Serial.flush();
  while (Serial.available()){
    c = Serial.read();
    delay(200);
  }
  //  delay(50);

  Serial.println(command);       // send the command to the modem

  // fill the rx_buff with characters until a OK or ERROR or '>' is read
  i = 0;
  int timeout = 1200; //WAIT 24 SECONDS (1200 * 20)
  boolean eol = false;

  while (timeout > 0 && i < size && eol == false) {
    if (Serial.available() > 0){
      c = Serial.read();
      lineArray[i] = c;
      if ((char)c  == 'K') {
        if ((char)lineArray[i-1] == 'O'){ //OK
          lineArray[i+1] = 0;  //terminate the buffer with a NULL
          success = true;
          eol = true;
        }
      }
      if ((char)c  == 'R') {
        if ((char)lineArray[i-1] == 'O'){ //ERROR
          lineArray[i+1] = 0;
          success = false;
          eol = true;
        }
      }
      if ((char)c  == '>') {
        lineArray[i+1] = 0;
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

void setup(){

  pinMode(led, OUTPUT);
  pinMode(onModulePin, OUTPUT);

  Serial.begin(19200);               // the GPRS baud rate

  switchModule();                    // swith the module ON

  for (int i=0;i<2;i++){
    delay(5000);
  }

  Serial.println("AT+CMGF=1");         // set the SMS mode to text
  delay(100);
}

void loop(){     
  ad=SendGsmCommand("AT\r\n",2,databuffer);
  if (ad > 0) {
    digitalWrite(led,HIGH);
  }
  delay(5000);
}



