static unsigned char _c; 

void setup() 
{
  Serial.begin(9600); 
} 

void loop() 
{

  // read in a byte, and send it back immediately 
  
        // send data only when you receive data: 
        if (Serial.available() > 0) {
                // read the incoming byte:
                _c = Serial.read();

                // say what you got:
                Serial.println(_c);  
                
                //delay(1);
                
                char b = (_c == 'f');
                
                Serial.println(b);
                
                if(_c == 'f'){
                   Serial.println("");
                   Serial.println("FORWARD");
                }
        }
        
        // must have delay for emulino to work
        delay(1);

}
