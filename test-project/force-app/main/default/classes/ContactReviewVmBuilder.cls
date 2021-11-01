public class ContactReviewVmBuilder implements ContactReview.IVmBuilder {
    
    public List<ContactReview.VmContactReview> build(List<DmContactReview> dmReviews){
        
        List<ContactReview.VmContactReview> results = new List<ContactReview.VmContactReview>();
        for(DmContactReview rev : dmReviews){
            
            ContactReview.VmContactReview vm = new ContactReview.VmContactReview();
            vm.Id = rev.Id;
            vm.FirstName = rev.firstName;
            vm.LastName = rev.lastName;
            vm.EntityName = rev.entity.name;
            vm.Phone = rev.phone;
            vm.mobilePhone = rev.mobilePhone;
            vm.Address = buildAddress( rev.mailingStreet ,rev.mailingCity , rev.mailingState ,rev.mailingPostalCode);            
            vm.existingContacts = getExistingContactsForEntity(rev.entity.contacts);
            vm.existingContactOptions = buildSelectOptions(rev.entity.contacts);
            results.Add(vm);
        }
        return results;
    }
    
    private List<ContactReview.VmExistingContact> getExistingContactsForEntity(List<DmContact> contacts){
        List<ContactReview.VmExistingContact> vmContacts=new List<ContactReview.VmExistingContact>();
        if(contacts != null && contacts.size() > 0) {
            for(DmContact dmct : contacts){
                ContactReview.VmExistingContact ct = new ContactReview.VmExistingContact();
            	ct.Id = dmct.id;
                ct.AccountId = dmct.accountId;
                ct.FirstName = dmct.firstName;
                ct.LastName = dmct.lastName;
                ct.Phone = dmct.phone;
                ct.MobilePhone = dmct.mobilePhone;
                ct.Address = buildAddress(dmct.mailingStreet  , dmct.mailingCity , dmct.mailingState , dmct.mailingPostalCode );
               vmContacts.Add(ct);
            }
        }
        return vmContacts;
    }
    
    private List<SelectOption> buildSelectOptions(List<DmContact> contacts){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', '<Add As New Contact>'));
        for(DmContact c : contacts){
            options.add(new SelectOption(c.id, buildSelectOptionText(c)));
        }
        return options;
    }
    
    private string buildSelectOptionText(DmContact contact){
        return contact.FirstName + ' ' + contact.LastName 
            	+ ' - ' + buildAddress(contact.mailingStreet, contact.mailingCity, contact.mailingState, contact.mailingPostalCode)
        		+ ' - ' + contact.phone + ' / ' + contact.mobilePhone;
    }
    
    private string buildAddress (string street, string city, string state, string zip){
        return blankIfNull(street) + ', ' + blankIfNull(city) +', ' + blankIfNull(state) +', ' + blankIfNull(zip);
    }
    
    private string blankIfNull(string value){
        return value != null ? value : '';
    }
}