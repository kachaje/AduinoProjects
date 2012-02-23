void setup()
{
   Serial.begin(9600); 
}

void loop()
{
    char *p;
    
    p = strtok("The summer soldier, the sunshine patriot", " ");
    Serial.print(p);
}
