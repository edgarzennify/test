public class Entity360
{
    
    public enum ElementType {DEPOSIT, LOAN, TREASURY, WEALTH_MANAGEMENT, DEBIT_CARD, CREDIT_CARD, ROE, CM, PRIORITY}

    //Interfaces
    public interface IEntity360VmBuilder
    {
        List<Entity360.EntityViewModel> buildEntityVms(List<DmEntity> entityDms);
        Entity360.EntityViewModel buildAggregateEntityVm(List<DmEntity> entityDms);
    }

    public interface IEntity360DmBuilder
    {
        List<DmEntity> buildDmEntities(List<Account> pms);
    }

    public interface IEntity360DataProvider
    {
        List<DmEntity> GetDmEntities(List<String> entityIds);
        List<DmEntity> getAllRelationshipEntitiesBySingleEntityId(String entityId);
    }

    public interface IEntity360Repository
    {
        List<DmEntity> getEntityDms(String entityId);
        List<DmEntity> getEntityDms(List<String> entityIds);
        List<DmEntity> getRelationshipEntityDmsByEntityId(String entityId);
    }

    public interface IEntity360VmDisplayCalc
    {
        Boolean IsType(Entity360.ElementType type);
        String GetDisplayValue(Decimal rawAmount);
        String GetDisplayPercent(Decimal percentAsDecimal);
        Decimal CalculatePercent(Decimal thisPart, Decimal theRest);
        String GetSymbol();
        String GetElementType(Decimal existingValue, Decimal opportunityValue);
        String GetElementSummary();
        String GetExistingSummary(Decimal existingValue);
        String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability);
    }

    public interface IEntity360Delegate
    {
        DmProductOverview assembleFrom(DmEntity entity);
    }
    
    public interface IEntity360DmCache
    {
        void setEntityDmsMap(Map<String,DmEntity> entityDmsMap);
        Map<String,DmEntity> getEntityDmsMap();
    }

    //View Models
    public class EntityViewModel
    {
        public String EntityId { get; set; }
        public String EntityName { get; set; }
        public List<ElementViewModel> Elements { get; set; } 
    }

    public class ElementViewModel
    {
        public String elementSymbol {get;set;}
        public String elementType {get;set;}
        public String elementSummary {get;set;}
        public String existingValue {get;set;}
        public String existingPercent {get;set;}
        public String existingSummary {get;set;}
        public String opportunityValue {get;set;}
        public String opportunityPercent {get;set;}
        public String opportunityProbability {get;set;}
        public String opportunitySummary {get;set;}
    }
}