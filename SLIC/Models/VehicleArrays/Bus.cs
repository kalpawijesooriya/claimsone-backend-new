﻿/***************************************************************************/
/// <summary>
///  <title>SLIC Bus Model</title>
///  <description>Bus Model for Bus type Vehicle Details</description>
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
using System.Collections;

namespace com.IronOne.SLIC2.Models.VehicleArrays
{
    public class Bus
    {
        static string[][][,] BusArray = new string[][][,] 
                                            {
                                                new string[] [,]{//grey
                                                    new string[,] {//dark grey
                                                                        { "Bus", "Front face panel" },
                                                                        { "Front buffer","" },
		                                                                { "Front windscreen","" },
		                                                                { "Front grill","" },
		                                                                { "Front badge","" },
		                                                                { "Dash board","" },
		                                                                { "A/C blower","" },
		                                                                { "A/C cooler","" },
		                                                                { "R/H/S front windscreen","" },
		                                                                { "L/H/S front windscreen","" },
		                                                                { "R/H/S front windscreen beading","" },
		                                                                { "L/H/S front windscreen beading","" },
		                                                                { "Front windscreen (single glass)","" },
		                                                                { "Front single windscreen beading","" },
		                                                                { "L/H/S front buffer end ","" },
		                                                                { "R/H/S front buffer end","" },
		                                                                { "Front face aluminum molding","" },
		                                                                { "R/H/S head lamp","" },
		                                                                { "L/H/S head lamp","" },
		                                                                { "R/H/S head lamp frame","" },
		                                                                { "L/H/S head lamp frame","" },
		                                                                { "R/H/S front signal lamp","" },
		                                                                { "L/H/S front signal lamp","" },
		                                                                { "R/H/S front parking lamp","" },
		                                                                { "L/H/S front parking lamp","" },
		                                                                { "Front name board glass","" },
		                                                                { "Front name board light","" },
		                                                                { "Front name board glass beading","" },
		                                                                { "A/C Condenser","" },
		                                                                { "A/C Filter","" },
		                                                                { "Horn","" },
		                                                                { "Air horn","" },
		                                                                { "Front number plate","" },
		                                                                { "Front number plate lamp","" }
                                                                    },
                                                    new string[,] {//light grey
                                                                    { "Bus", "Right body panel" },
		                                                            { "R/H/S driver door","" },
		                                                            { "R/H/S cut glass","" },
		                                                            { "R/H/S fit glass","" },
		                                                            { "R/H/S rain gutter","" },
		                                                            { "R/H/S body molding","" },
		                                                            { "R/H/S door hinges","" },
		                                                            { "R/H/S front tire","" },
		                                                            { "R/H/S Driver door glass","" },
		                                                            { "R/H/S Driver door glass beading","" },
		                                                            { "R/H/S Door hinges","" },
		                                                            { "R/H/S Cut glass frames","" },
		                                                            { "R/H/S Fit glass frames","" },
		                                                            { "R/H/S Cut glass beading","" },
		                                                            { "R/H/S Fit glass beading","" },
		                                                            { "R/H/S Body aluminum molding","" },
		                                                            { "R/H/S Emergency door","" },
		                                                            { "R/H/S Emergency door glass","" },
		                                                            { "R/H/S Emergency door glass beading","" },
		                                                            { "R/H/S Front rim","" },
		                                                            { "R/H/S Rear tire outer","" },
		                                                            { "R/H/S Rear tire outer rim","" },
		                                                            { "R/H/S Rear tire inner","" },
		                                                            { "R/H/S Rear tire inner rim","" },
		                                                            { "R/H/S Mirror","" },
		                                                            { "R/H/S Front tire Wheel nuts","" },
		                                                            { "R/H/S Rear tire outer Wheel nuts","" },
		                                                            { "R/H/S Rear tire inner Wheel nuts","" },
		                                                            { "Rim cups (if available)","" },
		                                                            { "Side lights","" },
		                                                            { "Body beading aluminum","" },
		                                                            { "Body beading rubber","" }    
                                                                   },
                                                    new string[,]  { //other grey
                                                                   { "Bus", "Left body panel" },
  		                                                            { "L/H/S front door","" },
  		                                                            { "L/H/S front board","" },
  		                                                            { "L/H/S cut glasses","" },
  		                                                            { "L/H/S foot board","" },
  		                                                            { "L/H/S fit glasses","" },
  		                                                            { "L/H/S body rubber","" },
  		                                                            { "L/H/S rear tire inner","" },
  		                                                            { "L/H/S Front door glass","" },
  		                                                            { "L/H/S Front door glass beading","" },
  		                                                            { "L/H/S Front door rubber flap","" },
  		                                                            { "L/H/S Front door winder","" },
  		                                                            { "L/H/S Foot board lamp","" },
  		                                                            { "L/H/S Front rain gutter","" },
  		                                                            { "L/H/S Body aluminum molding","" },
  		                                                            { "L/H/S Body rubber molding","" },
  		                                                            { "L/H/S Cut glasses frames","" },
  		                                                            { "L/H/S Fit glasses frames","" },
  		                                                            { "L/H/S Cut glass beading","" },
  		                                                            { "L/H/S Fit glasses beading","" },
  		                                                            { "L/H/S Rear foot board","" },
  		                                                            { "L/H/S Rear foot board lamp","" },
  		                                                            { "L/H/S Rear foot board door","" },
  		                                                            { "L/H/S Rear foot board door glass","" },
  			                                                        { "L/H/S Rear foot board door beading","" },
  			                                                        { "L/H/S Rear foot board door rubber flap","" },
  			                                                        { "L/H/S Rear rain gutter","" },
  			                                                        { "L/H/S Front tire","" },
  			                                                        { "L/H/S Front tire rim","" },
  			                                                        { "L/H/S Rear tire outer","" },
  			                                                        { "L/H/S Rear tire outer rim","" },
  			                                                        { "L/H/S Rear tire inner","" },
  			                                                        { "L/H/S Rear tire inner rim","" },
  			                                                        { "L/H/S Front tire Wheel nuts","" },
  			                                                        { "L/H/S Rear tire outer Wheel nuts","" },
  			                                                        { "L/H/S Rear tire inner Wheel nuts","" },
  			                                                        { "L/H/S Rim cups (if available)","" },
  			                                                        { "Side lights","" },
  			                                                        { "Body beading aluminum","" }, 
  			                                                        { "Body beading rubber","" }    
                                                                    },new string[,]
                                                                    {// darkgray
                                                                        { "Bus", "Rear side" },
      		                                                             { "Rear buffer","" },
      		                                                             { "Dickey door","" },
      		                                                             { "Dickey door lights","" },
      		                                                             { "Dickey door ladder","" },
      		                                                             { "Rear number plate","" },
      		                                                             { "Dickey door locks","" },
      		                                                             { "Dickey door garnish","" },
      		                                                             { "Dickey door handles","" },
      		                                                             { "Dickey door beadings","" },
      		                                                             { "Rear windscreen","" },
      		                                                             { "R/H/S Rear windscreen","" },
      		                                                             { "L/H/S Rear windscreen","" },
      		                                                             { "R/H/S Rear windscreen beading","" },
      		                                                             { "R/H/S Rear windscreen beading","" }, 
      		                                                             { "Rear windscreen beading","" },
      		                                                             { "Rear name board box glass","" },
      		                                                             { "Rear name board box glass beading","" },
   			                                                             { "Rear name board box glass lamp","" },
   			                                                             { "L/H/S tail light rear","" },
   			                                                             { "R/H/S Rear tail light","" },
      		                                                             { "L/H/S Rear tail light","" },
      		                                                             { "R/H/S rear parking lamp","" },
      		                                                             { "L/H/S rear parking lamp","" },
      		                                                             { "R/H/S rear buffer end","" },
      		                                                             { "L/H/S rear buffer end","" },
      		                                                             { "Rear number plate lamp","" },
      		                                                             { "Back body aluminum molding","" }, 
      		                                                             { "Back body rubber beading","" },
      		                                                             { "Rear windscreen mirror","" },
      		                                                             { "Body beading rubber","" },
      		                                                             { "Body beading aluminum","" }
                                                                    },
                                                                    new string[,] {//light grey
                                                                        { "Bus", "Engine compartment and components" },
        	                                                              { "Diesel, petrol engine (gasoline engine)","" },
        	                                                              { "Accessory belt","" },
        	                                                              { "Air duct","" },
        	                                                              { "Air intake housing","" },
        	                                                              { "Air intake manifold","" },
        	                                                              { "Camshaft","" },
        	                                                              { "Camshaft bearing","" },
        	                                                              { "Camshaft fastener","" },
        	                                                              { "Camshaft follower","" },
        	                                                              { "Camshaft locking plate","" },
        	                                                              { "Camshaft pushrod","" },
        	                                                              { "Camshaft spacer ring","" },
        	                                                              { "Connecting rod","" },
        	                                                              { "Connecting rod bearing","" },
        	                                                              { "Connecting rod bolt","" },
        	                                                              { "Connecting rod washer","" },
        	                                                              { "Crank case","" },
        	                                                              { "Crank pulley","" },
        	                                                              { "Crankshaft","" },
        	                                                              { "Crankshaft oil seal","" },
        	                                                              { "Cylinder head","" },
        	                                                              { "Cylinder head cover","" },
        	                                                              { "Other cylinder head cover parts","" },
        	                                                              { "Cylinder head gasket","" },
        	                                                              { "Distributor","" },
        	                                                              { "Distributor cap","" }, 
        	                                                              { "Drive belt","" },
        	                                                              { "Engine block","" }, 
        	                                                              { "Engine block parts","" },
        	                                                              { "Engine cradle","" },
        	                                                              { "Engine shake damper and vibration absorber","" },
        	                                                              { "Engine valve","" },
        	                                                              { "Fan belt","" },
        	                                                              { "Gudgeon pin (wrist pin)","" },
        	                                                              { "Harmonic balancer","" },
        	                                                              { "Heater","" },
        	                                                              { "Mounting bolt","" },
        	                                                              { "Piston pin and crank pin","" },
        	                                                              { "Piston pin bush","" },
        	                                                              { "Piston ring and circlip","" },
        	                                                              { "Piston valve","" }, 
        	                                                              { "Poppet valve","" }, 
        	                                                              { "PCV valve (positive crankcase ventilation valve)","" },  
        	                                                              { "Pulley part","" }, 
        	                                                              { "Rocker arm","" }, 
        	                                                              { "Rocker cover Starter motor","" }, 
        	                                                              { "Rocker cover Starter pinion","" }, 
        	                                                              { "Rocker cover Starter ring","" }, 
        	                                                              { "Turbocharger and supercharger","" },  
        	                                                              { "Tappet","" },
        	                                                              { "Timing tape ","" }, 
        	                                                              { "Valve cover","" },
        	                                                              { "Valve housing","" }, 
        	                                                              { "Valve spring","" },
        	                                                              { "Valve stem seal","" }, 
        	                                                              { "Water pump pulley","" }
                                                                    },
                                                                    new string[,] {//light grey
                                                                          { "Bus", "Engine cooling system" },
        	                                                              { "Air blower","" },
        	                                                              { "Coolant hose cooling fan","" }, 
        	                                                              { "Fan blade","" },
        	                                                              { "Fan clutch","" },
        	                                                              { "Radiator bolt","" },
        	                                                              { "Radiator shroud","" },
        	                                                              { "Radiator gasket","" },
        	                                                              { "Radiator pressure cap","" }, 
        	                                                              { "Water neck","" },
        	                                                              { "Water neck o-ring","" }, 
        	                                                              { "Water pipe","" },
        	                                                              { "Water pump","" },
        	                                                              { "Water pump gasket","" }, 
        	                                                              { "Water tank","" },
        	                                                              { "Thermostat","" }
                                                                    },
                                                                    new string[,] {//light grey
                                                                          { "Bus", "Engine oil system" },
        	                                                              { "Oil filter","" }, 
        	                                                              { "Oil gasket","" }, 
        	                                                              { "Oil pan","" },
        	                                                              { "Oil pipe","" }, 
        	                                                              { "Oil pump","" }, 
        	                                                              { "Oil strainer","" } 
                                                                    },
                                                                    new string[,] {//light grey
                                                                        { "Bus","Exhaust system" },
        	                                                              { "Catalytic converter","" },
        	                                                              { "Exhaust clamp and bracket","" }, 
        	                                                              { "Exhaust flange gasket","" },
        	                                                              { "Exhaust gasket","" }, 
        	                                                              { "Exhaust manifold","" }, 
        	                                                              { "Exhaust manifold gasket","" }, 
        	                                                              { "Exhaust pipe","" }, 
        	                                                              { "Heat shield","" }, 
        	                                                              { "Heat sleeving and tape","" }, 
        	                                                              { "Muffler (silencer)","" }
                                                                    },
                                                                    new string[,] {//light grey
                                                                        { "Bus", "Fuel supply system" },
        	                                                              { "Air filter","" },
        	                                                              { "Carburetor","" },
        	                                                              { "Carburetor parts","" },
        	                                                              { "Choke cable","" },
        	                                                              { "EGR valve","" },
        	                                                              { "Fuel cap","" },
        	                                                              { "Fuel cell","" },
        	                                                              { "Fuel cell component","" },
        	                                                              { "Fuel cooler","" },
        	                                                              { "Fuel distributor","" },
        	                                                              { "Fuel filter","" },
        	                                                              { "Fuel filter seal","" },
        	                                                              { "Fuel injector","" },
        	                                                              { "Fuel injector nozzle","" },
        	                                                              { "Fuel pump","" },
        	                                                              { "Fuel pump gasket","" },
        	                                                              { "Fuel pressure regulator","" },
        	                                                              { "Fuel rail","" },
        	                                                              { "Fuel tank","" },
        	                                                              { "Fuel tank cover","" },
        	                                                              { "Fuel water separator","" },
        	                                                              { "Intake manifold","" },
        	                                                              { "Intake manifold gasket","" },
        	                                                              { "LPG (Liquefied petroleum gas) system assembly","" }, 
        	                                                              { "Throttle body","" },
        	                                                              { "Universal joint","" }
                                                                    },
                                                                    new string[,] {//light grey
                                                                        { "Bus","Other miscellaneous parts" },
        	                                                              { "Adhesive tape and foil","" },  
        	                                                              { "Bolt cap","" },
        	                                                              { "License plate bracket","" }, 
        	                                                              { "Speedometer cable","" },
        	                                                              { "Cotter pin","" }, 
        	                                                              { "Decal","" }, 
        	                                                              { "Dashboard","" }, 
        	                                                              { "Center console","" }, 
        	                                                              { "Glove compartment","" }, 
        	                                                              { "Drag link","" }, 
        	                                                              { "Dynamic seal","" }, 
        	                                                              { "Fastener","" }, 
        	                                                              { "Gasket: Flat, molded, profiled","" }, 
        	                                                              { "Hood and trunk release cable","" }, 
        	                                                              { "Horn and trumpet horn","" }, 
        	                                                              { "Injection-molded parts","" }, 
        	                                                              { "Instrument cluster","" }, 
        	                                                              { "Label","" }, 
        	                                                              { "Mirror","" }, 
        	                                                              { "Mount and mounting","" }, 
        	                                                              { "Name plate","" }, 
        	                                                              { "Flange nut","" }, 
        	                                                              { "Hex nut","" }, 
        	                                                              { "O-ring","" }, 
        	                                                              { "Paint","" },
        	                                                              { "Rivet","" },
        	                                                              { "Rubber (extruded and molded)","" }, 
        	                                                              { "Screw","" }, 
        	                                                              { "Shim","" },
        	                                                              { "Sun visor","" }
                                                                    }
                                                                }
                                            };



        internal string[] GetDamagedItemList(int[] arrayPosition)
        {
            return new string[] {BusArray[0][0][0,0], BusArray[arrayPosition[0]][arrayPosition[1]][0, 1], BusArray[arrayPosition[0]][arrayPosition[1]][arrayPosition[2]+1, arrayPosition[3]] };
        }
    }
}