#if defined(ARDUINO) && ARDUINO > 18
#include <SPI.h>
#endif
#include <Ethernet.h>
#include <EthernetDHCP.h>

byte mac[] = { 0x90, 0xA2, 0xDA, 0x00, 0x04, 0xB0 };

const char* ip_to_str(const uint8_t*);

Server server(80);

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
          for (int i = 3; i >= 0; i--) {
            client.print("Battery ");
            client.print(i+1);
            client.print(" is ");
            double bv = analogRead(i);
            bv = (4.83 * bv/1024) * 12.0131291;
            
            // if the value of previous == 0, we move on as it's not relevant
            if(previous < 3){
              bv = bv - previous;
            }
            
            // increment the value of previous value by bv.
            previous += bv;
            
            client.print(bv);
            client.println("<br />");
          }
          break;
        }
        if (c == '\n') {
          // we're starting a new line
          current_line_is_blank = true;
        } else if (c != '\r') {
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
