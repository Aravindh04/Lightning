({
    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Helper
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping_Lookup
    @ Language used			: Javascript
    @ No. of Listeners		: 5
    @ Extended to others	: No
    @ Cache enabled			: No
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
    
/*************************************************************************
Function Name: getParentPicklistFieldsLc
Description : Get Picklist field for the selected object and attribute
**************************************************************************/
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
                parentFields.traverse = component.get('v.parentFields.traverse')+ ' > '+relationshipApi;
                parentFields.list = [];
                parentFields.title = relationshipApi;
                let res = response.getReturnValue();
                console.log('response => ', JSON.stringify(res));
                
                for(let i in res){
                    fMap[res[i]['name']] = res[i];
                    
                    parentFields.list.push({'label':i, 
                                            'fieldLabel':res[i]['label'], 
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
                
                helper.getNextNavigationLevel(component, event, helper, parentFields, objectName);
                
                //alert(("fields list => ", JSON.stringify(component.get("v.parentFields"))));
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    
/*************************************************************************
Function Name: getNextNavigationLevel
Description : After creating the field values for the reference create and
				pass it to the same component and push it to the placeholder
**************************************************************************/
    getNextNavigationLevel : function(component, event, helper, parentFields, objectName){
        
        $A.createComponent(
            "c:ObjectField_Mapping_Lookup",
            {
                parentFields: parentFields,
                title : objectName
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
    
    
/*************************************************************************
Function Name: apexCallbackElse
Description : If the response is Incomplete or Error or Failed, Show toast
				of the error message
**************************************************************************/
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
    
/*************************************************************************
Function Name: showToast
Description : Show different toast message for the different field selected
**************************************************************************/
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
    
/*************************************************************************
Function Name: isNotBlank
Description : Check whether the passes parameter is null or undefined or Empty
**************************************************************************/
    isNotBlank : function(checkString) {
        return (checkString != '' && checkString != null &&
                !$A.util.isEmpty(checkString) && !$A.util.isUndefined(checkString));
    },
})