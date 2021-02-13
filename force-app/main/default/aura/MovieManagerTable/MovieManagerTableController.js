({

    init: function (cmp, event, helper) {
        cmp.set('v.tableColumns', [
            {label: 'Title', fieldName: 'originalTitle', type: 'text'},
            {label: 'Rating', fieldName: 'voteAverage', type: 'number'},
            {label: 'Release Date', fieldName: 'releaseDate', type: 'date'}
        ]);
    },

    pageChange: function(component, event, helper) {
        let pageNumber = event.getParam("pageNumber");
        
        component.set("v.pageNumber", pageNumber);
        
        helper.getAllSobjectRecords(component, pageNumber);
    },

    searchByEnter : function (component, event, helper){
        let pageNumber = component.get("v.pageNumber");

        if (event.keyCode === 13) {
            console.log('enterrrr');
            helper.getAllSobjectRecords(component, pageNumber);

        }
    }
})