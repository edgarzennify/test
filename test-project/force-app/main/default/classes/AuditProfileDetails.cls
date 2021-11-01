public class AuditProfileDetails implements Comparable {

	public Id profileId {get; set;}
	public String profileName {get; set;}
	public Boolean readAccess {get; set;}
	public Boolean editAccess {get; set;}

	public Integer compareTo(Object compareTo) {
        AuditProfileDetails compareToRelatedItem = (AuditProfileDetails)compareTo;
        if (profileName < compareToRelatedItem.profileName) { return -1; }
        if (profileName == compareToRelatedItem.profileName) { return 0; }
        return 1;
    }

	public AuditProfileDetails() {
		profileName = '';
		readAccess = false;
		editAccess = false;
	}

	public AuditProfileDetails(Id profId, String profName, PM_FieldPermissions fieldPermission) {
    	profileId = profId;
    	profileName = profName;
        readAccess = fieldPermission.PermissionsRead;
        editAccess = fieldPermission.PermissionsEdit;
 	}        
}