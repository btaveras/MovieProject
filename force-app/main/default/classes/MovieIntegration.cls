public without sharing class MovieIntegration {
    public MovieIntegration() {

    }

    public static void findMovie(){
        String encodedTitle = EncodingUtil.urlEncode('home alone','UTF-8');
        getMovieFromAPI(encodedTitle);
    }

    @future (callout=true)
    public static void getMovieFromAPI(String title){

        Movie_API_token__mdt apiToken = 
            [SELECT Token__c FROM Movie_API_token__mdt LIMIT 1];

        if(apiToken == null)
            return;

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:MovieDB/search/movie?api_key='+apiToken.Token__c+'&language=en-US&page=1&query='+title);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
    }
}

