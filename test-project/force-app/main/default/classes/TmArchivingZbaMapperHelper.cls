public class TmArchivingZbaMapperHelper implements TmArchiving.IZbaMapperHelper {
	public List<TmArchiving.TreasuryManagementSm> splitAccountRelationshipsByMaster(TmArchiving.TreasuryManagementSm sm){
        List<TmArchiving.TreasuryManagementSm> sms = new List<TmArchiving.TreasuryManagementSm>();
        EB_Account_Service__c master = new EB_Account_Service__c();
        List<EB_Account_Service__c> zbaAccounts = new List<EB_Account_Service__c>();
        decimal counter = 1;
        for(EB_Account_Service__c a : sm.accounts){
            if(a.Master_Account__c == true){
                master = a;
            }else{
                zbaAccounts.add(a);
            }
        }

        if(String.isBlank(master.Account__c)){
            return sms;
        }


        for(EB_Account_Service__c a : zbaAccounts){
            TmArchiving.TreasuryManagementSm smc = new TmArchiving.TreasuryManagementSm();
            smc.core = new Treasury_Management__c();
            smc.core = sm.core.Clone();
            smc.core.Id = null;
            smc.core.Master_Account_Eb_Number__c = master.Account__c;
            smc.core.Zba_Funding_Account__c = a.Account__c;
            if(smc.accounts == null){smc.accounts = new List<EB_Account_Service__c>();}
            smc.accounts.add(master);
            smc.accounts.add(a);
            sms.add(smc);
        }

        List<Treasury_Management__c> ts = new List<Treasury_Management__c>();
        for(TmArchiving.TreasuryManagementSm t : sms){
            t.core.counter_system_use__c = counter;
            counter = counter + 1;
            ts.add(t.core);
        }

        return sms;
    }
}