public class PM_FieldPermissions extends PM_SObject {
    public String Field {get;set;}
    public PM_PermissionSet Parent {get;set;}
    public Boolean PermissionsEdit {get;set;}
    public Boolean PermissionsRead {get;set;}
    public String SobjectType {get;set;}
}