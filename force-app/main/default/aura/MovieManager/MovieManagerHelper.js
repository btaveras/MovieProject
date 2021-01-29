({
	getAllSobjectRecords : function(component, pNum) {
		var action = component.get("c.getAllRecords");

        let movieTitle = component.get('v.movieTitle');

		action.setParams({
            "movieTitleToSearch" : movieTitle.toString(),
            "pageNumber" : pNum.toString(),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.movies", response.getReturnValue().movies);    

                var appEvent = $A.get("e.c:movieSearchedEvt");
                appEvent.setParams({
                    "pageInfo" : response.getReturnValue().pageInfo});
                appEvent.fire();            
            }
        });
        $A.enqueueAction(action);	
	},
   
})