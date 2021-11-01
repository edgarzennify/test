global class EsignatureManagerController {

    @RemoteAction
    public static FormVm bootstrap(){
        EsignatureApplication.IDataProvider dp = new EsignatureApplicationDataProvider();
        FormVm info = new FormVm();
        info.Items = new List<ConfigVm>();
        for(PM_Esignature_Configuration_c c: dp.getConfigurations()){
            info.Items.add(Build(c));
        }
        return info;
    }

    private static ConfigVm Build(PM_Esignature_Configuration_c config){
        ConfigVm item = new ConfigVm();
        item.Identifier = config.Id;
        item.ApplicationName = config.Name;
        item.Department = config.Department_c;
        item.ApplicationNumber = config.Application_Id_c;
        item.EsignApplicationUrl = 'EsignatureApplication?appid='+config.Application_Id_c;
        return item;
    }


    global class FormVm{
        public List<ConfigVm> items{get;set;}
    }

    global class ConfigVm{
        public string identifier{get;set;}
        public string applicationNumber{get;set;}
        public string department{get;set;}
        public string esignApplicationUrl{get;set;}
        public string applicationName{get;set;}
    }
}