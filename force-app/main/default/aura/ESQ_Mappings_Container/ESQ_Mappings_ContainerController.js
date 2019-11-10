({
    doInit : function(component, event, helper) {
        /*let action = component.get("c.getMappings");
        action.setParams({ });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let allValues = response.getReturnValue();
                console.log("All Values => ", allValues);
                if(helper.isNotBlank(allValues)){
                    component.set("v.allValues",JSON.parse(allValues.Mapping_JSON__c));
                }
                
                
                component.set("v.stdOptions",helper.stdOptions());
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);*/
        helper.getAllSObjectsLc(component,event,helper);
        
    },
    sObjectSelected : function(component, event, helper) {
        helper.getPicklistFieldsLc(component,event,helper);
        //helper.getNumberFieldsLc(component,event,helper);
    },
    typeFieldSelected : function(component, event, helper) {
        let typeFields = component.get("v.typeFields");
        if(typeFields.map[typeFields.selected]["isReference"]==='true'){
            helper.getParentPicklistFieldsLc(component, event, helper, typeFields.map[typeFields.selected]["fieldApi"]);
            helper.callComponentToPlaceHolder(component,'c:ESQ_Mappings_Modal','lookupParentModal',({ parentFields : component.get('v.parentFields')}));
        }
        //helper.getPicklistOptionsLc(component,event,helper,component.get("v.typeFields.selected"),"allValues.typesMappings");
    },
    stageFieldSelected : function(component, event, helper) {
        let stageFields = component.get("v.stageFields");
        if(stageFields.map[stageFields.selected]["isReference"]==='true'){
            helper.getParentPicklistFieldsLc(component, event, helper, stageFields.map[stageFields.selected]["fieldApi"]);
            helper.showParentLookupModal(component);
        }
        //helper.getPicklistOptionsLc(component,event,helper,component.get("v.stageFields.selected"),"allValues.stagesMappings");
    },
    hideParentLookupModal : function(component, event, helper) {
        helper.hideParentLookupModal(component);
    },
    selectionConfirmed : function(component, event, helper) {
        component.set("v.allValues",{});
        helper.getNumberFieldsLc(component,event,helper);
        helper.getPicklistOptionsLc(component,event,helper,component.get("v.typeFields.selected"),"allValues.typesMappings");
        helper.getPicklistOptionsLc(component,event,helper,component.get("v.stageFields.selected"),"allValues.stagesMappings");
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
})