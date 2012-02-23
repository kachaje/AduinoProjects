// Wire Master Writer
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Writes data to an I2C/TWI slave device
// Refer to the "Wire Slave Receiver" example for use with this

// Created 29 March 2006

#include <WiServer.h>
#include <string.h>

#define WIRELESS_MODE_INFRA   1
#define WIRELESS_MODE_ADHOC   2

#include <Wire.h>

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = { 
  192,168,1,3};   // IP address of WiShield
unsigned char gateway_ip[] = { 
  192,168,1,1};   // router or gateway IP address
unsigned char subnet_mask[] = { 
  255,255,255,0};   // subnet mask for the local network
const prog_char ssid[] PROGMEM = { 
  "Huawei"};      // max 32 bytes
unsigned char security_type = 0;   // 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = { 
  "royce"};   // max 64 characters

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

char z = 'r';

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);

  WiServer.init(sendPage);

  pinMode(3, OUTPUT);     

  Serial.println("Robota Version 0.1a");
  delay(50); // reset delay  
}


// This is our page serving function that generates web pages
boolean sendPage(char* URL) {
  if (URL[1] == '?' && URL[2] == 'a' && URL[3] == 'c' && URL[4] == 't' && URL[5] == 'i' && URL[6] == 'o' && URL[7] == 'n' && URL[8] == '=') //url has a leading /
  {
    z = URL[9];

    Serial.println(z);

    switch(z){
    case 'l':
      digitalWrite(3, HIGH);   // set the LED on
      break;
    case 'o':
      digitalWrite(3, LOW);    // set the LED off
      break;
    default:
      Serial.println("bagalazi!");
      Wire.beginTransmission(4); // transmit to device #4
      Wire.send(z);              // sends one byte  
      Wire.endTransmission();    // stop transmitting

      WiServer.print("<HTML><HEAD></HEAD><BODY>");
      
      Wire.requestFrom(4, 6);    // request 6 bytes from slave device #2

      while(Wire.available())    // slave may send less than requested
      { 
        char c = Wire.receive(); // receive a byte as character
        Serial.print(c);         // print the character
        WiServer.print(c);
      }

      WiServer.print("</BODY></HTML>");

      return true;

      delay(10);
    }
  }
}

void loop()
{
  // Run WiServer
  WiServer.server_task();

}







