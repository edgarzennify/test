public class CreditRelationshipVmBuilder implements CreditRelationship.ICreditRelationshipVmBuilder{
    public List<CreditRelationship.ArchivedReportVm> buildArchivedReportVms(List<DmArchivedReport> dms){
        List<CreditRelationship.ArchivedReportVm> vms = new List<CreditRelationship.ArchivedReportVm>();
        for(DmArchivedReport dm : dms){
            vms.add(buildArchivedReportVm(dm));
        }
        return vms;
    }

    public List<CreditRelationship.RelatedEntityVm> buildRelatedEntityVms(List<DmCreditRelationshipRelatedEntity> dms){
        List<CreditRelationship.RelatedEntityVm> vms = new List<CreditRelationship.RelatedEntityVm>();
        for(DmCreditRelationshipRelatedEntity dm : dms){
            vms.add(buildRelatedEntityVm(dm));
        }
        return vms;
    }

    public List<CreditRelationship.RelatedAccountVm> buildRelatedAccountVms(List<DmEbAccount> dms) {
        List<CreditRelationship.RelatedAccountVm> vms = new List<CreditRelationship.RelatedAccountVm>();
        for(DmEbAccount dm : dms){
            vms.add(buildRelatedAccountVm(dm));
        }
        return vms;
    }

    public List<CreditRelationship.ExcludedAccountVm> buildExcludedAccountVms(List<DmCreditRelationshipExcludedAccount> dms){
        List<CreditRelationship.ExcludedAccountVm> vms = new List<CreditRelationship.ExcludedAccountVm>();
        for(DmCreditRelationshipExcludedAccount dm : dms){
            vms.add(buildExcludedAccountVm(dm));
        }
        return vms;
    }

    public List<CreditRelationship.NoteVm> buildNoteVms(List<DmCreditRelationshipNote> dms) {
        List<CreditRelationship.NoteVm> vms = new List<CreditRelationship.NoteVm>();
        for(DmCreditRelationshipNote dm : dms){
            vms.add(buildNoteVm(dm));
        }
        return vms;
    }

    public List<CreditRelationship.PossibleRelatedEntityVm> buildPossibleRelatedEntityVms(List<DmEntity> dms){
        List<CreditRelationship.PossibleRelatedEntityVm> vms = new List<CreditRelationship.PossibleRelatedEntityVm>();
        for(DmEntity dm : dms){
            vms.add(buildPossibleRelatedEntityVm(dm));
        }
        return vms;
    }

    private CreditRelationship.ArchivedReportVm buildArchivedReportVm(DmArchivedReport dm){
        CreditRelationship.ArchivedReportVm vm = new CreditRelationship.ArchivedReportVm();
        vm.id = dm.id;
        vm.url = dm.url;
        vm.name = dm.name;
        vm.createdDate = dm.createdDate;
        vm.createdBy = dm.createdBy.name + ', ' + dm.createdDate.format();
        return vm;
    }

    private CreditRelationship.RelatedEntityVm buildRelatedEntityVm(DmCreditRelationshipRelatedEntity dm){
        CreditRelationship.RelatedEntityVm vm;
        if(dm.entity != null){
            vm = new CreditRelationship.RelatedEntityVm();
            vm.id = dm.id;
            vm.entityId = dm.entity.id;
            vm.name = dm.entity.name;
            vm.street = dm.entity.billingStreet;
            vm.city = dm.entity.billingCity;
            vm.state = dm.entity.billingState;
            vm.zip = dm.entity.billingPostalCode;
        }
        return vm;
    }

    private CreditRelationship.RelatedAccountVm buildRelatedAccountVm(DmEbAccount dmAcct){
        CreditRelationship.RelatedAccountVm vm = new CreditRelationship.RelatedAccountVm();
        vm.id = dmAcct.id;
        vm.accountNumber = dmAcct.name;
        vm.accountTitle = dmAcct.accountLine1;
        vm.riskRating = dmAcct.riskRating;
        vm.contributionMargin = dmAcct.contributionMargin;
        vm.primaryOwner = dmAcct.primaryOwner.name;
        vm.application = dmAcct.application;
        vm.currentCommitment = dmAcct.currentCommitment;
        vm.unadvancedLoanAmount = dmAcct.unadvancedLoanAmount;
        vm.currentBalance = dmAcct.currentBalance;
        vm.status = dmAcct.status;
        return vm;
    }

    private CreditRelationship.ExcludedAccountVm buildExcludedAccountVm(DmCreditRelationshipExcludedAccount dm){
        CreditRelationship.ExcludedAccountVm vm ;
        if(dm.ebaccount != null) {
            vm = new CreditRelationship.ExcludedAccountVm();
            vm.id=dm.id;
            vm.accountNumber = dm.ebaccount.name;
            vm.accountId = dm.ebaccount.id;
            vm.accountTitle = dm.ebaccount.accountLine1;
            vm.riskRating = dm.ebaccount.riskRating;
            vm.contributionMargin = dm.ebaccount.contributionMargin;
            vm.primaryOwner = dm.ebAccount.primaryOwner.name;
        }
        return vm;
    }

    private CreditRelationship.NoteVm buildNoteVm(DmCreditRelationshipNote dm){
        CreditRelationship.NoteVm vm = new CreditRelationship.NoteVm();
        vm.id = dm.id;
        vm.name = dm.name;
        vm.createdBy = dm.createdBy.name + ', ' + dm.createdDate.format();
        vm.diary = dm.diary;
        vm.locked = dm.situationFlag;
        return vm;
    }

    private CreditRelationship.PossibleRelatedEntityVm buildPossibleRelatedEntityVm(DmEntity dm){
        CreditRelationship.PossibleRelatedEntityVm vm = new CreditRelationship.PossibleRelatedEntityVm();
        vm.id = dm.id;
        vm.name = dm.name;
        vm.street = dm.billingStreet;
        vm.city = dm.billingCity;
        vm.state = dm.billingState;
        vm.zip = dm.billingPostalCode;
        return vm;
    }
}