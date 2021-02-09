public with sharing class MovieIntegrationAura {
    @AuraEnabled
    public static MovieIntegrationAuraHelper.MoviesWrapper getAllRecords(string movieTitleToSearch, Integer pageNumber) {
        MovieIntegrationAuraHelper movieHelper = new MovieIntegrationAuraHelper();
        MovieIntegrationAuraHelper.MoviesWrapper wrapper  = new MovieIntegrationAuraHelper.MoviesWrapper();
        if (movieTitleToSearch != null && movieTitleToSearch != '') {
            wrapper = movieHelper.getMoviesFromAPI(movieTitleToSearch, pageNumber);
        }
        return wrapper;
    }
    
    /*When page count change or next or previous button is clicked
      provide footer with new set of page counter info to display */
    @AuraEnabled
    public static MovieIntegrationAuraHelper.PageInfo getPageCountChange(String pageNumber,String currentPagesCount,String totalPages){
        MovieIntegrationAuraHelper.PageInfo pgn = new MovieIntegrationAuraHelper.PageInfo();
        pgn.currentPageNumber = Integer.valueOf(pageNumber);
        pgn.totalPages = Integer.valueOf(totalPages);
        
        List<Integer> cnt = new List<Integer>();
        
        if((Integer.valueOf(pageNumber)+2) < Integer.valueOf(totalPages) && Integer.valueOf(pageNumber) != 1){
            for(Integer loop_var = (Integer.valueOf(pageNumber)-1);loop_var < (Integer.valueOf(pageNumber)+3);loop_var++){
                cnt.add(loop_var);
            }
            cnt.add(pgn.totalPages);
            
        }else if(Integer.valueOf(pageNumber) == 1){
            for(Integer loop_var = 1;loop_var < 5;loop_var++){
                cnt.add(loop_var);
            }
            cnt.add(pgn.totalPages);
        }else{
            if(Integer.valueOf(currentPagesCount) >= pgn.totalPages){
                for(Integer loop_var = 1;loop_var < (pgn.totalPages+1);loop_var++){
                    cnt.add(loop_var);
                }
            }else{
                for(Integer loop_var = (pgn.totalPages-4);loop_var < (pgn.totalPages+1);loop_var++){
                    cnt.add(loop_var);
                }
            }
        }
        pgn.pageCounter = cnt;
        
        return pgn;
    }
 
}