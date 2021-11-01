public class ContactReviewDmBuilder implements ContactReview.IDmBuilder {
    
    public List<DmContactReview> build(List<ContactReview.ContactReviewPm> reviews, List<ContactReview.AccountPm> accountsWithContacts){
        List<DmContactReview> results = new List<DmContactReview>();
        for(ContactReview.ContactReviewPm ctr : reviews){
        	DmContactReview dm = new DmContactReview();
            dm.Id = ctr.Id;
            dm.firstName = ctr.First_Name_c != null ? ctr.First_Name_c : '';
            dm.lastName = ctr.Last_Name_c != null ? ctr.Last_Name_c : '';
            dm.phone = ctr.Phone_c;
            dm.mobilePhone = ctr.Mobile_Phone_c;
            dm.mailingStreet = ctr.Mailing_Street_c;
            dm.mailingCity = ctr.Mailing_City_c;
            dm.mailingState = ctr.Mailing_State_c;
            dm.mailingPostalCode = ctr.Mailing_Postal_Code_c;
            dm.key = ctr.Key_c;
            dm.importSource = ctr.Import_Source_c;
            dm.entity = buildEntity(ctr.AccountId_c, accountsWithContacts);
			results.add(dm);            
        }        
        return results;
    }
    
    private ContactReview.AccountPm getRelatedAccount(Id acctId, List<ContactReview.AccountPm> accounts){
        List<ContactReview.AccountPm> result= new List<ContactReview.AccountPm>();
        for(ContactReview.AccountPm a : accounts){
            if(a.Id==acctId){
                return a;
            }
        }
        return null;
    }    
    
    private DmEntity buildEntity(Id acctId, List<ContactReview.AccountPm> accounts){
        ContactReview.AccountPm related = getRelatedAccount(acctId, accounts);
        DmEntity entity = new DmEntity();
        if(related != null){
            entity.id = related.Id;
            entity.name = related.Name;
            entity.contacts = new List<DmContact>();
            
            for(ContactReview.ContactPm c : related.Contacts){
                entity.contacts.add(build(c));
            }
        }        
        return entity;
    }
    
    private DmContact build(ContactReview.ContactPm pm){
		DmContact dm = new DmContact();
        dm.id = pm.Id;
        dm.firstName = pm.firstName;
        dm.lastName = pm.lastName;
        dm.mobilePhone = pm.MobilePhone;
        dm.phone = pm.Phone;
        dm.mailingStreet = pm.MailingStreet;
        dm.mailingCity = pm.MailingCity;
        dm.mailingState = pm.MailingState;
        dm.mailingPostalCode = pm.MailingPostalCode;
        return dm;
    }
    
}