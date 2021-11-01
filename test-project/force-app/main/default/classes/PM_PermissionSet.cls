public class PM_PermissionSet extends PM_SObject {
   public String Description {get;set;}
   public Boolean HasActivationRequired {get;set;}
   public Boolean IsCustom {get;set;}
   public Boolean IsOwnedByProfile {get;set;}
   public String Label {get;set;}
   public String NamespacePrefix {get;set;}
   public PM_Profile Profile {get;set;}
   public List<PM_PermissionSetAssignment> Assignments {get;set;}
   public List<PM_FieldPermissions> FieldPerms {get;set;}
   public List<PM_ObjectPermissions> ObjectPerms {get;set;}
}