({
    loadValues : function(component, field, targetAttribute) {
        var action= component.get("c.CatogeryValues");
        action.setParams({
            fieldName  : field, 
            objectName : component.get("v.valuesOnExpense")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                component.set(targetAttribute,response.getReturnValue());
            }
            else{
                alert('Error :'+response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    saveExpense  : function(component, field, targetAttribute) {
        var device = $A.get("$Browser.formFactor");
        var action= component.get("c.SaveExpense");
        action.setParams({
            Exp : component.get("v.valuesOnExpense"),
            usr : component.get("v.selectedUser")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                console.log(response.getReturnValue());
                if(response.getReturnValue() == 'Success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title	: 'Success',
                        message	: 'Expense Saved Successfully!!',
                        type	: 'success'
                        
                    });
                    toastEvent.fire();
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title	: 'Failure',
                        message	: response.getReturnValue(),
                        type	: 'error'
                        
                    });
                    toastEvent.fire();
                }
            }
            else{
                if(device == 'DESKTOP'){
                    alert('Error :'+response.getError());
                }
                else{
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    displayToast : function(component, event, helper, Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        console.log(Title+' == '+Message);
        toastEvent.setParams({
            title	: Title,
            message	: Message,
            type	: Type
            
        });
        toastEvent.fire();
    },
})