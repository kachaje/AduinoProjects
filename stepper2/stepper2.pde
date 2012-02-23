
/* Program 1
 
 Stepper motor demo for pf35t-48 and 55mod48 and Airpax
 This particular stepper motor is 7.5 degrees per step 
 so it requires 48 steps for 360 degrees.
 
 Another motor this circuit/program was tested on was a Teac motor
 removed from a 5.25 inch floppy drive. At 1.8 degrees per step it
 required 200 steps for 360 degrees. All wire colors were brown. 
 
 Depending on the type motor swap the four numbers below (8 - 11) until motor works.
 
 The sequence below was derived at by experimentation.  
 
 Speed is controlled by a delay between each step. 
 The longer the delay the slower the rotation.
 That delay value is obtained by reading and analog-to-digital
 cover (AD0 in this case) which gives a value from 0 to 1023.
 See diagram below.
 The value is divided by 4 and add 10 for a delay 
 in milliseconds:  delay(analogRead(0)/4 +10)
 For faster speeds change 10 to say 2.
 This is calculated between every step to vary speed while stepping.
 
 The commands below will be compiled into machine code and uploaded 
 to the microcontroller. 
 
 Compiled size 1896 bytes.
 
 */

#define yellow 8  //Q1
#define orange 9  //Q2
#define brown 10  // Q3
#define black 11 // Q4

#define CW 3 // SW0 in schematic
#define CCW 4  //SW1 in schematic



void setup()  {


  pinMode(CW, INPUT);
  pinMode(CCW, INPUT);

  digitalWrite(CW, 1); // pull up on
  digitalWrite(CCW,1); // pull up on

  pinMode(black, OUTPUT);
  pinMode(brown, OUTPUT);
  pinMode(orange, OUTPUT);
  pinMode(yellow, OUTPUT);

  // all coils off
  digitalWrite(black, 0);
  digitalWrite(brown, 0);
  digitalWrite(orange, 0);
  digitalWrite(yellow, 0);

}



void loop() {

  //if (!digitalRead(CW))  { 

    //forward(200);
    //all_coils_off();  
  //}


  //if (!digitalRead(CCW))  { 

   reverse(200);
   all_coils_off();  
  //}      

} // end loop


void all_coils_off(void)  {

  digitalWrite(black, 0);
  digitalWrite(brown, 0);
  digitalWrite(orange, 0);
  digitalWrite(yellow, 0); 

}


void reverse(int i) {

  while (1)   {

    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(analogRead(0)/4 + 10);  
    i--;
    if (i < 1) break;


    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(analogRead(0)/4 + 10);
    i--;
    if (i < 1) break;


    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(analogRead(0)/4 + 10);  
    i--;
    if (i < 1) break;

    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(analogRead(0)/4 +10);
    i--;
    if (i < 1) break;
  }

}



void forward(int i) {



  while (1)   {

    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(analogRead(0)/4 +10);
    i--;
    if (i < 1) break;

    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 0);
    digitalWrite(yellow, 1);
    delay(analogRead(0)/4 +10);
    i--;
    if (i < 1) break;

    digitalWrite(black, 0);
    digitalWrite(brown, 1);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(analogRead(0)/4 +10);
    i--;
    if (i < 1) break;

    digitalWrite(black, 1);
    digitalWrite(brown, 0);
    digitalWrite(orange, 1);
    digitalWrite(yellow, 0);
    delay(analogRead(0)/4 +10);
    i--;
    if (i < 1) break;
  }
}




