/***************************************************************************/
/// <summary>
///  <title>SLIC TreeWheeler Model</title>
///  <description>TreeWheeler Model for TreeWheeler type Vehicle Details</description>
///  <copyRight>Copyright (c) 2010</copyRight>
///  <company>IronOne Technologies (Pvt)Ltd</company>
///  <createdOn>2011-08-01</createdOn>
///  <author></author>
///  <modification>
///     <modifiedBy></modifiedBy>
///      <modifiedDate></modifiedDate>
///     <description></description>
///  </modification>
///
/// </summary>
/***************************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.VehicleArrays
{
    public class Motorcycle
    {
        private static string[][][,] MotorcycleArray = new string[][][,]
                                                           {
                                                               new string[][,]
                                                                   {
                                                                    //grey
                                                                       new string[,]
                                                                           {
                                                                                //dark grey
                                                                               {"Motorcycle", "All Parts"},
                                                                               {"Head Light Lh", ""},
                                                                               {"Head Light", ""},
                                                                               {"Head Light Cowling", ""},
                                                                               {"Visor", ""},
                                                                               {"Meter", ""},
                                                                               {"Handle", ""},
                                                                               {"Front R/H Signal Light", ""},
                                                                               {"Front L/H Signal Light", ""},
                                                                               {"Front R/H Mirror", ""},
                                                                               {"Front L/H Mirror", ""},
                                                                               {"Clutch Lever", ""},
                                                                               {"Break Lever", ""},
                                                                               {"Clutch cable", ""},
                                                                               {"Break cable", ""},
                                                                               {"Ignition Switch", ""},
                                                                               {"Handle Switch Left", ""},
                                                                               {"Handle Switch Right", ""},
                                                                               {"Front Fork Tube", ""},
                                                                               {"Front Fork Seal", ""},
                                                                               {"Petrol Tank", ""},
                                                                               {"Petrol Tank Lid", ""},
                                                                               {"P/Tank cowling (L/R)", ""},
                                                                               {"T Column", ""},
                                                                               {"Top Column", ""},
                                                                               {"Handle Bolt", ""},
                                                                               {"Handle cup set upper", ""},
                                                                               {"Handle cup set Lover", ""},
                                                                               {"Speedometer", ""},
                                                                               {"Speedometer cable", ""},
                                                                               {"Front Hub", ""},
                                                                               {"Front Disk", ""},
                                                                               {"Wheel Rim", ""},
                                                                               {"Alloy Wheel Rim", ""},
                                                                               {"Liver set Front", ""},
                                                                               {"Front Tire", ""},
                                                                               {"Front Tire Tube", ""},
                                                                               {"Front Fender", ""},
                                                                               {"Seat", ""},
                                                                               {"Seat Cowling (L/R)", ""},
                                                                               {"Handle Balancer", ""},
                                                                               {"Seat Grip", ""},
                                                                               {"Right Side Cover", ""},
                                                                               {"Left side cover", ""},
                                                                               {"Kick Paddle", ""},
                                                                               {"Break Paddle", ""},
                                                                               {"Gear Lever", ""},
                                                                               {"Right side Front Footrest", ""},
                                                                               {"Right side Rear Footrest", ""},
                                                                               {"Left side Front Footrest", ""},
                                                                               {"Left side Rear Footrest", ""},
                                                                               {"Foot-rest Rubber", ""},
                                                                               {"Sari Guard", ""},
                                                                               {"Swing Arm", ""},
                                                                               {"Silencer", ""},
                                                                               {"Silencer Guard", ""},
                                                                               {"Crash Bar", ""},
                                                                               {"Right Fender", ""},
                                                                               {"Rear Right Signal Light", ""},
                                                                               {"Rear Left signal Light", ""},
                                                                               {"Break Light", ""},
                                                                               {"Rear Wheel Rim", ""},
                                                                               {"Right Alloy Wheel Rim", ""},
                                                                               {"Rear Tire", ""},
                                                                               {"Rear Tire Tube", ""},
                                                                               {"Chain", ""},
                                                                               {"Spoke", ""},
                                                                               {"Chain Case", ""},
                                                                               {"Main Stand", ""},
                                                                               {"Side Stand", ""},
                                                                               {"Battery", ""},
                                                                               {"Footrest Holder RH", ""},
                                                                               {"Footrest Holder LH", ""},
                                                                               {"Tank Sticker set", ""},
                                                                               {"Tail cover Sticker LH/RH", ""},
                                                                               {"R Shock Absorber (LH/RH)", ""},
                                                                               {"Front panel Top", ""},
                                                                               {"Front panel Bottom", ""},
                                                                               {"Rear RH Panel Bottom", ""},
                                                                               {"Rear LH Panel Bottom", ""},
                                                                               {"Rear RH Panel Top", ""},
                                                                               {"Rear LH Panel Top", ""},
                                                                               {"Break caliper", ""},
                                                                               {"Fork Oil", ""},
                                                                               {"Head Light Bracket", ""},
                                                                               {"R Additional Cover", ""},
                                                                               {"Starter Motor", ""},
                                                                               {"Break servo Tank", ""},
                                                                               {"Chock Cable", ""},
                                                                               {"Number Plate", ""},
                                                                               {"Side panels (for scooters)", ""},
                                                                               {"Top panels (for scooters)", ""},
                                                                               {"v-panels (for scooters)", ""},
                                                                               {"Center panels (for scooters)", ""},
                                                                               {"R/S bottom panels (for scooters)", ""},
                                                                               {"L/S bottom pales (for scooters)", ""},
                                                                               {"Front buckets (for scooters)", ""},
                                                                               {"Back rests", ""},
                                                                               {"Rear crash bars", ""},
                                                                               {"CDI unit", ""}
                                                                           }

                                                                   }
                                                           };

        internal string[] GetDamagedItemList(int[] arrayPosition)
        {
            return new string[]
                       {
                           MotorcycleArray[0][0][0, 0], MotorcycleArray[arrayPosition[0]][arrayPosition[1]][0, 1],
                           MotorcycleArray[arrayPosition[0]][arrayPosition[1]][arrayPosition[2] + 1, arrayPosition[3]]
                       };
        }
    }
}