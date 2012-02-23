/*
SparkFun Cellular Shield - Pass-Through Sample Sketch
 SparkFun Electronics
 Written by Ryan Owens
 3/8/10
 
 Description: This sketch is written to interface an Arduino Duemillanove to a  Cellular Shield from SparkFun Electronics.
 The cellular shield can be purchased here: http://www.sparkfun.com/commerce/product_info.php?products_id=9607
 In this sketch serial commands are passed from a terminal program to the SM5100B cellular module; and responses from the cellular
 module are posted in the terminal. More information is found in the sketch comments.
 
 An activated SIM card must be inserted into the SIM card holder on the board in order to use the device!
 
 This sketch utilizes the NewSoftSerial library written by Mikal Hart of Arduiniana. The library can be downloaded at this URL:
 http://arduiniana.org/libraries/NewSoftSerial/
 
 This code is provided under the Creative Commons Attribution License. More information can be found here:
 http://creativecommons.org/licenses/by/3.0/
 
 (Use our code freely! Please just remember to give us credit where it's due. Thanks!)
 */

#include <NewSoftSerial.h>  //Include the NewSoftSerial library to send serial commands to the cellular module.
#include <string.h>         //Used for string manipulations
#include <SoftwareSerial.h>

const int strLen = 255;

char s[strLen] = "";
int j = 0;
char incoming_char=0;      //Will hold the incoming character from the Serial Port.
int initialised = 0;

NewSoftSerial cell(2,3);  //Create a 'fake' serial port. Pin 2 is the Rx pin, pin 3 is the Tx pin.
SoftwareSerial serial(0, 1);

void clearBuffer(){
  int i = 0;
  for(i = 0; i < strLen; i++){
    s[i] = ' '; 
  }
}

void setup()
{
  pinMode(0, INPUT);
  pinMode(1, OUTPUT);
  //Initialize serial ports for communication.
  Serial.begin(9600);
  cell.begin(9600);
  serial.begin(9600);
  delay(1000);

  // Initialise s[] container
  clearBuffer();

  //Let's get started!
  Serial.println("Starting SM5100B Communication...");

}

void loop() {
  //If a character comes in from the cellular module...
  if(cell.available() >0)
  {    
    incoming_char=cell.read();    //Get the character from the cellular serial port.

    if(incoming_char != 0x0D){
      s[j] = incoming_char;
      j++;
    } 
    else {
      Serial.println(s[1]);
      Serial.println(s[2]);
      Serial.println(s[3]);
      Serial.println(s[4]);
      Serial.println(s[5]);
      if(s[1] == '+' && s[2] == 'S' && s[3] == 'I' && s[4] == 'N' && s[5] == 'D' && s[6] == ':' && s[8] == '4'){
        initialised = 1;
        Serial.println("in");
      } 
      else if(initialised == 3 && s[1] == 'O' && s[2] == 'K') {           
        clearBuffer();
        initialised = 2; 
      } 
      /*else if(initialised == 3 && s[1] == '+' && s[2] == 'C' && s[3] == 'M' && s[4] == 'G'){         
       serial.println("N");  
       serial.println("q817");  
       serial.println("Q305,026");  
       serial.println("ZT");   
       }
       
       if(initialised == 3){
       serial.print("A40,30,0,2,2,2,N,");
       serial.println(s);  
       }*/

      Serial.println(initialised);
      Serial.println(s);
      clearBuffer();
      j = 0; 
    }

    if(initialised == 1){
      cell.println("AT");
      initialised = 2;

      delay(100);

      cell.println("AT+CMGF=1");

      delay(100);

    } 
    else if(initialised == 2){
      cell.println("AT+CMGF?");

      delay(100);

      cell.println("AT+CMGL=\"ALL\"");
      //Serial.println("AT+CMGL=\"ALL\"");

      //delay(2000);      
      clearBuffer();
      initialised = 3;
    }

    //Serial.print(incoming_char);  //Print the incoming character to the terminal.
  } 
  else if(initialised == 3){
    serial.println();
    serial.println("N");  
    serial.println("q817");  
    serial.println("Q305,026");  
    serial.println("ZT"); 
    serial.print("A40,30,0,2,2,2,N,\"A message in\"");  
    //serial.println(s);  
    serial.println("P1");  
    serial.println("");  

    initialised = 2;
    Serial.println(s);     
    clearBuffer();
    cell.println("AT+CMGD=1,3"); // delete all read smses
    delay(2000);
  } 
  else {
    delay(5000);    // wait 5 seconds

    Serial.println(initialised);

    if(initialised == 2){
      cell.println("AT"); 
    }
    //Serial.println("cell out: polling"); 
  }

  //If a character is coming from the terminal to the Arduino...
  if(Serial.available() >0)
  {
    incoming_char=Serial.read();  //Get the character coming from the terminal
    cell.print(incoming_char);    //Send the character to the cellular module.
  }
}

/* SM5100B Quck Reference for AT Command Set
 *Unless otherwise noted AT commands are ended by pressing the 'enter' key.
 
 1.) Make sure the proper GSM band has been selected for your country. For the US the band must be set to 7.
 To set the band, use this command: AT+SBAND=7
 
 2.) After powering on the Arduino with the shield installed, verify that the module reads and recognizes the SIM card.
 With a terimal window open and set to Arduino port and 9600 buad, power on the Arduino. The startup sequence should look something
 like this:
 
 Starting SM5100B Communication...
 
 +SIND: 1
 +SIND: 10,"SM",1,"FD",1,"LD",1,"MC",1,"RC",1,"ME",1
 
 Communication with the module starts after the first line is displayed. The second line of communication, +SIND: 10, tells us if the module
 can see a SIM card. If the SIM card is detected every other field is a 1; if the SIM card is not detected every other field is a 0.
 
 3.) Wait for a network connection before you start sending commands. After the +SIND: 10 response the module will automatically start trying
 to connect to a network. Wait until you receive the following repsones:
 
 +SIND: 11
 +SIND: 3
 +SIND: 4
 
 The +SIND response from the cellular module tells the the modules status. Here's a quick run-down of the response meanings:
 0 SIM card removed
 1 SIM card inserted
 2 Ring melody
 3 AT module is partially ready
 4 AT module is totally ready
 5 ID of released calls
 6 Released call whose ID=<idx>
 7 The network service is available for an emergency call
 8 The network is lost
 9 Audio ON
 10 Show the status of each phonebook after init phrase
 11 Registered to network
 
 After registering on the network you can begin interaction. Here are a few simple and useful commands to get started:
 
 To make a call:
 AT command - ATDxxxyyyzzzz
 Phone number with the format: (xxx)yyy-zzz
 
 If you make a phone call make sure to reference the devices datasheet to hook up a microphone and speaker to the shield.
 
 To send a txt message:
 AT command - AT+CMGF=1
 This command sets the text message mode to 'text.'
 AT command = AT+CMGS="xxxyyyzzzz"(carriage return)'Text to send'(CTRL+Z)
 This command is slightly confusing to describe. The phone number, in the format (xxx)yyy-zzzz goes inside double quotations. Press 'enter' after closing the quotations.
 Next enter the text to be send. End the AT command by sending CTRL+Z. This character can't be sent from Arduino's terminal. Use an alternate terminal program like Hyperterminal,
 Tera Term, Bray Terminal or X-CTU.
 
 The SM5100B module can do much more than this! Check out the datasheets on the product page to learn more about the module.
 */







