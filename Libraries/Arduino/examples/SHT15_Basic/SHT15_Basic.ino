/******************************************************************************
SHT15 Example
Joel Bartlett @ SparkFun Electronics
16 Sept 2015
https://github.com/sparkfun/SparkFun_ISL29125_Breakout_Arduino_Library

This example shows how to get the temperature in F or C and humidity
Developed/Tested with:
SparkFun RedBoard 
Arduino IDE 1.6.5

Connections:
GND  -> A2
Vcc  -> A3
DATA -> A4
SCK  -> A5

Requires:
SparkFun_SHT1X Arduino Library
https://github.com/sparkfun/SHT15_Breakout/

This code is beerware.
Distributed as-is; no warranty is given. 
******************************************************************************/
#include <SHT1X.h>

//variables for storing values
float tempC = 0;
float tempF = 0;
float humidity = 0;

//Create an instance of the SHT1X sensor
SHT1x sht15(A4, A5);//Data, SCK

//delacre output pins for powering the sensor
int power = A3;
int gnd = A2;

void setup()
{
  Serial.begin(9600); // Open serial connection to report values to host

  pinMode(power, OUTPUT);
  pinMode(gnd, OUTPUT);

  digitalWrite(power, HIGH);
  digitalWrite(gnd, LOW);
}
//-------------------------------------------------------------------------------------------
void loop()
{
  readSensor();
  printOut();
  delay(1000);
}
//-------------------------------------------------------------------------------------------
void readSensor()
{
  // Read values from the sensor
  tempC = sht15.readTemperatureC();
  tempF = sht15.readTemperatureF();
  humidity = sht15.readHumidity();  
}
//-------------------------------------------------------------------------------------------
void printOut()
{
  Serial.print(" Temp = ");
  Serial.print(tempF);
  Serial.print("F, ");
  Serial.print(tempC);
  Serial.println("C");
  Serial.print(" Humidity = ");
  Serial.print(humidity); 
  Serial.println("%");
}
