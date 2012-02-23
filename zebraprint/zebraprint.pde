void setup ()
{
  Serial.begin(9600); //Zebra default printer settings for baud rate for serial type printer
  Serial.print(0x0D,BYTE);
  Serial.print(0x0A,BYTE); 
  Serial.print("N");
  Serial.print(0x0D,BYTE);
  Serial.print(0x0A,BYTE);
  Serial.print("A40,50,0,2,1,1,N,\"Gerry'S World!\"");
  Serial.print(0x0D,BYTE);
  Serial.print(0x0A,BYTE); 
  Serial.print("P1");
  Serial.print(0x0D,BYTE);
  Serial.print(0x0A,BYTE);
}

void loop() //looping sequence
{
  // Serial.print('\n'); //CR/LF command
  /* Serial.print(0xDA,BYTE); //CR/LF command
  Serial.print('N'); //ESC POS initialize followed after command
  Serial.print(0xDA,BYTE); //CR/LF command
  Serial.print("Hello World from Arduino"); //Print "Hola Epson" to buffer */
  /*Serial.print(0xD,BYTE); //CR command
  Serial.print(0xA,BYTE); //LF command
  Serial.print("P1"); //Print 
  Serial.print(0xD,BYTE); //CR command
  Serial.print(0xA,BYTE); //LF command*/
  //Serial.println("P1"); //Print 

}


