public with sharing class MovieIntegration {
    public String MovieTitle { get; set; }
    public List <Movie> movieList { get; set; }
    
    private integer totalRecs = 0;
    private integer pageNumber = 1;
    private integer LimitSize = 10;

    public MovieIntegration(){
        this.movieList = new List <Movie>();
    }

    public class Movie{
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
   
    public void getMovieFromAPI() {
        Movie_API_token__mdt apiToken = 
            [SELECT Token__c FROM Movie_API_token__mdt LIMIT 1];

        if(apiToken == null)
            return;

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:MovieDB/search/movie?api_key='+apiToken.Token__c+'&language=en-US&page='+pageNumber+'&query='+title);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        Map<String, Object> generalResults = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        List<Object> results =  (List<Object>) generalResults.get('results');

        this.movieList.clear();

        for (Object result : results) {
            Map<String,Object> returnedMovie = (Map<String,Object>) result;

            Movie mov = new Movie((String)returnedMovie.get('original_title'), (Decimal)returnedMovie.get('vote_average'), 
                (String)returnedMovie.get('release_date'));
            
            this.movieList.add(mov);
        }
    }
    
    public void findMovie() {
        totalRecs = 0;
        pageNumber = 1;
        if (movieList != null && movieList.size() > 0) {
            movieList = null;
        }
        
        //movieList.clear();

        if (MovieTitle != null && MovieTitle != '') {
            String encodedTitle = EncodingUtil.urlEncode(MovieTitle,'UTF-8');
            //movieList = getMovieFromAPI(encodedTitle);
            getMovieFromAPI(encodedTitle, this.pageNumber);
        }
    }

    public void FirstPage() {
        pageNumber = 1;
        findMovie();
    }

    public void previous() {
        pageNumber = (pageNumber - LimitSize);
        findMovie();
    }

    public void next() {
        pageNumber = pageNumber + LimitSize;
        findMovie();
    }

    public void LastPage() {
        pageNumber = totalrecs - math.mod(totalRecs, LimitSize);
        findMovie();
    }

    public boolean getprev() {

        if (pageNumber == 1) {

            return true;
        } else {

            return false;
        }
    }

    public boolean getnxt() {
        if ((pageNumber + LimitSize) > totalRecs) {

            return true;
        } else {

            return false;
        }
    }
}