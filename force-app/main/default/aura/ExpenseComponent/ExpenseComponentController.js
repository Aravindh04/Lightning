({
	scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded..'); 
    },
    
    doInit : function(component,event,helper){
        //call apex class method
        var action = component.get('c.getExp');
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in lstOpp attribute on component.
                component.set('v.lstEXP', response.getReturnValue());
                
                // when response successfully return from server then apply jQuery dataTable after 500 milisecond
                setTimeout(function(){ 
                    $('#tableId').DataTable();
                    // add lightning class to search filter field with some bottom margin..  
                    $('div.dataTables_filter input').addClass('slds-input');
                    $('div.dataTables_filter input').css("marginBottom", "10px");
                }, 500);          
            }
        });
        $A.enqueueAction(action); 
    },
})