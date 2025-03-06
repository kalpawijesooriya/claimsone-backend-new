using Newtonsoft.Json;
using System;

namespace ClaimsOneWindowsService
{
    class DataModel
    {
    }

    public class RootObject
    {
        [JsonProperty("ID")]
        public int ID { get; set; }
        [JsonProperty("Data")]
        public string Data { get; set; }
    }

    public class CSRDataModel
    {
        public string CSRCode { get; set; }
        public string JobNumber { get; set; }
        public DateTime AssignedDateTime { get; set; }
        public string VehicleNumber { get; set; }
    }

    public class HolidayDataModel
    {
        public DateTime HolidayDate { get; set; }
    }
}
