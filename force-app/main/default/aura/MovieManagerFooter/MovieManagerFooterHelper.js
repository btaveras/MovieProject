({
    resetCounters : function (component,pNum,rCunt,totalPage) {
        var action = component.get("c.getPageCountChange");
        action.setParams({
            "pageNumber" : pNum.toString(),
            "totalPages" : totalPage.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.pageCounterInfo", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})