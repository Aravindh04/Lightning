({
    
    
    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Helper
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping
    @ Language used			: Javascript
    @ No. of Listeners		: 27 Approx
    @ Extended to others	: No
    @ Cache enabled			: No
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
    
/*************************************************************************
Function Name: callServer
Description : Apex callout
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
                console.log(response.getError());
                var errors = response.getError();
                if(errors[0] && errors[0].pageErrors)
                    console.log("Error : "+errors[0].pageErrors[0].message);  
            }
            
        });
        
        //4. use Enqueue action and place server call in queue
        $A.enqueueAction(action);
        
    },
    
    
/*************************************************************************
Function Name: resetAllValues
Description : Reset all populated attribute values
**************************************************************************/
    resetAllValues : function(component) { 
        var resettingAttributes = [
            'singleEventFields',
            'massTortFields',
            'classActionFields',
            'stageAFields',
            'stageBFields',
            'stageCFields',
            'stageDFields',
            'tempTypeOptions',
            'tempStageOptions',
            'typeOptions',
            'stageOptions'
        ];
        var resettingAttributes2 = [
            'typeFields',
            'stageFields',
            'totValueField',
            'closedDateFields',
            'grossFields',
            'netFields',
            'retainerFields',
            'caseIndexFields',
            'caseNameFields',
            'pctFeeFields',
            'dollarFeeFields',
            'venueFields'
        ];
        resettingAttributes.forEach(function(attri){
            component.set('v.'+attri,[]);
        });
        resettingAttributes2.forEach(function(attri){
            component.set('v.'+attri,{});
        });
        component.set('v.selectTab','caseTypeSel');
    },
    
/*************************************************************************
Function Name: resetAllDisabled
Description : Reset all disabled confirm and inpput and disable change
**************************************************************************/
    resetAllDisabled : function(component) { 
        var resettingAttributes = [
            'caseTypeFld',
            'stageTypeFld',
            'caseNameFld',
            'caseIndexFld',
            'venueFld',
            'closeDateFields',
            'totalValueFld',
            'retainerFields',
            'grossFields',
            'dollarFeeFld',
            'pctFeeFld',
            'netFields'
        ];
        resettingAttributes.forEach(function(attribe){
            var ipField = component.find(attribe);
            ipField.set('v.disabled',false);
            var confirm = component.find(attribe+'Confirm');
            confirm.set('v.disabled',false);
            var change = component.find(attribe+'Change');
            change.set('v.disabled',true);
        });
    },
    
    
/*************************************************************************
Function Name: resetTypeVal
Description : Reset all the Type Values for the existing fields
**************************************************************************/
    resetTypeVal : function(component){ 
        var resettingAttributes = [
            'singleEventFields',
            'massTortFields',
            'classActionFields',
            'tempTypeOptions',
            'typeOptions'
        ];
        resettingAttributes.forEach(function(attri){
            component.set('v.'+attri,[]);
        });
    },
    
/*************************************************************************
Function Name: resetTypeVal
Description : Enable UnMap and Next, disable Map
**************************************************************************/
    mappingExists : function(component,fieldOf){ 
        var nextBtn =  component.find('submit'+fieldOf);
        nextBtn.set('v.disabled',false);
        var mapBtn = component.find('map'+fieldOf+'Id');
        $A.util.addClass(mapBtn,'slds-hide');
        var unMapBtn = component.find('unmap'+fieldOf+'Id');
        $A.util.removeClass(unMapBtn,'slds-hide');
        var items;
        if(fieldOf == 'Type'){
            items = component.get('v.stdOptions.types');            
        }else if(fieldOf == 'Stage'){
            items = component.get('v.stdOptions.stages');
        }
        items.forEach(function(eachItem){
            var divElmt = component.find(eachItem.value);
            $A.util.addClass(divElmt, 'disable');
        });
    },
    
/*************************************************************************
Function Name: resetStageVal
Description : Reset all the Type Values for the existing fieldsa
**************************************************************************/
    resetStageVal : function(component){ 
        var resettingAttributes = [
            'stageAFields',
            'stageBFields',
            'stageCFields',
            'stageDFields',
            'tempStageOptions',
            'stageOptions'
        ];
        resettingAttributes.forEach(function(attri){
            component.set('v.'+attri,[]);
        });
    },
    
/*************************************************************************
Function Name: hideNaviationsItems
Description : Hide all the standard navigations items and show Select fields
**************************************************************************/
    hideNaviationsItems : function(component){ 
        var type = component.get('v.stdOptions.types');
        var stage = component.get('v.stdOptions.stages');
        var flds= type.concat(stage);
        console.log('flds '+JSON.stringify(flds));
        flds.forEach(function(fld){
            var dualList = component.find(fld.value);
            $A.util.addClass(dualList,'slds-hide');
        });
        $A.util.removeClass(component.find('typeNull'),'slds-hide');
        $A.util.removeClass(component.find('stageNull'),'slds-hide');
    },
    
/*************************************************************************
Function Name: callComponentToPlaceHolder
Description : Create new component and push it to the placeholder
**************************************************************************/
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
Function Name: mapToList
Description : Convert the values from the Map to a standard list format
**************************************************************************/
    mapToList : function(component, event, helper, cusMap, callback) {
        var items = [];
        for(var keyName in cusMap){
            var item = {
                value: keyName,
                label: cusMap[keyName]
            };
            items.push(item);
        }
        callback.call(this,items);
    },
    
    
/*************************************************************************
Function Name: stdOptions
Description : Standard options for Mapping
**************************************************************************/
	stdOptions : function() {
        return {
            types:[
                {'label': 'Single Event', 'value': 'singleEvent'},
                {'label': 'Mass Tort', 'value': 'massTort'},
                {'label': 'Class Action', 'value': 'classAction'}
            ],
            stages: [
                {'label': 'A - Initial Investigation', 'value': 'stageA'},
                {'label': 'B - In Progress', 'value': 'stageB'},
                {'label': 'C - Settled or Closed', 'value': 'stageC'},
               // {'label': 'D', 'value': 'stageD'}
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
    
/*************************************************************************
Function Name: confirm
Description : Disable the relevent field and enable the change button
**************************************************************************/
    confirm :  function(component,event) {
        var source = event.getSource();
        //Disable the selected button
        source.set('v.disabled',true);
        var selection = source.get('v.class');
        console.log('selection '+selection);
        var disFld = component.find(selection);
        disFld.set('v.disabled',true);
        var disChangeBtn = component.find(selection+'Change');
        disChangeBtn.set('v.disabled',false);
    },
    
/*************************************************************************
Function Name: change
Description : Enable the relevent field and disable the change button
**************************************************************************/
    change :  function(component,event) {
        var source = event.getSource();
        //Disable the selected button
        var source = event.getSource();
        //Disable the selected button
        source.set('v.disabled',true);
        var selection = source.get('v.class');
        var disFld = component.find(selection);
        disFld.set('v.disabled',false);
        var disChangeBtn = component.find(selection+'Confirm');
        disChangeBtn.set('v.disabled',false);
    },
    
    
/*************************************************************************
Function Name: disableExisting
Description : Initial Load action, executed without user trigger
**************************************************************************/
    disableExisting : function(component, allDisVals){
        allDisVals.forEach(function(disVal){
            console.log('disVal '+disVal);
            var source = component.find(disVal);
            source.set('v.disabled',true);
            var disFld = component.find(disVal+'Confirm');
            disFld.set('v.disabled',true);
            var disChangeBtn = component.find(disVal+'Change');
            disChangeBtn.set('v.disabled',false);
           console.log('disVal success for '+disVal); 
        });
    },
    
    
/*************************************************************************
Function Name: getAllValuesLc
Description : Initial Load action, executed without user trigger
**************************************************************************/
    getAllValuesLc : function(component,event,helper) {
        helper.callServer(component,"c.getAllValues",function(result){
             component.set("v.allValues", allValues);
        });
    },
    
    
/*************************************************************************
Function Name: getMappings
Description : Get all values from the existing template created and put as a Map
**************************************************************************/
    getMappings : function(component,event,helper) {
        helper.callServer(component,"c.getAllValues",function(result){
            if(helper.isNotBlank(result)){
                component.set("v.allValues",JSON.parse(result.Mapping_JSON__c));
            }
        });
    },
    
    
/*************************************************************************
Function Name: selectThisParentField
Description : Trigger by and event on an external/child component
				to select a field type or field stage values
**************************************************************************/
    selectThisParentField : function(component, event, helper, params) {
        let value = params.val;
        let traverse = params.traverse;
        let sobject = params.sobject;
        let valtype = params.valtype;
        
        if(valtype =='type'){
            component.set("v.typeFields.selectedParentValue", value);
            component.set("v.typeFields.selectedParentObject",sobject);
            component.set("v.typeFields.traverse",traverse);
        }
        else if(valtype =='stage'){
            component.set("v.stageFields.selectedParentValue", value);
            component.set("v.stageFields.selectedParentObject",sobject);
            component.set("v.stageFields.traverse",traverse);
        }
        helper.hideParentLookupModal(component);
    },
    
    
    
/*************************************************************************
Function Name: getNumberFieldsLc
Description : To get the other field mappings
**************************************************************************/
    getNumberFieldsLc : function(component,event,helper) {
        let action = component.get("c.getNumberFields");
        action.setParams({ 
            objectName: component.get("v.selectMasterObject.value")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                console.log("Number Mappings", JSON.stringify(res));
                
                component.set("v.allValues.numberFieldsMappings",res);
                helper.populateTotValue(component, res);
            }
            else {
                helper.apexCallbackElse(component,event,helper,response);
            }
        });
        $A.enqueueAction(action);
    },
    
    
/*************************************************************************
Function Name: getPicklistOptionsLc
Description : Get the field picklists or record value for the selected field
**************************************************************************/
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
                
                console.log("fields list ", JSON.stringify(fields.list));
                
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
    
/*************************************************************************
Function Name: getPicklistFieldsLc
Description : Get Picklist field for the selected object and attribute
**************************************************************************/
    getPicklistFieldsLc : function(component,event,helper, params) {
        var allValues = component.get('v.allValues');
        var masterObj= component.get('v.selectMasterObject');
        var selectedObjName = masterObj.value;
        helper.callServer(component,"c.getPicklistFields",function(fldMap){
            let typeFields = {};
            let stageFields = {};
            let fMap = {};
            typeFields.traverse= masterObj.value;
            stageFields.traverse= masterObj.value;
            typeFields.list = [];
            stageFields.list = [];
            let res = fldMap;
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
                
                typeFields.list.push({'label':i, 'value':res[i]['name'], 'selected':(typeFields.selected === res[i]['name']), 'isReference':res[i]['isReference'], 'fieldApi': res[i]['fieldApi'], 'relationshipApi': res[i]['relationshipApi'], 'objectName': selectedObjName, 'valueType' : 'type', 'relationshipParentApi' : res[i]['relationshipParentApi']});
                typeFields.title = masterObj.label;
                stageFields.list.push({'label':i, 'value':res[i]['name'], 'selected':(stageFields.selected === res[i]['name']), 'isReference':res[i]['isReference'], 'fieldApi': res[i]['fieldApi'], 'relationshipApi': res[i]['relationshipApi'],'objectName': selectedObjName, 'valueType' : 'stage', 'relationshipParentApi' : res[i]['relationshipParentApi']});
                stageFields.title = masterObj.label;
            }
            
            console.log("fields list => ", JSON.stringify(typeFields));
            
            typeFields.map = fMap;
            stageFields.map = fMap;
            
            component.set("v.typeFields", typeFields);
            component.set("v.stageFields", stageFields);
        },({objectName : selectedObjName}));
    },
    
    
/*************************************************************************
Function Name: populateType
Description : Populate Type field values based on the selected object
**************************************************************************/
    populateType : function(component, typeVals) {
        var typelst = [];
        var i=0;
        typeVals.forEach(function(val){
            var item ={
                label 		: val.custom,
                value 		: val.custom,
                index 		: i,
            }
            typelst.push(item);
            i++
        });
        component.set('v.typeOptions',typelst);
        component.set('v.tempTypeOptions',typelst);
        console.log('typeList '+JSON.stringify(typelst));
    },
    
    
/*************************************************************************
Function Name: populateStage
Description : Populate Type field values based on the selected object
**************************************************************************/
     populateStage : function(component, stageVals) {
         var stagelst = [];
         var i=0
         stageVals.forEach(function(val){
             var item ={
                 label 		: val.custom,
                 value 		: val.custom,
                 index 		: i,
             }
             stagelst.push(item);
             i++
         });
         component.set('v.stageOptions',stagelst);
         component.set('v.tempStageOptions',stagelst);
         console.log('stageList '+JSON.stringify(stagelst));
    },
    
/*************************************************************************
Function Name: populateTotValue
Description : Opoulate all the other entry fields for the selected object
**************************************************************************/
    populateTotValue : function(component, totVals ) {
        /*let numberFields = {};
        numberFields.list = [];
        for(let i in res){
            console.log('number i val '+i);
            numberFields.list.push({'label':i, 'value':res[i]['name'], 'selected':(typeFields.selected === res[i]['name']), 'isReference':res[i]['isReference'], 'fieldApi': res[i]['fieldApi'], 'relationshipApi': res[i]['relationshipApi']});
        }*/
        var totlst = [];
        var i=0
        totVals.forEach(function(val){
            var item ={
                label : val.customLabel,
                value : val.custom,
                fieldType : val.fieldType,
                objectName : val.objectName,
                parentRelApi : val.parentRelApi,
                index : i
            }
            totlst.push(item);
            i++
        });
        component.set('v.otherFieldsTypes',totlst);
        console.log('totList '+JSON.stringify(totlst));
    },
    
/*************************************************************************
Function Name: showParentLookupModal
Description : Show modal window by removing the hide classs specific to
				Field mapping
**************************************************************************/
    showParentLookupModal : function(component, valueType) {
        console.log('Entering Modal ');
        if(valueType == 'type'){
            $A.util.removeClass(component.find("lookupParentModalType"),"slds-hide");
        }else if(valueType == 'stage'){
            $A.util.removeClass(component.find("lookupParentModalStage"),"slds-hide");
        }else if(valueType == 'totValueField'){
            $A.util.removeClass(component.find("lookupParentModaltotValueField"),"slds-hide");
        }else if(valueType == 'closedDateFields'){
            $A.util.removeClass(component.find("lookupParentModalclosedDateFields"),"slds-hide");
        }else if(valueType == 'grossFields'){
            $A.util.removeClass(component.find("lookupParentModalgrossFields"),"slds-hide");
        }else if(valueType == 'netFields'){
            $A.util.removeClass(component.find("lookupParentModalnetFields"),"slds-hide");
        }else if(valueType == 'retainerFields'){
            $A.util.removeClass(component.find("lookupParentModalretainerFields"),"slds-hide");
        }else if(valueType == 'dollarFeeFields'){
            $A.util.removeClass(component.find("lookupParentModaldollarFeeFields"),"slds-hide");
        }else if(valueType == 'pctFeeFields'){
            $A.util.removeClass(component.find("lookupParentModalpctFeeFields"),"slds-hide");
        }else if(valueType == 'caseNameFields'){
            $A.util.removeClass(component.find("lookupParentModalcaseNameFields"),"slds-hide");
        }else if(valueType == 'venueFields'){
            $A.util.removeClass(component.find("lookupParentModalvenueFields"),"slds-hide");
        }else if(valueType == 'caseIndexFields'){
            $A.util.removeClass(component.find("lookupParentModalcaseIndexFields"),"slds-hide");
        }else{
            $A.util.removeClass(component.find("lookupParentModal"),"slds-hide");
        }
        
    },
    
    
/*************************************************************************
Function Name: hideParentLookupModal
Description : Hide the Lookup modals once the value for the field is being selected
**************************************************************************/
    hideParentLookupModal : function(component, valueType) {
        //component.set("v.parentFields",{});
        //component.find("ESQ_LookupObjectFields").clearParentLookups();
        if(valueType =='type'){
            $A.util.addClass(component.find("lookupParentModalType"),"slds-hide");
        }else if(valueType =='stage'){
            $A.util.addClass(component.find("lookupParentModalStage"),"slds-hide");
        }else if(valueType == 'totValueField'){
            $A.util.addClass(component.find("lookupParentModaltotValueField"),"slds-hide");
        }else if(valueType == 'closedDateFields'){
            $A.util.addClass(component.find("lookupParentModalclosedDateFields"),"slds-hide");
        }else if(valueType == 'grossFields'){
            $A.util.addClass(component.find("lookupParentModalgrossFields"),"slds-hide");
        }else if(valueType == 'netFields'){
            $A.util.addClass(component.find("lookupParentModalnetFields"),"slds-hide");
        }else if(valueType == 'retainerFields'){
            $A.util.addClass(component.find("lookupParentModalretainerFields"),"slds-hide");
        }else if(valueType == 'dollarFeeFields'){
            $A.util.addClass(component.find("lookupParentModaldollarFeeFields"),"slds-hide");
        }else if(valueType == 'pctFeeFields'){
            $A.util.addClass(component.find("lookupParentModalpctFeeFields"),"slds-hide");
        }else if(valueType == 'caseNameFields'){
            $A.util.addClass(component.find("lookupParentModalcaseNameFields"),"slds-hide");
        }else if(valueType == 'venueFields'){
            $A.util.addClass(component.find("lookupParentModalvenueFields"),"slds-hide");
        }else if(valueType == 'caseIndexFields'){
            $A.util.addClass(component.find("lookupParentModalcaseIndexFields"),"slds-hide");
        }else{
            $A.util.addClass(component.find("lookupParentModalType"),"slds-hide");
            $A.util.addClass(component.find("lookupParentModalStage"),"slds-hide");
            $A.util.addClass(component.find("lookupParentModaltotValueField"),"slds-hide");
        }
        
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
Function Name: disableMasterConfirm
Description : TO disable the master Object selection entries
**************************************************************************/
    disableMasterConfirm : function(component){
        var source = 'masterObj';
        var disInput = component.find(source);
        //Disable the selected button
        disInput.set('v.disabled',true);
        var disFld = component.find(source+'Confirm');
        disFld.set('v.disabled',true);
        var disChangeBtn = component.find(source+'Change');
        disChangeBtn.set('v.disabled',false);
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