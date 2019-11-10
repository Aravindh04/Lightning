({
	callComponentToPlaceHolder: function(component, childCompName, targetPlaceHolder, params,helper,callback) { 
        $A.createComponent(childCompName, params, function(newComp, status, errorMessage) {
                    if(status === "SUCCESS"){
                        component.find(targetPlaceHolder).set("v.body", newComp);
                    }else if(status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.");
                    }else if(status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
                }
            );
     },
})