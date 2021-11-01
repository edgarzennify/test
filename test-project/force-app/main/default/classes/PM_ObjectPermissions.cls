public class PM_ObjectPermissions extends PM_SObject {
    public PM_PermissionSet Parent {get;set;}
    public Boolean PermissionsCreate {get;set;}
    public Boolean PermissionsDelete {get;set;}
    public Boolean PermissionsEdit {get;set;}
    public Boolean PermissionsModifyAllRecords {get;set;}
    public Boolean PermissionsRead {get;set;}
    public Boolean PermissionsViewAllRecords {get;set;}
    public String SobjectType {get;set;}
}