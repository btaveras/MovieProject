({ 
    // Go to previous page
    goPreviousPage : function (component) {
        var pageNumber = component.get("v.pageCounterInfo.currentPageNumber");
        var currnetPagesCount = 5;
        
        var myEvent = $A.get("e.c:PageChangeEvt");
        myEvent.setParams({
            "pageNumber": (parseInt(pageNumber)-1).toString(),
            "currnetPagesCount": currnetPagesCount.toString()
        });
        myEvent.fire();
    },
    
    // go to next page
    goNextPage : function (component) {
        var pageNumber = component.get("v.pageCounterInfo.currentPageNumber");
        var currnetPagesCount = 5;
        
        var myEvent = $A.get("e.c:PageChangeEvt");
        myEvent.setParams({
            "pageNumber": (parseInt(pageNumber)+1).toString(),
            "currnetPagesCount": currnetPagesCount.toString()
        });
        myEvent.fire();
    },
    
    // Page count button click and page change
    pageChange: function (component, event, helper) {
        var pageNumber = event.getParam("pageNumber");
        var totalPages = component.get("v.pageCounterInfo.totalPages");
        helper.resetCounters(component, pageNumber, currnetPagesCount,totalPages);
    },

    movieSearched: function (component, event) {
        component.set("v.pageCounterInfo", event.getParam("pageInfo"));
    }
})