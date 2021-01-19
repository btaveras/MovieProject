public with sharing class MovieIntegrationAura {
    private static MovieIntegrationAuraHelper movieHelper {get;set;} 

    public MovieIntegrationAura(){
        movieHelper = new MovieIntegrationAuraHelper();
    }

    @AuraEnabled
    public static List<MovieIntegrationAuraHelper.Movie> findMovie(string movieTitleToSearch, Integer pageNumber) {
        List<MovieIntegrationAuraHelper.Movie> moviesList = new List<MovieIntegrationAuraHelper.Movie>();
        if (movieTitleToSearch != null && movieTitleToSearch != '') {
            moviesList = movieHelper.getMoviesFromAPI(movieTitleToSearch, pageNumber);
        }
        return moviesList;
    }
}