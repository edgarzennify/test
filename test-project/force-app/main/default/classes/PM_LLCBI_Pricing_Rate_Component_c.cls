public class PM_LLCBI_Pricing_Rate_Component_c extends PM_SObject {
    public Boolean LLCBI_Is_Fixed_c {get; set;}
    public Decimal LLCBI_Applied_Loan_Percentage_c {get; set;}
    public Decimal LLCBI_Rate_c {get; set;}
    public PM_LLCBI_Pricing_Stream_c LLCBI_Pricing_Stream_r {get; set;}
    public List<PM_LLCBI_Pricing_Covenant_c> LLCBI_Pricing_Covenants_r {get; set;}
}