
; CC5X Version 3.1I, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  28. Sep 2007  16:21  *************

	processor  16F88
	radix  DEC

INDF        EQU   0x00
PCL         EQU   0x02
FSR         EQU   0x04
PORTA       EQU   0x05
TRISA       EQU   0x85
PORTB       EQU   0x06
TRISB       EQU   0x86
PCLATH      EQU   0x0A
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
IRP         EQU   7
RCSTA       EQU   0x18
TXREG       EQU   0x19
RCREG       EQU   0x1A
TXSTA       EQU   0x98
SPBRG       EQU   0x99
ANSEL       EQU   0x9B
EEDATA      EQU   0x10C
EEADR       EQU   0x10D
EEDATH      EQU   0x10E
EEADRH      EQU   0x10F
TXIF        EQU   4
RCIF        EQU   5
RD          EQU   0
EEPGD       EQU   7
response    EQU   0x21
sht15_command EQU   0x24
i           EQU   0x25
C1cnt       EQU   0x26
C2tmp       EQU   0x27
j           EQU   0x24
in_byte     EQU   0x25
x           EQU   0x26
y           EQU   0x28
z           EQU   0x29
nate        EQU   0x36
counter     EQU   0x7F
x_2         EQU   0x36
nate_2      EQU   0x26
my_byte     EQU   0x27
i_2         EQU   0x29
k           EQU   0x2A
m           EQU   0x2B
temp        EQU   0x2C
high_byte   EQU   0x2D
low_byte    EQU   0x2E
C3cnt       EQU   0x36
C4tmp       EQU   0x37
C5cnt       EQU   0x36
C6tmp       EQU   0x37
C7cnt       EQU   0x36
C8tmp       EQU   0x37
C9rem       EQU   0x39
ci          EQU   0x36

	GOTO main

  ; FILE C:\Global\Code\16F88\SHT15-Testing\SHT15-Testing-v11.c
			;/*
			;    2-1-07
			;    Nathan Seidle
			;    nathan at sparkfun.com
			;    Copyright Spark Fun Electronics© 2007
			;
			;    Pseudo Sensirion I2C interface example code
			;
			;    Uses 16F88 with bootloader for testing
			;
			;    Reports the Humidity and Temperature in obfuscated form.
			;    Please see Sensirion datasheet for translation equations
			;    
			;    9-28-07 Correction by Iván Sarmiento. There was a small bug in the 16bit read.
			;*/
			;
			;#define Clock_8MHz
			;#define Baud_9600
			;
			;#include "c:\Global\Code\C\16F88.h"  // device dependent interrupt definitions
			;
			;#pragma origin 4
	ORG 0x0004
			;
			;#define STATUS_LED PORTB.3
			;
			;#define WRITE_sda() TRISB = TRISB & 0b.1011.1111 //SDA must be output when writing
			;#define READ_sda()  TRISB = TRISB | 0b.0100.0000 //SDA must be input when reading - don't forget the resistor on SDA!!
			;
			;#define SCK PORTB.7
			;#define SDA PORTB.6
			;
			;#define CHECK_TEMP 0b.0000.0011
			;#define CHECK_HUMD 0b.0000.0101
			;#define CHECK_STAT 0b.0000.0111
			;#define WRITE_STAT 0b.0000.0110
			;
			;void boot_up(void);
			;
			;void sht15_start(void);
			;void sht15_read(void);
			;void sht15_send_byte(uns8 sht15_command);
			;uns16 sht15_read_byte16(void);
			;
			;void delay_ms(uns16);
			;void printf(const char *nate, int16 my_byte);
			;
			;void main(void)
			;{
_const1
	MOVWF ci
	MOVLW .0
	BSF   0x03,RP1
	MOVWF EEADRH
	BCF   0x03,RP1
	RRF   ci,W
	ANDLW .127
	ADDLW .35
	BSF   0x03,RP1
	MOVWF EEADR
	BTFSC 0x03,Carry
	INCF  EEADRH,1
	BSF   0x03,RP0
	BSF   0x18C,EEPGD
	BSF   0x18C,RD
	NOP  
	NOP  
	BCF   0x03,RP0
	BCF   0x03,RP1
	BTFSC ci,0
	GOTO  m001
	BSF   0x03,RP1
	MOVF  EEDATA,W
	ANDLW .127
	BCF   0x03,RP1
	RETURN
m001	BSF   0x03,RP1
	RLF   EEDATA,W
	RLF   EEDATH,W
	BCF   0x03,RP1
	RETURN
	DW    0x298A
	DW    0x2A48
	DW    0x1AB1
	DW    0x2A20
	DW    0x39E5
	DW    0x34F4
	DW    0x33EE
	DW    0x500
	DW    0x37C4
	DW    0x32EE
	DW    0x500
	DW    0x3AC8
	DW    0x34ED
	DW    0x34E4
	DW    0x3CF4
	DW    0x34A0
	DW    0x1073
	DW    0x3225
	DW    0x500
	DW    0x32D4
	DW    0x386D
	DW    0x3965
	DW    0x3A61
	DW    0x3975
	DW    0x1065
	DW    0x39E9
	DW    0x12A0
	DW    0x64
	DW    0x290A
	DW    0x39E5
	DW    0x37F0
	DW    0x39EE
	DW    0x1065
	DW    0x34F4
	DW    0x32ED
	DW    0x1EA0
	DW    0x12A0
	DW    0x36E4
	DW    0x73
main
			;    uns8 choice;
			;
			;    boot_up();
	BSF   0x03,RP0
	BCF   0x03,RP1
	CALL  boot_up
			;
			;    delay_ms(100);
	MOVLW .100
	MOVWF x
	CLRF  x+1
	CALL  delay_ms
			;
			;    printf("\nSHT15 Testing", 0);
	CLRF  nate_2
	CLRF  my_byte
	CLRF  my_byte+1
	CALL  printf
			;
			;    sht15_read();
	CALL  sht15_read
			;
			;    printf("\nDone", 0);
	MOVLW .15
	MOVWF nate_2
	CLRF  my_byte
	CLRF  my_byte+1
	CALL  printf
			;
			;    while(1);
m002	GOTO  m002
			;
			;}//End Main
			;
			;void boot_up(void)
			;{
boot_up
			;    //OSCCON = 0b.0111.0000; //Setup internal oscillator for 8MHz
			;    //while(OSCCON.2 == 0); //Wait for frequency to stabilize
			;
			;    //Setup Ports
			;    ANSEL = 0b.0000.0000; //Turn off A/D
	CLRF  ANSEL
			;
			;    PORTA = 0b.0000.0000;
	BCF   0x03,RP0
	CLRF  PORTA
			;    TRISA = 0b.0000.0000;
	BSF   0x03,RP0
	CLRF  TRISA
			;
			;    PORTB = 0b.0000.0000;
	BCF   0x03,RP0
	CLRF  PORTB
			;    TRISB = 0b.0000.0100;   //0 = Output, 1 = Input RX on RB2
	MOVLW .4
	BSF   0x03,RP0
	MOVWF TRISB
			;
			;    //Setup the hardware UART module
			;    //=============================================================
			;    SPBRG = 51; //8MHz for 9600 inital communication baud rate
	MOVLW .51
	MOVWF SPBRG
			;    //SPBRG = 129; //20MHz for 9600 inital communication baud rate
			;
			;    TXSTA = 0b.0010.0100; //8-bit asych mode, high speed uart enabled
	MOVLW .36
	MOVWF TXSTA
			;    RCSTA = 0b.1001.0000; //Serial port enable, 8-bit asych continous receive mode
	MOVLW .144
	BCF   0x03,RP0
	MOVWF RCSTA
			;    //=============================================================
			;
			;}
	RETURN
			;
			;//Init the sensor and read out the humidity and temperature data
			;void sht15_read(void)
			;{
sht15_read
			;    uns24 response;
			;
			;    //Issue command start
			;    sht15_start();
	CALL  sht15_start
			;
			;    //Now send command code
			;    sht15_send_byte(CHECK_HUMD);
	MOVLW .5
	CALL  sht15_send_byte
			;    response = sht15_read_byte16();
	CALL  sht15_read_byte16
	MOVWF response
	MOVF  in_byte+1,W
	MOVWF response+1
	CLRF  response+2
			;    printf("\nHumidity is %d", response);
	MOVLW .21
	MOVWF nate_2
	MOVF  response,W
	MOVWF my_byte
	MOVF  response+1,W
	MOVWF my_byte+1
	CALL  printf
			;
			;    sht15_start();
	CALL  sht15_start
			;    sht15_send_byte(CHECK_TEMP);
	MOVLW .3
	CALL  sht15_send_byte
			;    response = sht15_read_byte16(); //Listen for response from SHT15
	CALL  sht15_read_byte16
	MOVWF response
	MOVF  in_byte+1,W
	MOVWF response+1
	CLRF  response+2
			;    printf("\nTemperature is %d", response);
	MOVLW .37
	MOVWF nate_2
	MOVF  response,W
	MOVWF my_byte
	MOVF  response+1,W
	MOVWF my_byte+1
	GOTO  printf
			;
			;}
			;
			;void sht15_send_byte(uns8 sht15_command)
			;{
sht15_send_byte
	MOVWF sht15_command
			;    uns8 i;
			;
			;    WRITE_sda();
	BSF   0x03,RP0
	BCF   TRISB,6
			;
			;    for(i = 0 ; i < 8 ; i++)
	BCF   0x03,RP0
	CLRF  i
m003	MOVLW .8
	SUBWF i,W
	BTFSC 0x03,Carry
	GOTO  m004
			;    {
			;        sht15_command = rl(sht15_command);
	RLF   sht15_command,1
			;        SCK = 0;
	BCF   PORTB,7
			;        SDA = Carry;
	BTFSS 0x03,Carry
	BCF   PORTB,6
	BTFSC 0x03,Carry
	BSF   PORTB,6
			;        SCK = 1;
	BSF   PORTB,7
			;    }
	INCF  i,1
	GOTO  m003
			;
			;    //Wait for SHT15 to acknowledge.
			;    SCK = 0;
m004	BCF   PORTB,7
			;    READ_sda();
	BSF   0x03,RP0
	BSF   TRISB,6
			;    while (SDA == 1); //Wait for SHT to pull line low
	BCF   0x03,RP0
m005	BTFSC PORTB,6
	GOTO  m005
			;    SCK = 1;
	BSF   PORTB,7
			;    SCK = 0; //Falling edge of 9th clock
	BCF   PORTB,7
			;
			;    while (SDA == 0); //Wait for SHT to release line
m006	BTFSS PORTB,6
	GOTO  m006
			;
			;    //Wait for SHT15 to pull SDA low to signal measurement completion.
			;    //This can take up to 210ms for 14 bit measurements
			;    i = 0;
	CLRF  i
			;    while (SDA == 1) //Wait for SHT to pull line low
m007	BTFSS PORTB,6
	GOTO  m008
			;    {
			;        i++;
	INCF  i,1
			;        if (i == 255) break;
	INCF  i,W
	BTFSC 0x03,Zero_
	GOTO  m008
			;
			;        delay_ms(10);
	MOVLW .10
	MOVWF x
	CLRF  x+1
	CALL  delay_ms
			;    }
	GOTO  m007
			;
			;    //Debug info
			;    i *= 10; //Convert to ms
m008	BCF   0x03,Carry
	RLF   i,W
	MOVWF C2tmp
	CLRF  i
	MOVLW .5
	MOVWF C1cnt
m009	MOVF  C2tmp,W
	ADDWF i,1
	DECFSZ C1cnt,1
	GOTO  m009
			;    printf("\nResponse time = %dms", i); //Debug to see how long response took
	MOVLW .56
	MOVWF nate_2
	MOVF  i,W
	MOVWF my_byte
	CLRF  my_byte+1
	GOTO  printf
			;
			;}
			;
			;//Specific SHT start command
			;void sht15_start(void)
			;{
sht15_start
			;    WRITE_sda();
	BSF   0x03,RP0
	BCF   TRISB,6
			;    SDA = 1;
	BCF   0x03,RP0
	BSF   PORTB,6
			;    SCK = 1;
	BSF   PORTB,7
			;
			;    SDA = 0;
	BCF   PORTB,6
			;    SCK = 0;
	BCF   PORTB,7
			;    SCK = 1;
	BSF   PORTB,7
			;    SDA = 1;
	BSF   PORTB,6
			;    SCK = 0;
	BCF   PORTB,7
			;}
	RETURN
			;
			;//Read 16 bits from the SHT sensor
			;uns16 sht15_read_byte16(void)
			;{
sht15_read_byte16
			;    uns8 j;
			;    uns16 in_byte;
			;
			;    SCK = 0;
	BCF   PORTB,7
			;
			;    READ_sda();
	BSF   0x03,RP0
	BSF   TRISB,6
			;
			;    /********** CHANGE *************/
			;    for(j = 0 ; j < 17 ; j++)
	BCF   0x03,RP0
	CLRF  j
m010	MOVLW .17
	SUBWF j,W
	BTFSC 0x03,Carry
	GOTO  m013
			;    {
			;        if(j!=8)
	MOVF  j,W
	XORLW .8
	BTFSC 0x03,Zero_
	GOTO  m011
			;        {
			;            nop();nop();nop();nop();
	NOP  
	NOP  
	NOP  
	NOP  
			;            SCK = 1;
	BSF   PORTB,7
			;            in_byte = rl(in_byte);
	RLF   in_byte,1
	RLF   in_byte+1,1
			;            in_byte.0 = SDA;
	BCF   in_byte,0
	BTFSC PORTB,6
	BSF   in_byte,0
			;            SCK = 0;
	BCF   PORTB,7
			;        }
			;        else
	GOTO  m012
			;        {
			;            WRITE_sda();
m011	BSF   0x03,RP0
	BCF   TRISB,6
			;            SDA = 0;
	BCF   0x03,RP0
	BCF   PORTB,6
			;            nop();
	NOP  
			;            SCK = 1; //clk #9 for acknowledge
	BSF   PORTB,7
			;            nop();nop();nop();
	NOP  
	NOP  
	NOP  
			;            SCK = 0;
	BCF   PORTB,7
			;            READ_sda();
	BSF   0x03,RP0
	BSF   TRISB,6
			;        }
			;    }
	BCF   0x03,RP0
m012	INCF  j,1
	GOTO  m010
			;    /******** END CHANGE ***********/
			;
			;    return(in_byte);
m013	MOVF  in_byte,W
	RETURN
			;}
			;
			;//Low-level system routines
			;
			;//General short delay
			;void delay_ms(uns16 x)
			;{
delay_ms
			;    //Clocks out at 1006us per 1ms
			;    uns8 y, z;
			;    for ( ; x > 0 ; x--)
m014	MOVF  x,W
	IORWF x+1,W
	BTFSC 0x03,Zero_
	GOTO  m019
			;        for ( y = 0 ; y < 4 ; y++)
	CLRF  y
m015	MOVLW .4
	SUBWF y,W
	BTFSC 0x03,Carry
	GOTO  m018
			;        for ( z = 0 ; z < 69 ; z++);
	CLRF  z
m016	MOVLW .69
	SUBWF z,W
	BTFSC 0x03,Carry
	GOTO  m017
	INCF  z,1
	GOTO  m016
m017	INCF  y,1
	GOTO  m015
m018	DECF  x,1
	INCF  x,W
	BTFSC 0x03,Zero_
	DECF  x+1,1
	GOTO  m014
			;}
