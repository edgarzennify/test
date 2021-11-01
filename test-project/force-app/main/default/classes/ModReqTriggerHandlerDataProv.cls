public with sharing class ModReqTriggerHandlerDataProv implements IModReqTriggerHandlerDataProv{

	public interface IModReqTriggerHandlerDataProv{
		void saveAccounts(List<Account> accts);
	}

	public void saveAccounts(List<Account> accts){
		update accts;
	}
}