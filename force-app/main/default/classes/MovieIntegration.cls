public with sharing class MovieIntegration {
    public String MovieTitle { get; set; }
    public List <Movie> movieList { get; set; }
    
    private Movie_API_token__mdt apiToken { get; set; }
    private integer totalRecs = 0;
    private integer pagesCount = 0;
    private integer pageNumber = 1;
    private integer LimitSize = 20;

    private class Movie {
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

    public MovieIntegration(){
        this.movieList = new List <Movie>();
        this.apiToken = [SELECT Token__c FROM Movie_API_token__mdt LIMIT 1];
    }
   
    private HTTPResponse sendRequest(){
        HttpRequest req = new HttpRequest();
        String encodedTitle = EncodingUtil.urlEncode(this.MovieTitle,'UTF-8');

        req.setEndpoint('callout:MovieDB/search/movie?api_key='+this.apiToken.Token__c+'&language=en-US&page='+pageNumber+'&query='+encodedTitle);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }

    private List<Object> parseResponse(){
        HTTPResponse res = sendRequest();

        Map<String, Object> generalResults = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        totalRecs = (Integer)generalResults.get('total_results');
        pagesCount = (Integer)generalResults.get('total_pages');

        List<Object> results = (List<Object>) generalResults.get('results');

        return results;
    }
   
    private void getMoviesFromAPI() {
        if(this.apiToken == null)
            return;

        List<Object> results = parseResponse();

        this.movieList = new List <Movie>();
        for (Object result : results) {
            Map<String,Object> returnedMovie = (Map<String,Object>) result;

            Movie mov = new Movie((String)returnedMovie.get('original_title'), (Decimal)returnedMovie.get('vote_average'), 
                (String)returnedMovie.get('release_date'));
            
            this.movieList.add(mov);
        }
    }
    
    public void findMovie() {
        pageNumber = 1;
        if (MovieTitle != null && MovieTitle != '') {
            getMoviesFromAPI();
        }
    }

    public void FirstPage() {
        pageNumber = 1;
        getMoviesFromAPI();
    }

    public void previous() {
        pageNumber = (pageNumber - 1);
        getMoviesFromAPI();
    }

    public void next() {
        pageNumber = pageNumber + 1;
        getMoviesFromAPI();
    }

    public void LastPage() {
        pageNumber = pagesCount;
        getMoviesFromAPI();
    }

    public boolean getprev() {
        if (pageNumber == 1) {
            return true;
        } else {
            return false;
        }
    }

    public boolean getnxt() {
        if ((pageNumber * LimitSize) > totalRecs) {
            return true;
        } else {
            return false;
        }
    }
}