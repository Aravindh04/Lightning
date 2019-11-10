({
    getParentPicklistFieldsLc : function(component,event,helper,relationshipApi,valueType,sobject,objectName) {
        let allValues = component.get("v.allValues");
        let action = component.get("c.getParentPicklistFields");
        action.setParams({ 
            objectName: objectName,
            relationshipApi: relationshipApi
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let parentFields = {};
                let fMap = {};
                parentFields.list = [];
                let res = response.getReturnValue();
                console.log('response => ', JSON.stringify(res));
                
                for(let i in res){
                    fMap[res[i]['name']] = res[i];
                    
                    parentFields.list.push({'label':i, 
                                            'value':res[i]['name'], 
                                            'valueType':valueType,
                                            'selected':(parentFields.selected === res[i]['name']), 
                                            'isReference':res[i]['isReference'], 
                                            'fieldApi': res[i]['fieldApi'], 
                                            'relationshipApi': res[i]['relationshipApi'], 
                                            'relationshipParentApi': res[i]['relationshipParentApi'],
                                            'objectName':res[i]['objectName']});
                }
                
                console.log("fields list => ", JSON.stringify(parentFields));
                
                parentFields.map = fMap;
                
                helper.getNextNavigationLevel(component, event, helper, parentFields);
                
                //alert(("fields list => ", JSON.stringify(component.get("v.parentFields"))));
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    getNextNavigationLevel : function(component, event, helper, parentFields){
        
        $A.createComponent(
            "c:ESQ_LookupObjectFields",
            {
                parentFields: parentFields,
            },
            function(navigationItems, status, errorMessage){
                if (status === "SUCCESS") {
                    component.find("lookupNavigationPlaceHolder").set("v.body", navigationItems);
                }
                else if (status === "INCOMPLETE") {
                    alert("No response from server or client is offline.");
                }
                    else {
                        alert("Error: " + errorMessage);
                    }
            }
        ); 
    },
    apexCallbackElse : function(component,event,helper,response){
        let state = response.getState();
        if (state === "INCOMPLETE") {
            helper.showToast(component,event,helper,"INCOMPLETE!","INCOMPLETE","warning");
        }
        else if (state === "ERROR") {
            let errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    helper.showToast(component,event,helper,"ERROR!","Error message: " + errors[0].message,"error");
                }
            } else {
                console.log("Unknown error");
                helper.showToast(component,event,helper,"ERROR!","Unknown error","error");
            }
        }
    },
    
    showToast : function(component,event,helper,title,msg,type){
        let showToast = $A.get("e.force:showToast");
        if(showToast){
            showToast.setParams({
                "title": title,
                "message": msg,
                "type": type
            }).fire();
        }
        else{
            let toastProps = {};
            toastProps.title = title;
            toastProps.message = msg;
            toastProps.type = type;
            component.set("v.toastProps",toastProps);
            $A.util.removeClass(component.find("toast"),"slds-hide");
        }
    },
    
    //CHECK IF STRING IS NOT BLANK/NULL/UNDEFINED/EMPTY
    isNotBlank : function(checkString) {
        return (checkString != '' && checkString != null &&
                !$A.util.isEmpty(checkString) && !$A.util.isUndefined(checkString));
    },
})