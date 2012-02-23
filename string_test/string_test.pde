char s[80] = "";
char incoming_char;
int j = 0;

void setup()
{
  //Initialize serial ports for communication.
  Serial.begin(9600);
  // pin 13 is for good connection
  pinMode(13, OUTPUT); 
  // pin 12 is for bad connection
  pinMode(12, OUTPUT); 
  
  // Initialise s[] container
  clearBuffer();
}

void loop()
{
  if(Serial.available() >0)
  {
     incoming_char=Serial.read();  //Get the character coming from the terminal
     
     //strcat(s, c(incoming_char));
     if(incoming_char != 0x0D){
        s[j] = incoming_char;
        j++;
     } else {
        Serial.println(s);
        
        if(strcmp(s, "red on")){            
            digitalWrite(13, HIGH);   // set the LED on
            digitalWrite(12, LOW);   // set the LED off
        } else if(strcmp(s, "green on")){
            digitalWrite(12, HIGH);   // set the LED on
            digitalWrite(13, LOW);   // set the LED off
        }
        
        clearBuffer();
        j = 0; 
     }
  }
  // Serial.println(s);
  
  delay(100);
}

void clearBuffer(){
   int i = 0;
   for(i = 0; i < 80; i++){
      s[i] = '\0'; 
   }
}
