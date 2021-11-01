public class TmOpportunityConverterDmBuilder implements TmOpportunityConverter.IDmBuilder{

	public DmRecordType build(RecordType pm) { 
		DmRecordType dm = new DmRecordType();
		dm.id = pm.Id;
		dm.name = pm.Name;
		dm.IsActive = pm.IsActive;
		return dm;
	}

    public DmOpportunity build(Opportunity pm) {
		DmOpportunity dm = new DmOpportunity();
		dm.id = pm.id;
		dm.name = pm.Name;
		dm.entity = new DmEntity();
		dm.entity.id = pm.Account.Id;
		dm.entity.name = pm.Account.Name;
		dm.entity.recordType = new DmRecordType();
		dm.entity.recordType.Id = pm.Account.RecordTypeId;
		dm.entity.recordType.Name = pm.Account.RecordType.Name;
		dm.recordType = new DmRecordType();
		dm.recordType.id = pm.RecordTypeId;
		dm.recordType.name = pm.RecordType.Name;
		dm.BankProducts = String.isBlank(pm.Products__c)? new List<string>(): pm.Products__c.Split(';');
		dm.potentialFeeIncome = pm.Potential_Fee_Income__c == null? 0.0: pm.Potential_Fee_Income__c;
		dm.potentialDeposits = pm.Potential_Deposits__c == null? 0.0 :  pm.Potential_Deposits__c;
		if (pm.Product__c == 'ACH') {
			dm.BankProducts.add('ACH');
		}
		return dm;
	}

	public DmTmPacket build(Tm_Service_Request_Packet__c pm) {
		DmTmPacket dm = new DmTmPacket();
		dm.id = pm.Id;
		dm.name = pm.Name;

		return dm;
	}
}