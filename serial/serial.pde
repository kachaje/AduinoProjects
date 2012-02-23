#include <SoftwareSerial.h>

SoftwareSerial serial(0, 1);

char c;

void setup()
{
  pinMode(0, INPUT);
  pinMode(1, OUTPUT);
  serial.begin(9600);
  delay(1000);
  serial.println();
  // print a sample string of text similar to what is sent to the printer
  serial.println("N");
  serial.println("q817");
  serial.println("Q305,026");
  serial.println("ZT");
  serial.println("B40,180,0,1,5,15,120,N,\"P170000302321\"");
  serial.println("A40,30,0,2,2,2,N,\"Fatuma Mustapha\"");
  serial.println("A40,80,0,2,2,2,N,\"P1700-0030-2321 04/Feb/1978(F)\"");
  serial.println("A40,130,0,2,2,2,N,\"TA: Kalembo\"");
  serial.println("P1");
  serial.println("");
}

void loop()
{
  c = serial.read();
  serial.print(c);
} 
