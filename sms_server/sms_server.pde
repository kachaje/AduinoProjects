/*
 * Web Server
 *
 * A simple web server that shows the value of the analog input pins.
 */

#include <Ethernet.h>
#include <SoftwareSerial.h>

SoftwareSerial serial(0, 1);

char c;

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 5, 221 };
byte gateway[] = { 192, 168, 5, 1 };

Server server(80);

void setup()
{
  Ethernet.begin(mac, ip, gateway);
  server.begin();
  pinMode(0, INPUT);
  pinMode(1, OUTPUT);
  serial.begin(9600);
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

          serial.println();
          // print a sample string of text similar to what is sent to the printer
          serial.println("N");
          serial.println("q817");
          serial.println("Q305,026");
          serial.println("ZT");
          serial.println("HTTP/1.1 200 OK");
          serial.println("Content-Type: text/html");
          serial.println("P1");
          serial.println("");

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

