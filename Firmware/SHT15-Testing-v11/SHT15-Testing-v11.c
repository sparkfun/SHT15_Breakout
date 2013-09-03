/*
    2-1-07
    Nathan Seidle
    nathan at sparkfun.com
    Copyright Spark Fun Electronics© 2007

    Pseudo Sensirion I2C interface example code

    Uses 16F88 with bootloader for testing

    Reports the Humidity and Temperature in obfuscated form.
    Please see Sensirion datasheet for translation equations
    
    9-28-07 Correction by Iván Sarmiento. There was a small bug in the 16bit read.
*/

#define Clock_8MHz
#define Baud_9600

#include "c:\Global\Code\C\16F88.h"  // device dependent interrupt definitions

#pragma origin 4

#define STATUS_LED PORTB.3

#define WRITE_sda() TRISB = TRISB & 0b.1011.1111 //SDA must be output when writing
#define READ_sda()  TRISB = TRISB | 0b.0100.0000 //SDA must be input when reading - don't forget the resistor on SDA!!

#define SCK PORTB.7
#define SDA PORTB.6

#define CHECK_TEMP 0b.0000.0011
#define CHECK_HUMD 0b.0000.0101
#define CHECK_STAT 0b.0000.0111
#define WRITE_STAT 0b.0000.0110

void boot_up(void);

void sht15_start(void);
void sht15_read(void);
void sht15_send_byte(uns8 sht15_command);
uns16 sht15_read_byte16(void);

void delay_ms(uns16);
void printf(const char *nate, int16 my_byte);

void main(void)
{
    uns8 choice;

    boot_up();

    delay_ms(100);

    printf("\nSHT15 Testing", 0);

    sht15_read();

    printf("\nDone", 0);

    while(1);

}//End Main

void boot_up(void)
{
    //OSCCON = 0b.0111.0000; //Setup internal oscillator for 8MHz
    //while(OSCCON.2 == 0); //Wait for frequency to stabilize

    //Setup Ports
    ANSEL = 0b.0000.0000; //Turn off A/D

    PORTA = 0b.0000.0000;
    TRISA = 0b.0000.0000;

    PORTB = 0b.0000.0000;
    TRISB = 0b.0000.0100;   //0 = Output, 1 = Input RX on RB2

    //Setup the hardware UART module
    //=============================================================
    SPBRG = 51; //8MHz for 9600 inital communication baud rate
    //SPBRG = 129; //20MHz for 9600 inital communication baud rate

    TXSTA = 0b.0010.0100; //8-bit asych mode, high speed uart enabled
    RCSTA = 0b.1001.0000; //Serial port enable, 8-bit asych continous receive mode
    //=============================================================

}

//Init the sensor and read out the humidity and temperature data
void sht15_read(void)
{
    uns24 response;

    //Issue command start
    sht15_start();

    //Now send command code
    sht15_send_byte(CHECK_HUMD);
    response = sht15_read_byte16();
    printf("\nHumidity is %d", response);

    sht15_start();
    sht15_send_byte(CHECK_TEMP);
    response = sht15_read_byte16(); //Listen for response from SHT15
    printf("\nTemperature is %d", response);

}

void sht15_send_byte(uns8 sht15_command)
{
    uns8 i;

    WRITE_sda();

    for(i = 0 ; i < 8 ; i++)
    {
        sht15_command = rl(sht15_command);
        SCK = 0;
        SDA = Carry;
        SCK = 1;
    }

    //Wait for SHT15 to acknowledge.
    SCK = 0;
    READ_sda();
    while (SDA == 1); //Wait for SHT to pull line low
    SCK = 1;
    SCK = 0; //Falling edge of 9th clock

    while (SDA == 0); //Wait for SHT to release line

    //Wait for SHT15 to pull SDA low to signal measurement completion.
    //This can take up to 210ms for 14 bit measurements
    i = 0;
    while (SDA == 1) //Wait for SHT to pull line low
    {
        i++;
        if (i == 255) break;

        delay_ms(10);
    }

    //Debug info
    i *= 10; //Convert to ms
    printf("\nResponse time = %dms", i); //Debug to see how long response took

}

