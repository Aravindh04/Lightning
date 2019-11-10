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
Function Name: getNumberFieldsLc
Description : Get Picklist field for the selected object and attribute
**************************************************************************/
	getNumberFieldsLc : function(component,event,helper,objectName, traverse) {
        let action = component.get("c.getNumberFields");
        action.setParams({ 
            objectName: objectName
        });
        action.setCallback(this, function(response) {
            let totVals = response.getReturnValue();
            console.log(response.getState());
            var totlst = [];
            var i=0;
            var type = component.get('v.numFieldType');
            totVals.forEach(function(val){
                if(val.fieldType == type){
                    var item ={
                        label : val.customLabel,
                        value : val.custom,
                        fieldType : val.fieldType,
                        objectName : val.objectName,
                        index : i
                    };
                    totlst.push(item);
                }
                i++;
            });
            if(totlst.length > 0){
                helper.getNextNavigationLevel(component, event, helper, totlst, type, traverse);
            }else{
                helper.showToast(component,event,helper,'Info','The Object \''+objectName+'\' has no '+type+' fields','info');
                helper.getNextNavigationLevel(component, event, helper, totlst, type, traverse);
            }
            
        });
        $A.enqueueAction(action);
    },

    
/*************************************************************************
Function Name: getNextNavigationLevel
Description : After creating the field values for the reference create and
				pass it to the same component and push it to the placeholder
**************************************************************************/
    getNextNavigationLevel : function(component, event, helper, totList, fieldType, traverse){
        console.log('inside create');
        console.log('traverse '+traverse);
        $A.createComponent(
            "c:ObjectField_Mapping_FieldMapping",
            {
                parentFields: totList,
                numFieldType : fieldType,
                standardField : component.get('v.standardField'),
                traverse :  traverse
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
    
    //CHECK IF STRING IS NOT BLANK/NULL/UNDEFINED/EMPTY
    isNotBlank : function(checkString) {
        return (checkString != '' && checkString != null &&
                !$A.util.isEmpty(checkString) && !$A.util.isUndefined(checkString));
    },
})