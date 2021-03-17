public without sharing class selectStocks{
    
    @AuraEnabled public String ticker{get;set;}
    @AuraEnabled public String company_name{get;set;}
    @AuraEnabled public String gics_sector{get;set;}
    @AuraEnabled public String gics_sub_industry{get;set;}
    @AuraEnabled public String hq_location{get;set;}
    @AuraEnabled public Date date_first_added{get;set;}
    @AuraEnabled public Integer founded_year{get;set;}
    @AuraEnabled public Integer cik{get;set;}
    
    
    @AuraEnabled public String title{get;set;}
    @AuraEnabled public String summary{get;set;}
    @AuraEnabled public String url{get;set;}
    @AuraEnabled public String author_name{get;set;}
    @AuraEnabled public String tickers{get;set;}
    
    
    
    @AuraEnabled
    public static selectStocks fetchStock(String tickerSymbol){
        
        selectStocks obj = new selectStocks();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://stock-ticker-security-and-company-search-database.p.rapidapi.com/sp500_search?ticker=' + tickerSymbol);
        request.setMethod('GET');
        request.setHeader('x-rapidapi-key', 'c1ee454b84msh4d5aeffaa534462p19222djsn5b2835af07ad');
        request.setHeader('x-rapidapi-host', 'stock-ticker-security-and-company-search-database.p.rapidapi.com');
        request.setHeader('useQueryString', 'true');
        HttpResponse response = http.send(request);
        system.debug('test' + response.getStatusCode());
        if(response.getStatusCode() == 200) {
            system.debug('test' + response.getBody());
            JSONParser parser = JSON.createParser(response.getBody());
            while(parser.nextToken() != null){
                if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                    stockInformation  StockInfo = (stockInformation)parser.readValueAs(stockInformation.class);
                    obj.ticker = StockInfo.ticker;
     				obj.company_name = StockInfo.company_name;
     				obj.gics_sector = StockInfo.gics_sector;
                    obj.gics_sub_industry = StockInfo.gics_sub_industry;
    				obj.hq_location = StockInfo.hq_location;
     				obj.date_first_added = StockInfo.date_first_added;
    				obj.founded_year= StockInfo.founded_year;
            		obj.cik = StockInfo.cik;

                }
            }
        }    
        return obj;
    }
    
    
    public class stockInformation{
        @AuraEnabled public String ticker{get;set;}
        @AuraEnabled public String company_name{get;set;}
        @AuraEnabled public String gics_sector{get;set;}
        @AuraEnabled public String gics_sub_industry{get;set;}
        @AuraEnabled public String hq_location{get;set;}
        @AuraEnabled public Date date_first_added{get;set;}
        @AuraEnabled public Integer founded_year{get;set;}
        @AuraEnabled public Integer cik{get;set;}
        
        public stockInformation(String tick,String c_name, String g_sector, String g_sub_industry,String hq_loc, Date date_first_ad, Integer founded_y,Integer ci){
            ticker = tick;
            company_name = c_name;
            gics_sector = g_sector;
            gics_sub_industry = g_sub_industry;
            hq_location = hq_loc;
            date_first_added = date_first_ad;
            founded_year = founded_y;
            cik = ci;            
        }   
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @AuraEnabled
    public static List<selectStocks> fetchStockNews(String tickerSymbol, Integer NumberofArticles){
        
        List<selectStocks> objs = new List<selectStocks>();

        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://yahoo-finance-low-latency.p.rapidapi.com/v2/finance/news?symbols='+ tickerSymbol );
        request.setMethod('GET');
        request.setHeader('x-rapidapi-key', 'c1ee454b84msh4d5aeffaa534462p19222djsn5b2835af07ad'); 
        request.setHeader('x-rapidapi-host', 'yahoo-finance-low-latency.p.rapidapi.com');
        request.setHeader('useQueryString', 'true');
        HttpResponse response = http.send(request);
        system.debug('status code: ' + response.getStatusCode());
        if(response.getStatusCode() == 200) {
            //system.debug('test' + response.getBody());
            JSONParser parser = JSON.createParser(response.getBody());
            while(parser.nextToken() != null){
                if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                    JSON2Apex stockNewsInfo = (JSON2Apex)parser.readValueAs(JSON2Apex.class);
                    system.debug('Content: ' + stockNewsInfo.Content.result.get(0).tickers);
                    system.debug('Content: ' + stockNewsInfo.Content.result.get(1).tickers);
                    system.debug('Content: ' + stockNewsInfo.Content.result.get(2).tickers);
                    system.debug('full obj:' + response.getBody());
                    for(integer i = 0; i < NumberofArticles; i++){
                        selectStocks obj = new selectStocks();
                        obj.title = stockNewsInfo.Content.result.get(i).title;
                        obj.summary = stockNewsInfo.Content.result.get(i).summary;
                        obj.url = stockNewsInfo.Content.result.get(i).url;
                        obj.author_name = stockNewsInfo.Content.result.get(i).author_name;
                        obj.tickers = stockNewsInfo.Content.result.get(i).tickers.get(0);
                        system.debug('obj '+ i + ' :' + obj);
                        objs.add(obj);
                    } 
                    
                }
            }
        }
        return objs;
    }
    
    
	public class JSON2Apex {
        public Featured Featured;
        public Meta Meta;
        public Content Content;
    
	}
    
    public class Meta {
        public List<Result_Z> result;
        public Object error;
    }
    
    public class Result_Y {
        public Integer rank;
        public String id;
        public String tag;
        public String title;
        public String summary;
        public String url;
        public String author_name;
        public Integer provider_publish_time;
        public String provider_name;
        public Boolean hosted;
        public List<String> tickers;
        public String thumbnail;
        public Boolean featured;
        public String timeZoneShortName;
        public String timeZoneFullName;
        public Integer gmtOffSetMilliseconds;
        public Result imageSet;
    }
    
        
    public class Content {
        public List<Result_Y> result;
        public Object error;
    }
    
    public class Featured {
        public List<Result> result;
        public Object error;
    }
    
    public class Result_Z {
        public Integer next;
    }
    
    public class Result {
    }
}