//Specific SHT start command
void sht15_start(void)
{
    WRITE_sda();
    SDA = 1;
    SCK = 1;

    SDA = 0;
    SCK = 0;
    SCK = 1;
    SDA = 1;
    SCK = 0;
}

//Read 16 bits from the SHT sensor
uns16 sht15_read_byte16(void)
{
    uns8 j;
    uns16 in_byte;

    SCK = 0;

    READ_sda();

    /********** CHANGE *************/
    for(j = 0 ; j < 17 ; j++)
    {
        if(j!=8)
        {
            nop();nop();nop();nop();
            SCK = 1;
            in_byte = rl(in_byte);
            in_byte.0 = SDA;
            SCK = 0;
        }
        else
        {
            WRITE_sda();
            SDA = 0;
            nop();
            SCK = 1; //clk #9 for acknowledge
            nop();nop();nop();
            SCK = 0;
            READ_sda();
        }
    }
    /******** END CHANGE ***********/

    return(in_byte);
}

//Low-level system routines

//General short delay
void delay_ms(uns16 x)
{
    //Clocks out at 1006us per 1ms
    uns8 y, z;
    for ( ; x > 0 ; x--)
        for ( y = 0 ; y < 4 ; y++)
        for ( z = 0 ; z < 69 ; z++);
}

//Sends nate to the Transmit Register
void putc(uns8 nate)
{
    while(TXIF == 0);
    TXREG = nate;
}

uns8 getc(void)
{
    while(RCIF == 0);
    return (RCREG);
}

uns8 scanc(void)
{
    uns16 counter = 0;

    //CREN = 0;
    //CREN = 1;

    RCIF = 0;
    while(RCIF == 0)
    {
        counter++;
        if(counter == 1000) return 0;
    }

    return (RCREG);
}

//Returns ASCII Decimal and Hex values
uns8 bin2Hex(char x)
{
    skip(x);
    #pragma return[16] = "0123456789ABCDEF"
}

//Prints a string including variables
void printf(const char *nate, int16 my_byte)
{

    uns8 i, k, m, temp;
    uns8 high_byte = 0, low_byte = 0;
    uns8 y, z;

    uns8 decimal_output[5];

    for(i = 0 ; ; i++)
    {
        //delay_ms(3);

        k = nate[i];

        if (k == '\0')
            break;

        else if (k == '%') //Print var
        {
            i++;
            k = nate[i];

            if (k == '\0')
                break;
            else if (k == '\\') //Print special characters
            {
                i++;
                k = nate[i];

                putc(k);


            } //End Special Characters
            else if (k == 'b') //Print Binary
            {
                for( m = 0 ; m < 8 ; m++ )
                {
                    if (my_byte.7 == 1) putc('1');
                    if (my_byte.7 == 0) putc('0');
                    if (m == 3) putc(' ');

                    my_byte = my_byte << 1;
                }
            } //End Binary
            else if (k == 'd') //Print Decimal
            {
                //Print negative sign and take 2's compliment

                if(my_byte < 0)
                {
                    putc('-');
                    my_byte *= -1;
                }


                if (my_byte == 0)
                    putc('0');
                else
                {
                    //Divide number by a series of 10s
                    for(m = 4 ; my_byte > 0 ; m--)
                    {
                        temp = my_byte % (uns16)10;
                        decimal_output[m] = temp;
                        my_byte = my_byte / (uns16)10;
                    }

                    for(m++ ; m < 5 ; m++)
                        putc(bin2Hex(decimal_output[m]));
                }

            } //End Decimal
            else if (k == 'h') //Print Hex
            {
                //New trick 3-15-04
                putc('0');
                putc('x');

                if(my_byte > 0x00FF)
                {
                    putc(bin2Hex(my_byte.high8 >> 4));
                    putc(bin2Hex(my_byte.high8 & 0b.0000.1111));
                }

                putc(bin2Hex(my_byte.low8 >> 4));
                putc(bin2Hex(my_byte.low8 & 0b.0000.1111));
            } //End Hex
            else if (k == 'f') //Print Float
            {
                putc('!');
            } //End Float
            else if (k == 'u') //Print Direct Character
            {
                //All ascii characters below 20 are special and screwy characters
                //if(my_byte > 20)
                putc(my_byte);
            } //End Direct

        } //End Special Chars

        else
            putc(k);
    }
}
