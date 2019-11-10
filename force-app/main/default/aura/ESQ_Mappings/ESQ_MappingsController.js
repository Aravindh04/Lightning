({
    doInit : function(component, event, helper) {
        let action = component.get("c.getMappings");
        action.setParams({ });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let allValues = response.getReturnValue();
                console.log("All Values => ", allValues);
                if(helper.isNotBlank(allValues)){
                    component.set("v.allValues",JSON.parse(allValues.Mapping_JSON__c));
                }
                
                helper.getAllSObjectsLc(component,event,helper);
                component.set("v.stdOptions",helper.stdOptions());
            }
            else {
                helper.apexCallbackElse(component,event,helper,responsselectionConfirmede);
            }
        });
        $A.enqueueAction(action);
        
    },
    selectThisParentField : function(component, event, helper) {
        console.log(JSON.stringify(event.getParam("data")));
        helper.selectThisParentField(component, event, helper,event.getParam("data"));
    },
    sObjectSelected : function(component, event, helper) {
        helper.getPicklistFieldsLc(component,event,helper);
        //helper.getNumberFieldsLc(component,event,helper);
    },
    typeFieldSelected : function(component, event, helper) {
        let typeFields = component.get("v.typeFields");
        if(typeFields.map[typeFields.selected]["isReference"]==='true'){
            helper.getParentPicklistFieldsLc(component, event, helper, typeFields.map[typeFields.selected]["fieldApi"],'type');
            helper.showParentLookupModal(component,'type');
        }
        else{
            component.set("v.typeFields.selectedParentValue", '');
            component.set("v.typeFields.selectedParentObject",'');
        }
    },
    stageFieldSelected : function(component, event, helper) {
        let stageFields = component.get("v.stageFields");
        if(stageFields.map[stageFields.selected]["isReference"]==='true'){
            helper.getParentPicklistFieldsLc(component, event, helper, stageFields.map[stageFields.selected]["fieldApi"],'stage');
            helper.showParentLookupModal(component,'stage');
        }
        else{
            component.set("v.stageFields.selectedParentValue", '');
            component.set("v.stageFields.selectedParentObject",'');
        }
    },
    hideParentLookupModal : function(component, event, helper) {
        helper.hideParentLookupModal(component);
    },
    selectionConfirmed : function(component, event, helper) {
        console.log("component.get(v.typeFields",component.get("v.typeFields.selectedParentValue"));
        helper.getNumberFieldsLc(component,event,helper);
        if(helper.isNotBlank(component.get("v.typeFields.selectedParentValue"))){
            helper.getPicklistOptionsLc(component,event,helper,component.get("v.typeFields.selectedParentValue"),"allValues.typesMappings",component.get("v.typeFields.selectedParentObject"));
        }
        else{
            helper.getPicklistOptionsLc(component,event,helper,component.get("v.typeFields.selected"),"allValues.typesMappings",component.get("v.sObjects.selected"));
        }
        if(helper.isNotBlank(component.get("v.stageFields.selectedParentValue"))){
            helper.getPicklistOptionsLc(component,event,helper,component.get("v.stageFields.selectedParentValue"),"allValues.stagesMappings",component.get("v.stageFields.selectedParentObject"));
        }
        else{
            helper.getPicklistOptionsLc(component,event,helper,component.get("v.stageFields.selected"),"allValues.stagesMappings",component.get("v.sObjects.selected"));
        }
        //var allvals =component.get('v.allValues');
        //helper.populateList(component, allValues );
    },
    
    getSummaries : function(component, event, helper) {
        let allValues = component.get("v.allValues");
        allValues.selectedSObject = component.get("v.sObjects.selected");
        allValues.selectedType = component.get("v.typeFields.selected");
        allValues.selectedStage = component.get("v.stageFields.selected");
        allValues.mappings = JSON.stringify(allValues);
        
        component.set("v.allValues",allValues);
        
        let action = component.get("c.storeMappings");
        action.setParams({ mappings : JSON.stringify(allValues) });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let allValues = response.getReturnValue();
                console.log("All Values => ", JSON.stringify(allValues));
                helper.showToast(component,event,helper,"Success!","Mappings are saved successfully!","success");
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    matterStageSelected : function(component, event, helper) { 
        var allvals =component.get('v.allValues');
        console.log('stagesMappings '+JSON.stringify(allvals.stagesMappings));
        console.log('typesMappings '+JSON.stringify(allvals.typesMappings));
        console.log('all values '+JSON.stringify(allvals.typesMappings));
        
    },
    
    unHideModal : function(component, event, helper) {
        var selection = event.getSource().get('v.value');
        console.log('value '+selection);
        helper.showParentLookupModal(component, selection);
    },
    
    handleChange: function (component, event) {
        alert(event.getParam('value'));
    },
})