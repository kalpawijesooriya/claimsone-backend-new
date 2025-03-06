using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Linq;
using System.ServiceProcess;

namespace ClaimsOneWindowsService
{
    [RunInstaller(true)]
    public partial class ProjectInstaller : System.Configuration.Install.Installer
    {
        public ProjectInstaller()
        {
            InitializeComponent();
            this.AfterInstall += new InstallEventHandler(ServiceInstaller_AfterInstall);
        }

        void ServiceInstaller_AfterInstall(object sender, InstallEventArgs e)
        {
            using (ServiceController sc = new ServiceController("ClaimsOne Windows Service"))
            {
                sc.Start();
            }
        }

        private void ClaimsOneWinServiceInstaller_AfterInstall(object sender, InstallEventArgs e)
        {

        }

        private void ClaimsOneWinServiceProcessInstaller_AfterInstall(object sender, InstallEventArgs e)
        {

        }
    }
}