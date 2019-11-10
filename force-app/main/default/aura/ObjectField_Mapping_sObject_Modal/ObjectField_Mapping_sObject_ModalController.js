({
    
     /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Controlelr
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping_sObject_Modal
    @ Language used			: Javascript
    @ No. of Listeners		: 9 Approx
    @ Extended to others	: No
    @ Cache enabled			: No
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
/*************************************************************************
Function Name:doInit
Description : Initial coponent load action to get all the list of available sObjects
**************************************************************************/
    doInit : function(component, event, helper) {
        var data = component.get('v.sObjectsList');
        if(helper.isNotBlank(component.get('v.selSObject.value'))){
            component.set('v.hasObject', true);
        }
        helper.splitObject(component,event,helper,data);
    },
    
/*************************************************************************
Function Name: cusCmpView
Description : To view only the custom components
**************************************************************************/
    cusCmpView : function(component, event, helper) {
        console.log('params '+JSON.stringify(event.getParams()));
        //component.set(v., event.getParam('checked'));
    },
    
/*************************************************************************
Function Name: stdCmpView
Description : To view only the standard components
**************************************************************************/
    stdCmpView : function(component, event, helper) {
        console.log('params '+JSON.stringify(event.getParams()));
        //component.set(v., event.getParam('checked'));
    },
    
/*************************************************************************
Function Name: Show/Hide spinner
Status : #Unused
Description : System events to say which state the component in
**************************************************************************/
    showSpinner : function(component, event, helper) {
        
    },
    hideSpinner : function(component, event, helper) {
        
    },
    
    
/*************************************************************************
Function Name: searchString
Description : Find the input string in the search box
**************************************************************************/
    searchString : function(component, event, helper){
        var search = component.find('searchIp');
        var str = event.getParam('value').toLowerCase();
        console.log('str '+str);
        var data = component.get('v.sObjectsList');
        var searchData =[];
        data.forEach(function(object){
            var contentValue = object.value.toLowerCase();
            var contentLabel = object.label.toLowerCase();
            if(contentValue.match(str) || contentLabel.match(str)){
                searchData.push(object);
            }
        });
        helper.splitObject(component,event,helper,searchData);        
    },
    
/*************************************************************************
Function Name: saveSObject
Description : Call the event and set parameter as the selected object
**************************************************************************/
    saveSObject : function(component, event, helper) {
        component.getEvent("objectSelected").setParams({
            data: component.get('v.selSObject')
        }).fire();
        component.destroy();
    },
    
    
/*************************************************************************
Function Name: getValue
Description : Get the value and push as a selected value, store as attribute
**************************************************************************/
    getValue : function(component, event, helper) {
        var val = event.currentTarget.dataset.val;
        var label = event.currentTarget.dataset.label;
        var obj = { 
            value : val,
            label : label
        };
        component.set('v.selSObject',obj);
        component.set('v.hasObject', true);
    },
    
/*************************************************************************
Function Name: closeModal
Description : Destroy component
**************************************************************************/
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    
})