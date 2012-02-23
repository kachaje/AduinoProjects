/* MAX3421E USB Host controller keyboard communication */
#include <avrpins.h>
#include <max3421e.h>
#include <usbhost.h>
#include <usb_ch9.h>
#include <Usb.h>
#include <usbhub.h>
#include <avr/pgmspace.h>
#include <address.h>
#include "pgmstrings.h"

USB     Usb;
USBHub  Hub1(&Usb);
USBHub  Hub2(&Usb);
USBHub  Hub3(&Usb);
USBHub  Hub4(&Usb);

uint32_t next_time;
 
/* keyboard data taken from configuration descriptor */
#define KBD_ADDR  1
#define KBD_EP    1
#define EP_MAXPKTSIZE  8
#define EP_POLL        0x0a

void setup()
{
    Serial.begin( 115200 );
    Serial.println("Start");
    delay( 200 );
    
    next_time = millis() + 10000;
}
 
void loop()
{
    Usb.Task();
    if( Usb.getUsbTaskState() == USB_STATE_CONFIGURING ) {  //wait for addressing state
        kbd_init();
        Usb.setUsbTaskState( USB_STATE_RUNNING );
    }
    if( Usb.getUsbTaskState() == USB_STATE_RUNNING ) {  //poll the keyboard
        kbd_poll();
    }
}
/* Initialize keyboard */
void kbd_init( void )
{
  byte rcode = 0;  //return code
/**/
    /* Initialize data structures */
    ep_record[ 0 ] = *( Usb.getDevTableEntry( 0,0 ));  //copy endpoint 0 parameters
    ep_record[ 1 ].MaxPktSize = EP_MAXPKTSIZE;
    ep_record[ 1 ].Interval  = EP_POLL;
    ep_record[ 1 ].sndToggle = bmSNDTOG0;
    ep_record[ 1 ].rcvToggle = bmRCVTOG0;
    Usb.setDevTableEntry( 1, ep_record );              //plug kbd.endpoint parameters to devtable
    /* Configure device */
    rcode = Usb.setConf( KBD_ADDR, 0, 1 );
    if( rcode ) {
        Serial.print("Error attempting to configure keyboard. Return code :");
        Serial.println( rcode, HEX );
        while(1);  //stop
    }
    /* Set boot protocol */
    rcode = Usb.setProto( KBD_ADDR, 0, 0, 0 );
    if( rcode ) {
        Serial.print("Error attempting to configure boot protocol. Return code :");
        Serial.println( rcode, HEX );
        while( 1 );  //stop
    }
}
/* Poll keyboard and print result */
void kbd_poll( void )
{
  char i, j;
  char buf[ 8 ] = { 0 };      //keyboard buffer
  static char old_buf[ 8 ] = { 0 };  //last poll
  byte rcode = 0;     //return code
    /* poll keyboard */
    rcode = Usb.inTransfer( KBD_ADDR, KBD_EP, 8, buf );
    if( rcode != 0 ) {
        return;
    }//if ( rcode..
    for( i = 0; i < 8; i++ ) {
        if( buf[ i ] != old_buf[ i ] ) {
            for( j = 0; j < 8; j++ ) {
                Serial.print( buf[ j ], HEX );
                Serial.print(" ");
                old_buf[ j ] = buf[ j ];
            }//for( j = ...
            Serial.println("");
        }//if( buf...
    }// for( i = 0...
}
