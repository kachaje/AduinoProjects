//  Copyright (C) 2010 Georg Kaindl
//  http://gkaindl.com
//
//  This file is part of Arduino EthernetDHCP.
//
//  EthernetDHCP is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as
//  published by the Free Software Foundation, either version 3 of
//  the License, or (at your option) any later version.
//
//  EthernetDHCP is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with EthernetDHCP. If not, see
//  <http://www.gnu.org/licenses/>.
//

//  Illustrates how to use EthernetDHCP in synchronous (blocking)
//  mode.

#if defined(ARDUINO) && ARDUINO > 18
#include <SPI.h>
#endif
#include <Ethernet.h>
#include <EthernetDHCP.h>

byte mac[] = { 
  0x90, 0xA2, 0xDA, 0x00, 0x04, 0xB0 };

const char* ip_to_str(const uint8_t*);

Server server(80);

// Define the number of samples to keep track of.  The higher the number,
// the more the readings will be smoothed, but the slower the output will
// respond to the input.  Using a constant rather than a normal variable lets
// use this value to determine the size of the readings array.
const int numReadings = 10;

int index[4];                  // the index of the current reading

int readings[4][numReadings];      // the readings from the analog input
int total[4];                  // the running total
int average[4];                // the average

void setup()
{
  Serial.begin(9600);

  Serial.println("Attempting to obtain a DHCP lease...");

  // Initiate a DHCP session. The argument is the MAC (hardware) address that
  // you want your Ethernet shield to use. This call will block until a DHCP
  // lease has been obtained. The request will be periodically resent until
  // a lease is granted, but if there is no DHCP server on the network or if
  // the server fails to respond, this call will block forever.
  // Thus, you can alternatively use polling mode to check whether a DHCP
  // lease has been obtained, so that you can react if the server does not
  // respond (see the PollingDHCP example).
  EthernetDHCP.begin(mac);

  // Since we're here, it means that we now have a DHCP lease, so we print
  // out some information.
  const byte* ipAddr = EthernetDHCP.ipAddress();
  const byte* gatewayAddr = EthernetDHCP.gatewayIpAddress();
  const byte* dnsAddr = EthernetDHCP.dnsIpAddress();

  Serial.println("A DHCP lease has been obtained.");

  Serial.print("My IP address is ");
  Serial.println(ip_to_str(ipAddr));

  Serial.print("Gateway IP address is ");
  Serial.println(ip_to_str(gatewayAddr));

  Serial.print("DNS IP address is ");
  Serial.println(ip_to_str(dnsAddr));

  //for (int i = 0; i < 4; i++) {
  //  readings[i] = [numReadings];  
  //}
  
  for (int thisReading = 0; thisReading < numReadings; thisReading++){
    readings[0][thisReading] = 0;
    readings[1][thisReading] = 0;
    readings[2][thisReading] = 0;
    readings[3][thisReading] = 0;
  }

  server.begin();
}

void loop()
{
  // You should periodically call this method in your loop(): It will allow
  // the DHCP library to maintain your DHCP lease, which means that it will
  // periodically renew the lease and rebind if the lease cannot be renewed.
  // Thus, unless you call this somewhere in your loop, your DHCP lease might
  // expire, which you probably do not want :-)
  EthernetDHCP.maintain();
  Client client = server.available();

  for (int i = 3; i >= 0; i--) {
    // subtract the last reading:
    total[i]= total[i] - readings[i][index[i]];        
    // read from the sensor:  
    readings[i][index[i]] = analogRead(i);
    // add the reading to the total:
    total[i]= total[i] + readings[i][index[i]];      
    // advance to the next position in the array:  
    index[i] = index[i] + 1;                    

    // if we're at the end of the array...
    if (index[i] >= numReadings)              
      // ...wrap around to the beginning:
      index[i] = 0;                          

    // calculate the average:
    average[i] = total[i] / numReadings;   
  }

  if (client) {
    // an http request ends with a blank line
    boolean current_line_is_blank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        // if we've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so we can send a reply
        if (c == '\n' && current_line_is_blank) {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();

          // keep previous value for subtracting later
          double previous = 0.0; 
          // output the value of each analog input pin
          for (int i = 0; i <= 3; i++) {
            client.print("Battery ");
            client.print(i+1);
            client.print(" is ");
            double bv = average[i];
            
            bv = (5 * bv/1024) * 12.0131291;
            
            double current = bv - previous;
            
            previous = bv;
            
            client.print(current);
            client.println("<br />");
          }
          break;
        }
        if (c == '\n') {
          // we're starting a new line
          current_line_is_blank = true;
        } 
        else if (c != '\r') {
          // we've gotten a character on the current line
          current_line_is_blank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    client.stop();
  }
}

// Just a utility function to nicely format an IP address.
const char* ip_to_str(const uint8_t* ipAddr)
{
  static char buf[16];
  sprintf(buf, "%d.%d.%d.%d\0", ipAddr[0], ipAddr[1], ipAddr[2], ipAddr[3]);
  return buf;
}

