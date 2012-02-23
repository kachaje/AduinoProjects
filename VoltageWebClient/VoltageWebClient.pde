#include <Ethernet.h>

byte mac[] = { 
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 
  192, 168, 5, 220 };
byte gateway[] = { 192, 168, 5, 1 };
byte server[] = { 192, 168, 11, 20 }; // Dashboard application running on port 3005

Client client(server, 3005);
// Site ID as it is in the 'dashboard' database
char site = 8;

void setup()
{
  Ethernet.begin(mac, ip, gateway);
  Serial.begin(9600);    
}

void loop()
{
  // if possible, delay for 10 minutes
  delay(90000);

  Serial.println("connecting...");

  if (client.connect()) {

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
    
    client.println(output);
    client.println();
    client.stop();
  } 
  else {
    Serial.println("connection failed");
  }
}

