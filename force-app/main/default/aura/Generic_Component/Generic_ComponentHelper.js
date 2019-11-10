({ 
    
/*************************************************************************
Function Name: CallServer
Created Date : 1/12/2017
Author : Aravindh Vijayakumar
Description : Generic controller Action To get details from Apex controller
**************************************************************************/     
    callServer : function(component,method,callback,params) {
        
        //1.Get reference to server side controller Method
        var action = component.get(method);
        
        //2.set parametrs if there are any such
        if(params){
            action.setParams(params);
        }
        
        //3.Register call back function and handle response
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=="SUCCESS"){
                var result = response.getReturnValue();
                callback.call(this,result);
            }else{
                var error = response.getError();
                console.log(error[0].message);
            }
            
        });
        
        //4. use Enqueue action and place server call in queue
        $A.enqueueAction(action);
        
    },

/*************************************************************************
Function Name: ComponentCreation
Created Date : 1/12/2017
Author : Aravindh Vijayakumar
Description : Generic Component To Create a New Component
**************************************************************************/     
    //Params Include
    //1.Component
    //2.Creating Component Name eg. "c.Opportunity_Card_Component
    //To get the Callback Response eg. "function(result)"
    //Parameters in JSON Format eg. { OppId	: "OpportunityId", etc}
    
    callComponent: function(component, compName, callback, Params) {
        $A.createComponent(compName, Params, function(response,status,errorMessage){
            if(status == 'SUCCESS'){
                callback.call(this,response);
            }
            else{
                console.log(errorMessage);
            }
        }
                           );   

    },
    
/*************************************************************************
Function Name: ComponentCreation
Created Date : 1/12/2017
Author : Aravindh Vijayakumar	
Description : To Push into The body of the component
**************************************************************************/     
    getToPlaceHolder: function(component, result, popBody) {
        var componentBody = component.find("bodyContainer");
        var body = component.get("v.body");
        if(popBody){
            body.pop();
        }
        body.push(result);
        componentBody.set("v.body",body);
    },
    
    
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

/*************************************************************************
Function Name: ComponentCreation
Created Date : 1/12/2017
Author : Aravindh Vijayakumar
Description : To Push into The body of the component
**************************************************************************/     
    getCardsToPlaceHolder: function(component, result, placeHolder, cardType) {
        var componentBody = component.find(placeHolder);
        var body = component.get("v.body");
        body.pop();    
        body.push(result);
        componentBody.set("v.body",body);
    },
    
    
/*************************************************************************
Function Name: Navigating to related List
Created Date : 1/12/2017
Author : Aravindh Vijayakumar
Description : To Navigate to the related List
**************************************************************************/     
    getToRelatedList: function(component, Id, listName) {
        var relListURL = '/one/one.app#/sObject/' + Id + '/rlName/'+listName+'/view';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : relListURL
        })
        console.log(relListURL);
        urlEvent.fire();
    },
    
/*************************************************************************
Function Name: ShowToast
Created Date : 1/12/2017
Author : Preethi Ravindran
Description : To Show Toast Message
**************************************************************************/     
    showToast : function(component, event, helper, toastTitle, toastMessage, toastType, toastDuration) {
        
        var type;
        if(toastType){
            type=toastType;
        }else{
            type ='success';
        }
        
        var visibileDuration;
        if(toastDuration){
            visibileDuration = toastDuration;
        }else{
            visibileDuration = 8000;
        }
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title"		: toastTitle,
            "message"	: toastMessage,
            "type" 		: type,
            "duration" 	: visibileDuration
        });
        toastEvent.fire();
    },
    
/*************************************************************************
Function Name: navigateToSobject
Created Date : 22/5/2018
Author : Aravindh Vijayakumar
Description : To go to the record.
**************************************************************************/     
    navigateToSobject: function(component, event, helper, recordId, objectType) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },

})