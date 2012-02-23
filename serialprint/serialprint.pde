void setup ()
{
  Serial.begin(19200); //Epson default printer settings for baud rate for parallel type printer
}

void loop() //looping sequence
{
  Serial.print(0x1B,BYTE); //ESC POS command
  Serial.print('@'); //ESC POS initialize followed after command
  Serial.print("Hola Epson"); //Print "Hola Epson" to buffer
  Serial.print(0xA,BYTE); //Print and Line Feed from Buffer

}