m019	RETURN
			;
			;//Sends nate to the Transmit Register
			;void putc(uns8 nate)
			;{
putc
	MOVWF nate
			;    while(TXIF == 0);
m020	BTFSS 0x0C,TXIF
	GOTO  m020
			;    TXREG = nate;
	MOVF  nate,W
	MOVWF TXREG
			;}
	RETURN
			;
			;uns8 getc(void)
			;{
getc
			;    while(RCIF == 0);
	BCF   0x03,RP0
	BCF   0x03,RP1
m021	BTFSS 0x0C,RCIF
	GOTO  m021
			;    return (RCREG);
	MOVF  RCREG,W
	RETURN
			;}
			;
			;uns8 scanc(void)
			;{
scanc
			;    uns16 counter = 0;
	CLRF  counter
	CLRF  counter+1
			;
			;    //CREN = 0;
			;    //CREN = 1;
			;
			;    RCIF = 0;
	BCF   0x03,RP0
	BCF   0x03,RP1
	BCF   0x0C,RCIF
			;    while(RCIF == 0)
m022	BTFSC 0x0C,RCIF
	GOTO  m023
			;    {
			;        counter++;
	INCF  counter,1
	BTFSC 0x03,Zero_
	INCF  counter+1,1
			;        if(counter == 1000) return 0;
	MOVF  counter,W
	XORLW .232
	BTFSS 0x03,Zero_
	GOTO  m022
	MOVF  counter+1,W
	XORLW .3
	BTFSS 0x03,Zero_
	GOTO  m022
	RETLW .0
			;    }
			;
			;    return (RCREG);
m023	MOVF  RCREG,W
	RETURN
			;}
			;
			;//Returns ASCII Decimal and Hex values
			;uns8 bin2Hex(char x)
			;{
bin2Hex
	MOVWF x_2
			;    skip(x);
	MOVLW .1
	MOVWF PCLATH
	MOVF  x_2,W
	ADDWF PCL,1
			;    #pragma return[16] = "0123456789ABCDEF"
	RETLW .48
	RETLW .49
	RETLW .50
	RETLW .51
	RETLW .52
	RETLW .53
	RETLW .54
	RETLW .55
	RETLW .56
	RETLW .57
	RETLW .65
	RETLW .66
	RETLW .67
	RETLW .68
	RETLW .69
	RETLW .70
			;}
			;
			;//Prints a string including variables
			;void printf(const char *nate, int16 my_byte)
			;{
printf
			;
			;    uns8 i, k, m, temp;
			;    uns8 high_byte = 0, low_byte = 0;
	CLRF  high_byte
	CLRF  low_byte
			;    uns8 y, z;
			;
			;    uns8 decimal_output[5];
			;
			;    for(i = 0 ; ; i++)
	CLRF  i_2
			;    {
			;        //delay_ms(3);
			;
			;        k = nate[i];
m024	MOVF  i_2,W
	ADDWF nate_2,W
	CALL  _const1
	MOVWF k
			;
			;        if (k == '\0')
	MOVF  k,1
	BTFSC 0x03,Zero_
			;            break;
	GOTO  m050
			;
			;        else if (k == '%') //Print var
	XORLW .37
	BTFSS 0x03,Zero_
	GOTO  m048
			;        {
			;            i++;
	INCF  i_2,1
			;            k = nate[i];
	MOVF  i_2,W
	ADDWF nate_2,W
	CALL  _const1
	MOVWF k
			;
			;            if (k == '\0')
	MOVF  k,1
	BTFSC 0x03,Zero_
			;                break;
	GOTO  m050
			;            else if (k == '\\') //Print special characters
	XORLW .92
	BTFSS 0x03,Zero_
	GOTO  m025
			;            {
			;                i++;
	INCF  i_2,1
			;                k = nate[i];
	MOVF  i_2,W
	ADDWF nate_2,W
	CALL  _const1
	MOVWF k
			;
			;                putc(k);
	CALL  putc
			;
			;
			;            } //End Special Characters
			;            else if (k == 'b') //Print Binary
	GOTO  m049
m025	MOVF  k,W
	XORLW .98
	BTFSS 0x03,Zero_
	GOTO  m030
			;            {
			;                for( m = 0 ; m < 8 ; m++ )
	CLRF  m
m026	MOVLW .8
	SUBWF m,W
	BTFSC 0x03,Carry
	GOTO  m049
			;                {
			;                    if (my_byte.7 == 1) putc('1');
	BTFSS my_byte,7
	GOTO  m027
	MOVLW .49
	CALL  putc
			;                    if (my_byte.7 == 0) putc('0');
m027	BTFSC my_byte,7
	GOTO  m028
	MOVLW .48
	CALL  putc
			;                    if (m == 3) putc(' ');
m028	MOVF  m,W
	XORLW .3
	BTFSS 0x03,Zero_
	GOTO  m029
	MOVLW .32
	CALL  putc
			;
			;                    my_byte = my_byte << 1;
m029	BCF   0x03,Carry
	RLF   my_byte,1
	RLF   my_byte+1,1
			;                }
	INCF  m,1
	GOTO  m026
			;            } //End Binary
			;            else if (k == 'd') //Print Decimal
m030	MOVF  k,W
	XORLW .100
	BTFSS 0x03,Zero_
	GOTO  m044
			;            {
			;                //Print negative sign and take 2's compliment
			;
			;                if(my_byte < 0)
	BTFSS my_byte+1,7
	GOTO  m033
			;                {
			;                    putc('-');
	MOVLW .45
	CALL  putc
			;                    my_byte *= -1;
	MOVF  my_byte,W
	MOVWF C4tmp
	MOVF  my_byte+1,W
	MOVWF C4tmp+1
	MOVLW .16
	MOVWF C3cnt
m031	BCF   0x03,Carry
	RLF   my_byte,1
	RLF   my_byte+1,1
	RLF   C4tmp,1
	RLF   C4tmp+1,1
	BTFSS 0x03,Carry
	GOTO  m032
	DECF  my_byte+1,1
	DECF  my_byte,1
	INCFSZ my_byte,W
	INCF  my_byte+1,1
m032	DECFSZ C3cnt,1
	GOTO  m031
			;                }
			;
			;
			;                if (my_byte == 0)
m033	MOVF  my_byte,W
	IORWF my_byte+1,W
	BTFSS 0x03,Zero_
	GOTO  m034
			;                    putc('0');
	MOVLW .48
	CALL  putc
			;                else
	GOTO  m049
			;                {
			;                    //Divide number by a series of 10s
			;                    for(m = 4 ; my_byte > 0 ; m--)
m034	MOVLW .4
	MOVWF m
m035	BTFSC my_byte+1,7
	GOTO  m042
	MOVF  my_byte,W
	IORWF my_byte+1,W
	BTFSC 0x03,Zero_
	GOTO  m042
			;                    {
			;                        temp = my_byte % (uns16)10;
	MOVF  my_byte,W
	MOVWF C6tmp
	MOVF  my_byte+1,W
	MOVWF C6tmp+1
	CLRF  temp
	MOVLW .16
	MOVWF C5cnt
m036	RLF   C6tmp,1
	RLF   C6tmp+1,1
	RLF   temp,1
	BTFSC 0x03,Carry
	GOTO  m037
	MOVLW .10
	SUBWF temp,W
	BTFSS 0x03,Carry
	GOTO  m038
m037	MOVLW .10
	SUBWF temp,1
m038	DECFSZ C5cnt,1
	GOTO  m036
			;                        decimal_output[m] = temp;
	MOVLW .49
	ADDWF m,W
	MOVWF FSR
	BCF   0x03,IRP
	MOVF  temp,W
	MOVWF INDF
			;                        my_byte = my_byte / (uns16)10;
	MOVF  my_byte,W
	MOVWF C8tmp
	MOVF  my_byte+1,W
	MOVWF C8tmp+1
	CLRF  C9rem
	MOVLW .16
	MOVWF C7cnt
m039	RLF   C8tmp,1
	RLF   C8tmp+1,1
	RLF   C9rem,1
	BTFSC 0x03,Carry
	GOTO  m040
	MOVLW .10
	SUBWF C9rem,W
	BTFSS 0x03,Carry
	GOTO  m041
m040	MOVLW .10
	SUBWF C9rem,1
	BSF   0x03,Carry
m041	RLF   my_byte,1
	RLF   my_byte+1,1
	DECFSZ C7cnt,1
	GOTO  m039
			;                    }
	DECF  m,1
	GOTO  m035
			;
			;                    for(m++ ; m < 5 ; m++)
m042	INCF  m,1
m043	MOVLW .5
	SUBWF m,W
	BTFSC 0x03,Carry
	GOTO  m049
			;                        putc(bin2Hex(decimal_output[m]));
	MOVLW .49
	ADDWF m,W
	MOVWF FSR
	BCF   0x03,IRP
	MOVF  INDF,W
	CALL  bin2Hex
	CALL  putc
	INCF  m,1
	GOTO  m043
			;                }
			;
			;            } //End Decimal
			;            else if (k == 'h') //Print Hex
m044	MOVF  k,W
	XORLW .104
	BTFSS 0x03,Zero_
	GOTO  m046
			;            {
			;                //New trick 3-15-04
			;                putc('0');
	MOVLW .48
	CALL  putc
			;                putc('x');
	MOVLW .120
	CALL  putc
			;
			;                if(my_byte > 0x00FF)
	BTFSC my_byte+1,7
	GOTO  m045
	MOVF  my_byte+1,1
	BTFSC 0x03,Zero_
	GOTO  m045
			;                {
			;                    putc(bin2Hex(my_byte.high8 >> 4));
	SWAPF my_byte+1,W
	ANDLW .15
	CALL  bin2Hex
	CALL  putc
			;                    putc(bin2Hex(my_byte.high8 & 0b.0000.1111));
	MOVLW .15
	ANDWF my_byte+1,W
	CALL  bin2Hex
	CALL  putc
			;                }
			;
			;                putc(bin2Hex(my_byte.low8 >> 4));
m045	SWAPF my_byte,W
	ANDLW .15
	CALL  bin2Hex
	CALL  putc
			;                putc(bin2Hex(my_byte.low8 & 0b.0000.1111));
	MOVLW .15
	ANDWF my_byte,W
	CALL  bin2Hex
	CALL  putc
			;            } //End Hex
			;            else if (k == 'f') //Print Float
	GOTO  m049
m046	MOVF  k,W
	XORLW .102
	BTFSS 0x03,Zero_
	GOTO  m047
			;            {
			;                putc('!');
	MOVLW .33
	CALL  putc
			;            } //End Float
			;            else if (k == 'u') //Print Direct Character
	GOTO  m049
m047	MOVF  k,W
	XORLW .117
	BTFSS 0x03,Zero_
	GOTO  m049
			;            {
			;                //All ascii characters below 20 are special and screwy characters
			;                //if(my_byte > 20)
			;                putc(my_byte);
	MOVF  my_byte,W
	CALL  putc
			;            } //End Direct
			;
			;        } //End Special Chars
			;
			;        else
	GOTO  m049
			;            putc(k);
m048	MOVF  k,W
	CALL  putc
			;    }
m049	INCF  i_2,1
	GOTO  m024
			;}
m050	RETURN

	END


; *** KEY INFO ***

; 0x0083 P0   18 word(s)  0 % : boot_up
; 0x00EB P0   11 word(s)  0 % : sht15_start
; 0x0095 P0   30 word(s)  1 % : sht15_read
; 0x00B3 P0   56 word(s)  2 % : sht15_send_byte
; 0x00F6 P0   42 word(s)  2 % : sht15_read_byte16
; 0x0120 P0   24 word(s)  1 % : delay_ms
; 0x016E P0  215 word(s) 10 % : printf
; 0x0071 P0   18 word(s)  0 % : main
; 0x0138 P0    6 word(s)  0 % : putc
; 0x013E P0    6 word(s)  0 % : getc
; 0x0144 P0   21 word(s)  1 % : scanc
; 0x0159 P0   21 word(s)  1 % : bin2Hex
; 0x0004 P0   70 word(s)  3 % : _const1

; RAM usage: 27 bytes (27 local), 341 bytes free
; Maximum call level: 3
;  Codepage 0 has  578 word(s) :  28 %
;  Codepage 1 has    0 word(s) :   0 %
; Total of 539 code words (13 %)
