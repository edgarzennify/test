public class PM_LLCBI_Pricing_Stream_c extends PM_SObject {
    public Datetime LLCBI_Effective_Date_c {get; set;}
    public Decimal LLCBI_Sequence_c {get; set;}
    public Decimal LLCBI_Term_Length_c {get; set;}
    public String LLCBI_Term_Unit_c {get; set;}
    public Boolean LLCBI_Is_Payment_Stream_c {get;set;}
    public Boolean LLCBI_Is_Rate_Stream_c {get;set;}
    public List<PM_LLCBI_Pricing_Rate_Component_c> LLCBI_Pricing_Rate_Components_r {get; set;}
    public List<PM_LLCBI_Pricing_Payment_Component_c> LLCBI_Pricing_Payment_Components_r {get; set;}
}