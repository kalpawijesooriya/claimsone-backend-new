using System.ServiceProcess;

namespace ClaimsOneWindowsService
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                new ClaimsOneService()
            };
            ServiceBase.Run(ServicesToRun);
        }
    }
}