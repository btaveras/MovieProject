public with sharing class MovieIntegrationAuraHelper {
    private Movie_API_token__mdt apiToken { get; set; }

    public class Movie {
        public string original_title { get;set; }
        public Decimal vote_average { get;set; }
        public string release_date { get;set; }  

        public Movie(){}
        
        public Movie(string original_title, Decimal vote_average, string release_date){
            this.original_title = original_title;
            this.vote_average = vote_average;
            this.release_date = release_date;
        }
    }

    public MovieIntegrationAuraHelper() {
        this.apiToken = [SELECT Token__c FROM Movie_API_token__mdt LIMIT 1];
    }

    private HTTPResponse sendRequest(string movieTitleToSearch, Integer pageNumber){
        HttpRequest req = new HttpRequest();
        String encodedTitle = EncodingUtil.urlEncode(movieTitleToSearch,'UTF-8');

        req.setEndpoint('callout:MovieDB/search/movie?api_key='+this.apiToken.Token__c+'&language=en-US&page='+pageNumber+'&query='+encodedTitle);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    private List<Object> parseResponse(string movieTitleToSearch, Integer pageNumber){
        HTTPResponse res = sendRequest(movieTitleToSearch, pageNumber);

        Map<String, Object> generalResults = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       
        List<Object> results = (List<Object>) generalResults.get('results');

        return results;
    }
   
    public List<Movie> getMoviesFromAPI(string movieTitleToSearch, Integer pageNumber) {
        if(this.apiToken == null)
            return new List<Movie>();

        List<Object> results = parseResponse(movieTitleToSearch, pageNumber);

        List<Movie> movieList = new List<Movie>();

        for (Object result : results) {
            Map<String,Object> returnedMovie = (Map<String,Object>) result;

            Movie mov = new Movie((String)returnedMovie.get('original_title'), (Decimal)returnedMovie.get('vote_average'), 
                (String)returnedMovie.get('release_date'));
            
            movieList.add(mov);
        }
        return movieList;
    }
    
}
