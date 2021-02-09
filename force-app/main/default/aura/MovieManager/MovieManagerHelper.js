({
	getAllSobjectRecords : function(component, pNum) {
		var action = component.get("c.getAllRecords");

        let movieTitle = component.get('v.movieTitle');

		action.setParams({
            "movieTitleToSearch" : movieTitle.toString(),
            "pageNumber" : pNum.toString(),
        });

        console.log('pagination thing '+ movieTitle.toString());
        console.log('page number '+pNum.toString());

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log(response.getReturnValue().movies);
                component.set("v.movies", response.getReturnValue().movies);    

                var appEvent = $A.get("e.c:movieSearchedEvt");
                appEvent.setParams({
                    "pageInfo" : response.getReturnValue().pageInfo});
                appEvent.fire();            
            }
            else{ 
                var error = response.getError();
                if(error){
                    console.log("Errors");
                    console.log(error);
                }
            }
        });
        $A.enqueueAction(action);	
	},
   
})