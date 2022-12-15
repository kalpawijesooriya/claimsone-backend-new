using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace com.IronOne.IronUtils
{
    public static class ConverterUtils
    {
        public static byte[] DataListToExcel(List<KeyValuePair<string, string>[]> input)
        {
            byte[] output = new byte[0];
            StringBuilder sb = new StringBuilder();
            if (input.Count > 0)
            {
                foreach (KeyValuePair<string, string> item in input.FirstOrDefault())
                {
                    sb.Append(item.Key.Replace(',', '_').Replace(Environment.NewLine, " ") + ',');
                }
            }
            sb.Append(Environment.NewLine);
            try
            {
                foreach (KeyValuePair<string, string>[] item in input)
                {
                    foreach (KeyValuePair<string, string> subitem in item)
                    {
                        sb.Append(subitem.Value.Replace(',', '_').Replace(Environment.NewLine, " ") + ',');
                    }
                    sb.Append(Environment.NewLine);
                }
                output = new byte[sb.Length * sizeof(char)];
                System.Buffer.BlockCopy(sb.ToString().ToCharArray(), 0, output, 0, output.Length);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return output;
        }
    }
}
