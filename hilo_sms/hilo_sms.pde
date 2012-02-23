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
int onModulePin = 2;        // the pin to switch on the module (without press on button) 

int timesToSend = 1;        // Numbers of SMS to send
int count = 0;

void switchModule(){
  digitalWrite(onModulePin,HIGH);
  delay(2000);
  digitalWrite(onModulePin,LOW);
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
}

void loop(){
  
  while (count < timesToSend){
    delay(1500);
    Serial.print("AT+CMGS=");               // send the SMS the number
    Serial.print(34,BYTE);                  // send the " char 
    Serial.print("0999411956");              // send the number change ********* by the actual number
    Serial.println(34,BYTE);                // send the " char
    delay(1500); 
    Serial.print("Hola caracola...");     // the SMS body
    delay(500);
    Serial.print(0x1A,BYTE);                // end of message command 1A (hex)
       
    delay(5000);        

    count++;    
  }

  if (count == timesToSend){
    Serial.println("AT*PSCPOF");             // switch the module off
    count++;
  }
}


