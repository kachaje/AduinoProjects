/*
*  Making a call using GPRS module from Libelium for Arduino
*
*  Basic program, just makes a call
*
*
*  25/08/08 Zaragoza (Spain)
*
*  Copyright (C) 2008 M. Yarza 2.008 - 07 - 22 - Zaragoza
*  www.squidbee.org
*  www.sensor-networks.org
*  www.libelium.com
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
*/

int led = 13;
int onModulePin = 2;        // the pin to switch on the module (without press on button) 

int timesToSend = 1;        // Numbers of calls to make
int count = 0;

void testModule(){
  Serial.flush();
}

void switchModule(){
  digitalWrite(onModulePin,HIGH);
  delay(2000);
  digitalWrite(onModulePin,LOW);
}

void setup(){

  pinMode(led, OUTPUT);
  pinMode(onModulePin, OUTPUT);

  Serial.begin(19200);              // the GPRS baud rate
    
  switchModule();                    // swith the module ON
 
  for (int i=0;i<2;i++){
    delay(5000);                        
  } 
  
   Serial.println("AT+CMGF=1");      // set the SMS mode to text 
}

void loop(){
  
  while (count < timesToSend){
    delay(1500);
    Serial.println("ATD0999411956;");      // ********* is the number to call 
    delay(12000); 
    Serial.println("ATH");              // disconnect the call
       
    delay(5000);        

    count++;    
  }

  if (count == timesToSend){
    Serial.println("AT*PSCPOF");        // switch the module off
    count++;
  }
}

