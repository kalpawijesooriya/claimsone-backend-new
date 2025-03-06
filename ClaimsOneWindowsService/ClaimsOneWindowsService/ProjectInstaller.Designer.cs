namespace ClaimsOneWindowsService
{
    partial class ProjectInstaller
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ClaimsOneWinServiceProcessInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this.ClaimsOneWinServiceInstaller = new System.ServiceProcess.ServiceInstaller();
            // 
            // ClaimsOneWinServiceProcessInstaller
            // 
            this.ClaimsOneWinServiceProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            this.ClaimsOneWinServiceProcessInstaller.Password = null;
            this.ClaimsOneWinServiceProcessInstaller.Username = null;
            this.ClaimsOneWinServiceProcessInstaller.AfterInstall += new System.Configuration.Install.InstallEventHandler(this.ClaimsOneWinServiceProcessInstaller_AfterInstall);
            // 
            // ClaimsOneWinServiceInstaller
            // 
            this.ClaimsOneWinServiceInstaller.Description = "This windows service will sync holiday calendar and TO assigned job details with " +
                "ClaimsOne backend for reporting purposes.";
            this.ClaimsOneWinServiceInstaller.DisplayName = "ClaimsOne Windows Service";
            this.ClaimsOneWinServiceInstaller.ServiceName = "ClaimsOneWinService";
            this.ClaimsOneWinServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic;
            this.ClaimsOneWinServiceInstaller.AfterInstall += new System.Configuration.Install.InstallEventHandler(this.ClaimsOneWinServiceInstaller_AfterInstall);
            // 
            // ProjectInstaller
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.ClaimsOneWinServiceProcessInstaller,
            this.ClaimsOneWinServiceInstaller});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller ClaimsOneWinServiceProcessInstaller;
        private System.ServiceProcess.ServiceInstaller ClaimsOneWinServiceInstaller;
    }
}