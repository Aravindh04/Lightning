({
    stdOptions : function() {
        return {
            types:[
                {'label': 'Single Event', 'value': 'singleEvent'},
                {'label': 'Mass Tort', 'value': 'massTort'},
                {'label': 'Class Action', 'value': 'classAction'},
                {'label': 'High Volume', 'value': 'highVolume'}
            ],
            stages: [
                {'label': 'A', 'value': 'A'},
                {'label': 'B', 'value': 'B'},
                {'label': 'C', 'value': 'C'},
                {'label': 'D', 'value': 'D'}
            ],
            numberFields: [
                {'label': 'Matter Value', 'value': 'matterValue'},
                {'label': 'Retainer', 'value': 'retainer'},
                {'label': 'Gross', 'value': 'gross'},
                {'label': 'Net', 'value': 'net'},
                {'label': 'Close Date', 'value': 'closeDate'}
            ]
        };
    },
    selectThisParentField : function(component, event, helper, params) {
        helper.getRelatedRecords(component, event, helper);
        console.log(JSON.stringify(params));
        let value = params.val;
        let sobject = params.sobject;
        let valtype = params.valtype;
        
        if(valtype==='type'){
            component.set("v.typeFields.selectedParentValue", value);
            component.set("v.typeFields.selectedParentObject",sobject);
        }
        else if(valtype==='stage'){
            component.set("v.stageFields.selectedParentValue", value);
            component.set("v.stageFields.selectedParentObject",sobject);
        }
        helper.hideParentLookupModal(component);
    },
    getAllValuesLc : function(component,event,helper) {
        let action = component.get("c.getAllValues");
        action.setParams({ gfaId : component.get("v.gfaId") });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let allValues = response.getReturnValue();
                
                console.log("All Values => ", JSON.stringify(allValues));
                
                component.set("v.allValues", allValues);
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    getAllSObjectsLc : function(component,event,helper) {
        let allValues = component.get("v.allValues");
        let action = component.get("c.getAllObjectsList");
        helper.populateType(component, allValues.typesMappings);
        helper.populateStage(component, allValues.stagesMappings);
        action.setParams({  });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let sObjects = {};
                sObjects.list = [];
                let res = response.getReturnValue();
                
                for(let i in res){
                    if(helper.isNotBlank(allValues) && allValues.hasOwnProperty("selectedSObject")){
                        sObjects.selected = allValues.selectedSObject;
                    }
                    else if(!helper.isNotBlank(sObjects.selected) && res[i].toLowerCase().indexOf("matter")>-1){
                        sObjects.selected = res[i];
                    }
                    sObjects.list.push({'label':res[i], 'value':res[i]});
                    
                }
                
                console.log("sObjects list => ", JSON.stringify(sObjects.list));
                
                component.set("v.sObjects", sObjects);
                
                if(helper.isNotBlank(sObjects.selected)){
                    helper.getPicklistFieldsLc(component,event,helper);
                    //helper.getNumberFieldsLc(component,event,helper);
                }
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    getPicklistFieldsLc : function(component,event,helper) {
        let allValues = component.get("v.allValues");
        let action = component.get("c.getPicklistFields");
        action.setParams({ 
        	objectName: component.get("v.sObjects.selected")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let typeFields = {};
                let stageFields = {};
                let fMap = {};
                typeFields.list = [];
                stageFields.list = [];
                let res = response.getReturnValue();
                console.log('response => ', JSON.stringify(res));
                
                for(let i in res){
                    fMap[res[i]['name']] = res[i];
                    
                    if(helper.isNotBlank(allValues) && allValues.hasOwnProperty("selectedType")){
                        typeFields.selected = allValues.selectedType;
                    }
                    else if(!helper.isNotBlank(typeFields.selected) && i.toLowerCase().indexOf("type")>-1){
                        typeFields.selected = res[i]['name'];
                    }
                    if(helper.isNotBlank(allValues) && allValues.hasOwnProperty("selectedStage")){
                        stageFields.selected = allValues.selectedStage;
                    }
                    else if(!helper.isNotBlank(stageFields.selected) && i.toLowerCase().indexOf("stage")>-1){
                        stageFields.selected = res[i]['name'];
                    }
                    
                    typeFields.list.push({'label':i, 'value':res[i]['name'], 'selected':(typeFields.selected === res[i]['name']), 'isReference':res[i]['isReference'], 'fieldApi': res[i]['fieldApi'], 'relationshipApi': res[i]['relationshipApi']});
                    stageFields.list.push({'label':i, 'value':res[i]['name'], 'selected':(stageFields.selected === res[i]['name']), 'isReference':res[i]['isReference'], 'fieldApi': res[i]['fieldApi'], 'relationshipApi': res[i]['relationshipApi']});
                }
                
                console.log("fields list => ", JSON.stringify(typeFields));
                
                typeFields.map = fMap;
                stageFields.map = fMap;
                
                component.set("v.typeFields", typeFields);
                component.set("v.stageFields", stageFields);
                
                //alert(("fields list => ", JSON.stringify(component.get("v.typeFields"))));
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    getParentPicklistFieldsLc : function(component,event,helper,relationshipApi,valueType) {
        let allValues = component.get("v.allValues");
        let action = component.get("c.getParentPicklistFields");
        action.setParams({ 
            objectName: component.get("v.sObjects.selected"),
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
                
                if(valueType == 'type'){
                    component.set("v.parentTypeFields", parentFields);
                }else if(valueType == 'stage'){
                    component.set("v.parentStageFields", parentFields);
                }else{
                	component.set("v.parentFields", parentFields);    
                }
                
                
                
                //alert(("fields list => ", JSON.stringify(component.get("v.parentFields"))));
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    getNumberFieldsLc : function(component,event,helper) {
        let action = component.get("c.getNumberFields");
        action.setParams({ 
        	objectName: component.get("v.sObjects.selected")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                console.log("fields list => ", JSON.stringify(res));
                
                component.set("v.allValues.numberFieldsMappings",res);
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    getRelatedRecords:function(component,event,helper){
         
    },
    getPicklistOptionsLc : function(component,event,helper,fieldApi,attrName,objName) {
        let action = component.get("c.getPicklistValues");
        action.setParams({ 
            objectName: objName,
            picklistField: fieldApi
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let fields = {};
                fields.list = [];
                let res = response.getReturnValue();
                
                for(let i in res){
                    fields.list.push({custom:res[i],standard:""});
                }
                
                console.log("fields list => ", JSON.stringify(fields.list));
                
                component.set("v."+attrName,fields.list);
                
                if(attrName == 'allValues.typesMappings'){
                    helper.populateType(component, fields.list);
                }else if(attrName == 'allValues.stagesMappings'){
                    helper.populateStage(component, fields.list);
                }
                
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
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
    
    showParentLookupModal : function(component, valueType) {
        if(valueType == 'type'){
            $A.util.removeClass(component.find("lookupParentModalType"),"slds-hide");
        }else if(valueType == 'stage'){
            $A.util.removeClass(component.find("lookupParentModalStage"),"slds-hide");
        }else{
            $A.util.removeClass(component.find("lookupParentModal"),"slds-hide");
        }
        
    },
    
    hideParentLookupModal : function(component, valueType) {
        //component.set("v.parentFields",{});
        //component.find("ESQ_LookupObjectFields").clearParentLookups();
        if(valueType =='type'){
            $A.util.addClass(component.find("lookupParentModalType"),"slds-hide");
        }else if(valueType =='stage'){
            $A.util.addClass(component.find("lookupParentModalStage"),"slds-hide");
        }else{
            $A.util.addClass(component.find("lookupParentModalType"),"slds-hide");
            $A.util.addClass(component.find("lookupParentModalStage"),"slds-hide");
        }
        
    },
    
    populateList : function(component, allValues ) {
        var typelst = [];
        var stagelst = [];
        var typall= allValues.typesMappings;
        var stgall= allValues.stagesMappings;
        typall.forEach(function(val){
            var item ={
                label : val.custom,
                value : val.custom
            }
            typelst.push(item);
        });
        stgall.forEach(function(val){
            var item ={
                label : val.custom,
                value : val.custom
            }
            stagelst.push(item);
        });
        component.set('v.typeList',typelst);
        console.log('typeList '+JSON.stringify(typelst));
        component.set('v.stageList',stagelst);
        console.log('stageList '+JSON.stringify(stagelst));
    },
    
    populateType : function(component, typeVals ) {
        var typelst = [];
        typeVals.forEach(function(val){
            var item ={
                label : val.custom,
                value : val.custom
            }
            typelst.push(item);
        });
        component.set('v.typeList',typelst);
        console.log('typeList '+JSON.stringify(typelst));
    },
    
     populateStage : function(component, stageVals ) {
         var stagelst = [];
         stageVals.forEach(function(val){
             var item ={
                 label : val.custom,
                 value : val.custom
             }
             stagelst.push(item);
         });
         component.set('v.stageList',stagelst);
         console.log('stageList '+JSON.stringify(stagelst));
    },
})