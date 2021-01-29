public with sharing class MovieIntegrationAuraHelper {
    private Movie_API_token__mdt apiToken { get; set; }
    
    public class PageInfo {
        @AuraEnabled
        public Integer currentPageNumber {get;set;}
        
        @AuraEnabled
        public Integer totalPages {get;set;}
        
        @AuraEnabled
        public List<Integer> pageCounter {get;set;}

        public PageInfo(){
            
        }
        

        public PageInfo(Integer totalPages){
            Integer currentListCount = 5;
            
            this.totalPages = totalPages;
            this.currentPageNumber = 1;

            List<Integer> cnt = new List<Integer>();

            for(Integer loop_var = 0;loop_var < totalPages;loop_var++){
                cnt.add(loop_var+1);
                if((loop_var+1) == 4)
                    break;
            }

            if(totalPages > 4)
                cnt.add(totalPages);

            this.pageCounter = cnt;
        }
    }

    public class Movie {
        public string originalTitle { get;set; }
        public Decimal voteAverage { get;set; }
        public string releaseDate { get;set; }  

        public Movie(){}
        
        public Movie(string originalTitle, Decimal voteAverage, string releaseDate){
            this.originalTitle = originalTitle;
            this.voteAverage = voteAverage;
            this.releaseDate = releaseDate;
        }
    }

    public class MoviesWrapper {
        public List<Movie> movies { get;set; }
        public PageInfo pageInfo { get;set; }

        public MoviesWrapper(){
            this.pageInfo = new PageInfo();
            this.movies = new List<Movie>();
        }

        public MoviesWrapper(Integer totalPages, List<Movie> movies){
            this.pageInfo = new PageInfo(totalPages);
            this.movies = movies;
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

    private MoviesWrapper parseResponse(string movieTitleToSearch, Integer pageNumber){
        HTTPResponse res = sendRequest(movieTitleToSearch, pageNumber);

        Map<String, Object> generalResults = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
       
        Integer pagesCount = (Integer)generalResults.get('total_pages');

        List<Object> results = (List<Object>) generalResults.get('results');

        List<Movie> movieList = new List<Movie>();

        for (Object result : results) {
            Map<String,Object> returnedMovie = (Map<String,Object>) result;

            Movie mov = new Movie((String)returnedMovie.get('original_title'), (Decimal)returnedMovie.get('vote_average'), 
                (String)returnedMovie.get('release_date'));
            
            movieList.add(mov);
        }

        MoviesWrapper wrapper = new MoviesWrapper(pagesCount, movieList);

        return wrapper;
    }
   
    public MoviesWrapper getMoviesFromAPI(string movieTitleToSearch, Integer pageNumber) {
        if(this.apiToken == null)
            return new MoviesWrapper();

        MoviesWrapper wrapper = parseResponse(movieTitleToSearch, pageNumber);

        return wrapper;
    }
    
}
