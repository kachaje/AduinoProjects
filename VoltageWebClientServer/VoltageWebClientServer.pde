#include <SPI.h>

#include <Ethernet.h>

byte mac[] = { 
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 
  172, 16, 1, 100 };
byte gateway[] = { 172, 16, 1, 1 };
byte appServer[] = { 172, 16, 1, 101 }; // Dashboard application running on port 3005

Server server(80);

Client appClient(appServer, 3005);
// Site ID as it is in the 'dashboard' database
char site = 8;

void setup()
{
  Ethernet.begin(mac, ip, gateway);
  Serial.begin(9600); 
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
  // if possible, delay for 10 minutes
  delay(1000);

  Serial.println("connecting...");

  if (appClient.connect()) {

    // keep previous value for subtracting later
    double previous = 0.0; 
    // where we keep the output string
    char output[256] = "GET /post/reading?site=";
    char sitestr[30];
    
    sprintf(sitestr, "%i%s", site, "&var=voltage");
    
    strcat(output, sitestr);
    
    // output the value of each analog input pin
    for (int i = 0; i < 4; i++) {
      double bv = analogRead(i);
      bv = (4.83 * bv/1024) * 12.0131291;

      // if the value of previous == 0, we move on as it's not relevant
      if(previous > 0.0){
        bv = bv - previous;
      }

      // increment the value of previous value by bv.
      previous += bv;
      
      char input[50];
      
      Serial.println(bv);
      
      Serial.println(bv/int(bv));
      
      Serial.println(int(bv * 100) % 100);
      
      sprintf(input, "%s%i%s%i.%i%i", "&voltage", (i+1), "=", int(bv), int(int(bv * 100) % 100)/10, int(int(bv * 100) % 100)%10);
      
      Serial.println(input);
      
      strcat(output, input);
      
      Serial.println(output);
      
    }

    Serial.println("connected");
    
    strcat(output, " HTTP/1.0");
    
    Serial.println(output);
    
    appClient.println(output);
    appClient.println();
    appClient.stop();
  } 
  else {
    Serial.println("connection failed");
  }
}

