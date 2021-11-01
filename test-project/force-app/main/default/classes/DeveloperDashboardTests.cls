@isTest
public class DeveloperDashboardTests{
    static testmethod void code_coverage(){
        DeveloperDashboardController sut = new DeveloperDashboardController();
        String environment = sut.EnvironmentName;
        List<ApexClass> classes = sut.ApexClasses;
        List<ApexPage> pages = sut.ApexPages;
        List<ApexComponent> components = sut.ApexComponents;
        List<ApexTrigger> triggers = sut.ApexTriggers;
    }
}