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
    public class ThreeWheeler
    {

        static string[][][,] ThreeWheelArray = new string[][][,] 
                                            {
                                                new string[] [,]{//grey
                                                    new string[,] {//dark grey
    		                                                    { "ThreeWheel", "All parts" },
  		  	                                                    { "Headlight Lh","" },
  			                                                    { "Headlight Rh","" },
  			                                                    { "Headlight cowl","" },
  			                                                    { "Signal light Rh","" },
  			                                                    { "Signal Light Lh","" },
  			                                                    { "Windscreen Frame","" },
  			                                                    { "Windscreen","" },
  			                                                    { "Windscreen Beading","" },
  			                                                    { "Joint Beading","" },
  			                                                    { "Front Fender","" },
  			                                                    { "Fork","" },
  			                                                    { "Pin Set","" },
  			                                                    { "Cup Set","" },
  			                                                    { "Ball Set","" },
  			                                                    { "Hood Canopy","" },
  			                                                    { "Front Frame","" },
  			                                                    { "Rear Frame set","" },
  			                                                    { "Rear Rh Fender","" },
  			                                                    { "Rear Lh Fender","" },
  			                                                    { "Rear Buffer","" },
  			                                                    { "Rear Rh Combination Lamp","" },
  			                                                    { "Rear Lh Combination Lamp","" },
  			                                                    { "Rear Door","" },
  			                                                    { "Side Door","" },
  			                                                    { "Side Plastic LH","" },
  			                                                    { "Side Plastic RH","" },
  			                                                    { "Kick Pedal","" },
  			                                                    { "Cabin Hole","" },
  			                                                    { "Handle","" },
  			                                                    { "Swing Arm","" },
  			                                                    { "Engine Housing","" },
  			                                                    { "Battery","" },
  			                                                    { "Petrol Tank","" },
  			                                                    { "Rear Deck","" },
  			                                                    { "Cable set","" },
  			                                                    { "Horn Guard","" },
  			                                                    { "Side Mirror Rh",""  },
 			                                                    { "Side Mirror Lh","" },
 			                                                    { "Front Fork","" },
 			                                                    { "Front Hub","" },
 			                                                    { "Front Axle","" },
 			                                                    { "Fork Pin","" },
 			                                                    { "Cup set Upper/Lower","" },
 			                                                    { "Handle Ball","" },
 			                                                    { "Meter","" },
 			                                                    { "Meter Cable","" },
 			                                                    { "Gear Cable Black","" },
 			                                                    { "Gear Cable White","" },
 			                                                    { "F shock absorber","" },
 			                                                    { "Clutch cable","" },
 			                                                    { "Chock Cable","" },
 			                                                    { "Front Rim","" },
 			                                                    { "Front Tire","" },
 			                                                    { "Front Mud Guard","" },
 			                                                    { "F/Windscreen","" },
 			                                                    { "F/W/LH Plastic","" },
 			                                                    { "F/W/RH Plastic","" },
 			                                                    { "F/ Windscreen Beading","" },
 			                                                    { "F/W/B Clip","" },
 			                                                    { "RH Mirror","" },
 			                                                    { "LH Mirror","" },
 			                                                    { "Dash Board","" },
 			                                                    { "F/Brake Hose","" },
 			                                                    { "F/Brake Pipe","" },
 			                                                    { "Brake Pump","" },
 			                                                    { "Hood Cloth","" },
 			                                                    { "Hood Pipe","" },
 			                                                    { "Hood Frame","" },
 			                                                    { "Front Seat","" },
 			                                                    { "Front seat Frame","" },
 			                                                    { "Head Light","" },
 			                                                    { "Head Light Cover RH","" }, 
 			                                                    { "Head Light Cover LH","" },
 			                                                    { "Front LH Signal Light","" },
 			                                                    { "Front RH signal Light","" },
 			                                                    { "Wiper Blade","" },
 			                                                    { "Wiper Motor","" },
 			                                                    { "R/LH Mud Guard","" },
 			                                                    { "R/RH Mud Guard","" },
 			                                                    { "R/Seat","" },
 			                                                    { "R/Buffer","" },
 			                                                    { "R/Door","" },
 			                                                    { "Reverse Gear Cable","" },
 			                                                    { "RH Door","" },
 			                                                    { "R/RH Shock absorber","" },
 			                                                    { "R/LH Shock absorber","" },
 			                                                    { "R/RH Wheel Rim","" },
 			                                                    { "R/LH Wheel Rim","" },
 			                                                    { "RH Tire","" },
 			                                                    { "LH Tire","" },
 			                                                    { "RH Swing Arm","" },
 			                                                    { "LH Swing Arm","" },
 			                                                    { "Distance Piece","" },
 			                                                    { "Silent Bush Swing Arm","" },
 			                                                    { "R/LH Tail Light","" },
  			                                                    { "R/RH Tail Light","" },
 			                                                    { "Front Number Plate","" },
 			                                                    { "Rear Number Plate","" },
 			                                                    { "Silencer","" },
 			                                                    { "Accelerator cable","" },
 			                                                    { "Front wheel bracket","" },
 			                                                    { "Break Oil tank","" },
 			                                                    { "Hand break cable","" },
 			                                                    { "Back rest support","" },
 			                                                    { "Drive shaft","" },
 			                                                    { "Mudguard beading","" },
 			                                                    { "Front cabin","" },
 			                                                    { "Rear cabin","" },
 			                                                    { "s/s modifications","" },
 			                                                    { "Sun visors","" },
 			                                                    { "Ornaments","" },
 			                                                    { "Arial","" },
 			                                                    { "Radio/CD/Cassette player","" }
    		                                                    }
                                                                }
                                            };

        internal string[] GetDamagedItemList(int[] arrayPosition)
        {
            return new string[] { ThreeWheelArray[0][0][0, 0], ThreeWheelArray[arrayPosition[0]][arrayPosition[1]][0, 1], ThreeWheelArray[arrayPosition[0]][arrayPosition[1]][arrayPosition[2] + 1, arrayPosition[3]] };
        }
    }
}