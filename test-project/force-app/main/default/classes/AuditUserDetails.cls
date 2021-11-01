public class AuditUserDetails implements Comparable {

	public Id userId {get; set;}
	public String userName {get; set;}
	public Boolean readAccess {get; set;}
	public Boolean editAccess {get; set;}
	public List<AuditPermissionSetDetails> permissionSets {get;set;}
	public AuditProfileDetails profile {get;set;}

	public Integer compareTo(Object compareTo) {
        AuditUserDetails compareToRelatedItem = (AuditUserDetails)compareTo;
        if (userName < compareToRelatedItem.userName) { return -1; }
        if (userName == compareToRelatedItem.userName) { return 0; }
        return 1;
    }

	public AuditUserDetails() {
		userName = '';
        initializeAccessDetails();
	}

	public AuditUserDetails(PM_PermissionSetAssignment assignedUserInfo) {
        userId = assignedUserInfo.Assignee.Id;
        userName = assignedUserInfo.Assignee.Name;
        initializeAccessDetails();
 	}

 	private void initializeAccessDetails()
 	{
        readAccess = false;
        editAccess = false;
        permissionSets = new List<AuditPermissionSetDetails>();
        profile = new AuditProfileDetails();
 	}
}