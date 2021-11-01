public class TestStockTickerController {
    public string Results {get;set;}
    public string EnteredSymbol {get;set;}
    
    
    public string GetStockQuote (string Symbol){
        return 'Results for: ' + Symbol; 
    }
    public void LookupSymbol () {
        Results = GetStockQuote(EnteredSymbol);
    }
}