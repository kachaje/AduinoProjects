#include <SPI.h>

/*
 * Web Server
 *
 * A simple web server that shows the value of the analog input pins.
 */

#include <Ethernet.h>

byte mac[] = { 0x90, 0xA2, 0xDA, 0x00, 0x04, 0xB0 };
byte ip[] = { 192, 168, 0, 1 };
byte gateway[] = { 192, 168, 0, 2 };

Server server(80);

void setup()
{
  Ethernet.begin(mac, ip, gateway);
  server.begin();
}

void loop()
{
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
