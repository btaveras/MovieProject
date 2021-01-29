({
    pageChange: function(component, event, helper) {
        var pageNumber = event.getParam("pageNumber");
        
        component.set("v.pageNumber", pageNumber);
        
        helper.getAllSobjectRecords(component, pageNumber);
    },
    
    recordCounterChange : function(component, event, helper){
        component.set("v.pageNumber", '1');
        helper.getAllSobjectRecords(component, '1');
    },

    searchByEnter : function (component, event, helper){
        if (event.keyCode === 13) {
            helper.getAllSobjectRecords(component, pageNumber);

        }
    }
})