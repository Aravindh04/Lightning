({
    
    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Controller
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping
    @ Language used			: Javascript
    @ No. of Listeners		: 60 Approx
    @ Extended to others	: No
    @ Cache enabled			: No
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
    
/*************************************************************************
Function Name: doInit
Description : Initial Load action, executed without user trigger
**************************************************************************/
	doInit : function(component, event, helper) {
        // Get the standard options for case type and case stage
        component.set('v.stdOptions', helper.stdOptions());
        
        //call the method from the class, get the return type and Store in the List of available objects
        helper.callServer(component,"c.getObjectsMap",function(objMap){
            component.set('v.mSObjects', objMap);
            helper.mapToList(component, event, helper,objMap,function(list){
                component.set("v.sObjects", list);
            });
            helper.getMappings(component,event,helper);
        });
        
        //Check for existing template and Map the fields accordingly
        //Check each return value is null or empty and map with the actual or required attribute
        helper.callServer(component,"c.getMappings",function(template){
            if(template != null){
                console.log('values');
                component.set('v.selectMasterObject', JSON.parse(template.Master_Object__c));
                var caseType, caseStage, otherList;
                if(helper.isNotBlank(template.Case_Type__c)){ caseType = JSON.parse(template.Case_Type__c);}
                if(helper.isNotBlank(template.Stage__c)){  caseStage = JSON.parse(template.Stage__c);}
                if(helper.isNotBlank(template.All_List__c)){ otherList = JSON.parse(template.All_List__c);}
                if(helper.isNotBlank(otherList.Single_Event)){component.set('v.singleEventFields', otherList.Single_Event);}
                
                if(helper.isNotBlank(otherList.Mass_Tort)){component.set('v.massTortFields', otherList.Mass_Tort);}
                
                if(helper.isNotBlank(otherList.Class_Action)){component.set('v.classActionFields', otherList.Class_Action);}
                
                if(helper.isNotBlank(otherList.Stage_A)){
                	component.set('v.stageAFields', otherList.Stage_A);    
                }
                
                if(helper.isNotBlank(otherList.Stage_B)){component.set('v.stageBFields', otherList.Stage_B);}
                
                if(helper.isNotBlank(otherList.Stage_C)){component.set('v.stageCFields',otherList.Stage_C );}
                
                if(helper.isNotBlank(otherList.Stage_D)){component.set('v.stageDFields',otherList.Stage_D );}
                
                if(helper.isNotBlank(otherList.Other_Field_Types)){component.set('v.otherFieldsTypes',otherList.Other_Field_Types );}
                
                if(helper.isNotBlank(otherList.Unmapped_Type_Options)){component.set('v.tempTypeOptions', otherList.Unmapped_Type_Options );}
                
                if(helper.isNotBlank(otherList.Unmapped_Stage_Options)){component.set('v.tempStageOptions', otherList.Unmapped_Stage_Options);}
                
                if(helper.isNotBlank(otherList.All_Available_TypeOptions)){component.set('v.typeOptions',otherList.All_Available_TypeOptions);}
                
                if(helper.isNotBlank(otherList.All_Available_StageOptions)){component.set('v.stageOptions',otherList.All_Available_StageOptions);}
                
                if(helper.isNotBlank(template.Type_Mappings__c)){component.set('v.typeFields ',JSON.parse(template.Type_Mappings__c));}
                
                if(helper.isNotBlank(template.Stage_Mappings__c)){component.set('v.stageFields',JSON.parse(template.Stage_Mappings__c));}
                
                if(helper.isNotBlank(template.Case_Name__c)){component.set('v.caseNameFields',JSON.parse(template.Case_Name__c));}
                
                if(helper.isNotBlank(template.Case_Index_Number__c)){component.set('v.caseIndexFields',JSON.parse(template.Case_Index_Number__c));}
                
                if(helper.isNotBlank(template.Venue__c)){component.set('v.venueFields',JSON.parse(template.Venue__c));}
                
                if(helper.isNotBlank(template.Estimated_Close_Date__c)){component.set('v.closedDateFields',JSON.parse(template.Estimated_Close_Date__c));}
                
                if(helper.isNotBlank(template.Total_Matter_Value__c)){component.set('v.totValueField',JSON.parse(template.Total_Matter_Value__c));}
                
                if(helper.isNotBlank(template.Retainer__c)){component.set('v.retainerFields',JSON.parse(template.Retainer__c));}
                
                if(helper.isNotBlank(template.Gross__c)){component.set('v.grossFields',JSON.parse(template.Gross__c));}
                
                if(helper.isNotBlank(template.Pct_Fee_Due_to_Others__c)){component.set('v.pctFeeFields',JSON.parse(template.Pct_Fee_Due_to_Others__c));}
                
                if(helper.isNotBlank(template.Dollar_Fee_Due_to_Others__c)){component.set('v.dollarFeeFields',JSON.parse(template.Dollar_Fee_Due_to_Others__c));}
                
                if(helper.isNotBlank(template.Dollar_Fee_Due_to_Others__c)){component.set('v.netFields',JSON.parse(template.Net__c));}
                
                //Navigating to all the tabs once for the controlle to find local Id
                component.set('v.selectTab','caseStageSel');
                component.set('v.selectTab','fieldMap');
                component.set('v.selectTab','caseTypeSel');
                
                //Timeout for the gather required Id's to load
                setTimeout(function(){
                    //disable confirm for all the existing values fetched from the server
                    var allDisVals = [];
                    allDisVals.push('masterObj');
                    if(helper.isNotBlank(component.get("v.typeFields.traverse"))){
                        allDisVals.push('caseTypeFld');
                        helper.mappingExists(component,'Type');
                    }
                    if(helper.isNotBlank(component.get("v.stageFields.traverse"))){
                        allDisVals.push('stageTypeFld'); 
                        helper.mappingExists(component,'Stage');
                    }
                    if(helper.isNotBlank(component.get("v.caseNameFields.traverse"))){
                        allDisVals.push('caseNameFld'); 
                    }
                    
                    if(helper.isNotBlank(component.get("v.caseIndexFields.traverse"))){
                        allDisVals.push('caseIndexFld'); 
                    }
                    
                    if(helper.isNotBlank(component.get("v.venueFields.traverse"))){
                        allDisVals.push('venueFld'); 
                    }
                    
                    if(helper.isNotBlank(component.get("v.closedDateFields.traverse"))){
                        allDisVals.push('closeDateFields'); 
                    }
                    if(helper.isNotBlank(component.get("v.totValueField.traverse"))){
                        allDisVals.push('totalValueFld'); 
                    }
                    if(helper.isNotBlank(component.get("v.retainerFields.traverse"))){
                        allDisVals.push('retainerFields'); 
                    }
                    if(helper.isNotBlank(component.get("v.dollarFeeFields.traverse"))){
                        allDisVals.push('dollarFeeFld'); 
                    }
                    if(helper.isNotBlank(component.get("v.pctFeeFields.traverse"))){
                        allDisVals.push('pctFeeFld'); 
                    }
                    if(helper.isNotBlank(component.get("v.netFields.traverse"))){
                        allDisVals.push('netFields'); 
                    }
                    if(allDisVals.length >= 0)
                        helper.disableExisting(component, allDisVals);
                    
                }, 500);
                
                
            }
        });
    },
    
/*************************************************************************
Function Name: confirmOppSelction
Description : Confirm Object selection, reset all the values
**************************************************************************/
    confirmOppSelction :function(component, event, helper) {
        var source = event.getSource();
        if(source.get('v.disabled') == false){
            helper.confirm(component,event);//Disabling fields
            helper.resetAllValues(component);//Reset all values for the selected object
            helper.hideNaviationsItems(component);//Bring back the nav to null 
            helper.getPicklistFieldsLc(component,event,helper);//Get new FieldValues
            helper.getNumberFieldsLc(component,event,helper);//Get new FieldValues    
        }
    },
    
/*************************************************************************
Function Name: handleObjSel
Description : Create and Call component to place holder for Object selection
**************************************************************************/
    handleObjSel : function(component, event, helper) {
        helper.callComponentToPlaceHolder(component, 'c:ObjectField_Mapping_sObject_Modal', 'objectSelectionModal', {sObjectsList : component.get('v.sObjects'), selSObject : component.get('v.selectMasterObject')});
    },
    
    
/*************************************************************************
Function Name: onMasObjChange
Description : Initial Load action, executed without user trigger
    **************************************************************************/
    onMasObjChange : function(component, event, helper) {
        //Navigating to all the tabs once for the controlle to find local Id
        component.set('v.selectTab','caseStageSel');
        component.set('v.selectTab','fieldMap');
        component.set('v.selectTab','caseTypeSel');
        var source = event.getSource();
        console.log(JSON.stringify(event.getParam("data")));
        component.set('v.selectMasterObject',event.getParam("data"));
        helper.disableMasterConfirm(component);//Disabling fields
        helper.resetAllDisabled(component);
        helper.resetAllValues(component);//Reset all values for the selected object
        helper.hideNaviationsItems(component);//Bring back the nav to null 
        helper.getPicklistFieldsLc(component,event,helper);//Get new FieldValues
        helper.getNumberFieldsLc(component,event,helper);//Get new FieldValues
    },
    
/*************************************************************************
Function Name: changeOppValue
Description : Modifying the master Object value, disable the other sections
**************************************************************************/
    changeOppValue :function(component, event, helper) {
        helper.change(component,event);
        var sObject = component.get('v.sObjects');
        var selObject = component.get('v.selectMasterObject');
        helper.callComponentToPlaceHolder(component, 'c:ObjectField_Mapping_sObject_Modal', 'objectSelectionModal', {sObjectsList : component.get('v.sObjects'), selSObject : selObject });
    },
    
/*************************************************************************
Function Name: confirmCaseType
Description : To confirm the case Stage selection and Disable for modification
**************************************************************************/
    confirmCaseType : function(component, event, helper) {
        helper.confirm(component,event);
        helper.resetTypeVal(component);
        var parentObject, fieldValue;
        if(helper.isNotBlank(component.get("v.typeFields.selectedParentValue"))){
            parentObject = component.get("v.typeFields.selectedParentObject");
            console.log('comp '+component.get("v.typeFields.selectedParentObject")+ 'value '+parentObject);
            fieldValue = component.get("v.typeFields.selectedParentValue");
        }
        else{
            parentObject = component.get("v.sObjects.selected");
            fieldValue = component.get("v.typeFields.selected");
        }
        console.log('select '+fieldValue+' from '+parentObject);
        helper.getPicklistOptionsLc(component,event,helper, fieldValue, 'allValues.typesMappings', parentObject);
    },
    
/*************************************************************************
Function Name: changeCaseType
Description : certains events to disable the component confirm, and view Modal 
				window for Field Selection
**************************************************************************/
    changeCaseType :function(component, event, helper) {
        if(!event.getSource().get('v.disabled')){
            var masObjVal = component.get('v.selectMasterObject.value');
            component.set('v.typeFields.traverse',masObjVal);
            var fldVal = component.find('caseTypeFld');
            if(helper.isNotBlank(fldVal.get('v.value'))){
                helper.showParentLookupModal(component,'type');
            }
            helper.change(component,event);
        }
    },
    
/*************************************************************************
Function Name: confirmCaseStage
Description : To confirm the case Stage selection and Disable for modification
**************************************************************************/
    confirmCaseStage : function(component, event, helper) {
        helper.confirm(component,event);
        helper.resetStageVal(component);
        helper.getNumberFieldsLc(component,event,helper);
        var parentObject, fieldValue;
        if(helper.isNotBlank(component.get("v.stageFields.selectedParentValue"))){
            parentObject = component.get("v.stageFields.selectedParentObject");
            fieldValue = component.get("v.stageFields.selectedParentValue");
        }
        else{
            parentObject = component.get("v.sObjects.selected");
            fieldValue = component.get("v.stageFields.selected");
        }
        helper.getPicklistOptionsLc(component,event,helper, fieldValue, 'allValues.stagesMappings', parentObject);
    },
    
/*************************************************************************
Function Name: changeCaseStage
Description : certains events to disable the component confirm, and view Modal 
				window for Field Selection
**************************************************************************/
    changeCaseStage :function(component, event, helper) {
        if(!event.getSource().get('v.disabled')){
            var masObjVal = component.get('v.selectMasterObject.value');
            component.set('v.stageFields.traverse',masObjVal);
            var fldVal = component.find('stageTypeFld');
            if(helper.isNotBlank(fldVal.get('v.value'))){
                helper.showParentLookupModal(component,'stage');
            }
            helper.change(component,event);
        }
    },
    
/*************************************************************************
Function Name: 'Confirm' button on Field mapping section Group of Similar functions
Description : Initial Load action, executed without user trigger
**************************************************************************/
    confirmTotalValue : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmCloseDate : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmGrossFields : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmNetFields : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmRetainerFields : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmDollarFeeFld : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmPctFeeFld : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmCaseNameFld : function(component, event, helper) {
        helper.confirm(component,event);
    },
    confirmCaseIndexFld : function(component, event, helper) {
        helper.confirm(component,event);
    },
	confirmVenueFld : function(component, event, helper) {
        helper.confirm(component,event);
    },
    
/*************************************************************************
Function Name: 'Change' button on Field mapping section Group of Similar functions
Description : Triggered by change button, disable the change and enable for 
				Field modification
**************************************************************************/
    changeTotalValue :function(component, event, helper) {
        helper.change(component,event);
    },
    changeCloseDate :function(component, event, helper) {
        helper.change(component,event);
    },
    changeGrossFields :function(component, event, helper) {
        helper.change(component,event);
    },
    changeNetFields :function(component, event, helper) {
        helper.change(component,event);
    },
    changeRetainerFields :function(component, event, helper) {
        helper.change(component,event);
    },
    changeDollarFeeFld :function(component, event, helper) {
        helper.change(component,event);
    },
    changePctFeeFld :function(component, event, helper) {
        helper.change(component,event);
    },
    changeCaseNameFld :function(component, event, helper) {
        helper.change(component,event);
    },
    changeCaseIndexFld :function(component, event, helper) {
        helper.change(component,event);
    },
    changeVenueFld :function(component, event, helper) {
        helper.change(component,event);
    },
    
/*************************************************************************
Function Name: handleStdTypeSelection
Description : Navigation item selection for case type
**************************************************************************/
    handleStdTypeSelection : function(component, event, helper) {
		var selection = event.getParam('name');
        console.log(selection)
        var flds = component.get('v.stdOptions.types');
        flds.forEach(function(fld){
            var dualList = component.find(fld.value);
            if(fld.value == selection){
                $A.util.removeClass(dualList,'slds-hide');
        	}else{
                $A.util.addClass(dualList,'slds-hide');
            }
        });
        $A.util.addClass(component.find('typeNull'),'slds-hide');
    },
    
/*************************************************************************
Function Name: handleStdStageSelection
Description : Navigation item selection for case stage
**************************************************************************/
    handleStdStageSelection : function(component, event, helper) {
        var selection = event.getParam('name');
        console.log(selection)
        var flds = component.get('v.stdOptions.stages');
        console.log(JSON.stringify(flds));
        flds.forEach(function(fld){
            console.log(fld.value+' ==  '+selection);
            var dualList = component.find(fld.value);
            if(fld.value == selection){
                $A.util.removeClass(dualList,'slds-hide');
        	}else{
                $A.util.addClass(dualList,'slds-hide');
            }
        });
        $A.util.addClass(component.find('stageNull'),'slds-hide');
    },
    
/*************************************************************************
Function Name: selectThisParentField
Description : Registered event triggered controller action for CaseType and
				and CaseStage mapping value selection
**************************************************************************/
    selectThisParentField : function(component, event, helper) {
        console.log(JSON.stringify(event.getParam("data")));
        helper.selectThisParentField(component, event, helper,event.getParam("data"));
    },
    
/*************************************************************************
Function Name: setOtherFields
Description : Registered event triggered controller action for FieldMapping
				mapping value selection
**************************************************************************/
    setOtherFields : function(component, event, helper) {
        var selFieldVals = event.getParam("data");
        var valSet = {
            label : selFieldVals.label,
            value : selFieldVals.value,
            objName : selFieldVals.objName,
            traverse : selFieldVals.traverse
        };
        component.set('v.'+selFieldVals.attributeName,valSet);
        helper.hideParentLookupModal(component,selFieldVals.attributeName);
        
    },
 
/*************************************************************************
Function Name: handleChange
Status : #Unused
Description : was used for the standard dual list box
**************************************************************************/
    handleChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        var flds = component.get('v.stdOptions');
        flds.types.forEach(function(fld){
            if(fld.value == selectedOptionValue){
                var index = flds.indexOf(fld);
                fld.splice(index, 1);
        	}else{
                $A.util.addClass(dualList,'slds-hide');
            }
        });
        
        component.set('v.stdOptions',flds);
        
    },

    
/*************************************************************************
Function Name: mapType
Description : Check there are no values pending to be mapped
				and Freeze all the selections
**************************************************************************/
    mapType : function(component, event, helper){
        var selection = event.getSource();
        var items = component.get('v.stdOptions.types');
        items.forEach(function(eachItem){
            var divElmt = component.find(eachItem.value);
            console.log('divElmt '+divElmt+' eachItem '+eachItem.value);
            $A.util.addClass(divElmt,'disable');
        });
        $A.util.addClass(selection, 'slds-hide');
        var unMap = component.find('unmapTypeId');
        $A.util.removeClass(unMap, 'slds-hide');
        var submit = component.find('submitType');
        submit.set('v.disabled',false);
        helper.showToast(component,event,helper,"Success",'Mapped successfully',"success");
        
    },
    
/*************************************************************************
Function Name: unmapType
Description : UnMap the Type field and enable duallist for modification
**************************************************************************/
    unmapType : function(component, event, helper){
        var selection = event.getSource();
        var items = component.get('v.stdOptions.types');
        items.forEach(function(eachItem){
            var divElmt = component.find(eachItem.value);
            $A.util.removeClass(divElmt, 'disable');
        });
        $A.util.addClass(selection, 'slds-hide');
        var map = component.find('mapTypeId');
        $A.util.removeClass(map, 'slds-hide');
        var submit = component.find('submitType');
        submit.set('v.disabled',true);
    },
    
/*************************************************************************
Function Name: mapStage
Description : Check there are no values pending to be mapped
				and Freeze all the selections
**************************************************************************/
    mapStage : function(component, event, helper){
        var selection = event.getSource();
        var items = component.get('v.stdOptions.stages');
        items.forEach(function(eachItem){
            var stg = eachItem.value;
            var divElmt = component.find(stg);
            $A.util.addClass(divElmt, 'disable');
        });
        $A.util.addClass(selection, 'slds-hide');
        var unMap = component.find('unmapStageId');
        $A.util.removeClass(unMap, 'slds-hide');
        var submit = component.find('submitStage');
        submit.set('v.disabled',false);
        helper.showToast(component,event,helper,"Success",'Mapped successfully',"success");
        
    },
    
/*************************************************************************
Function Name: unmapStage
Description : UnMap the Stage field and enable duallist for modification
**************************************************************************/
    unmapStage : function(component, event, helper){
        var selection = event.getSource();
        var items = component.get('v.stdOptions.stages');
        items.forEach(function(eachItem){
            var stg = eachItem.value;
            var divElmt = component.find(stg);
            $A.util.removeClass(divElmt, 'disable');
        });
        $A.util.addClass(selection, 'slds-hide');
        var map = component.find('mapStageId');
        $A.util.removeClass(map, 'slds-hide');
        var submit = component.find('submitStage');
        submit.set('v.disabled',true);
    },
    
/*************************************************************************
Function Name: unHide
Description : To view the modal boxes for all the field mapping
**************************************************************************/
    unHideTypeModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            component.set('v.typeFields.traverse',component.get('v.selectMasterObject.value'));
            helper.showParentLookupModal(component,'type');
        }
    },
    unHideStageModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            component.set('v.stageFields.traverse',component.get('v.selectMasterObject.value'));
            helper.showParentLookupModal(component,'stage');
        }
    },
    unHideTotValueModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'totValueField');
        }
    },
    unHideCloseDateModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'closedDateFields');
        }
    },
    unHideGrossFieldsModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'grossFields');
        }
    },
    unHideNetFieldsModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'netFields');
        }
    },
    unHidenRetainerFieldsModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'retainerFields');
        }
    },
    unHideDollarFeeFldModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'dollarFeeFields');
        }
    },
    unHidePctFeeFldModal : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'pctFeeFields');
        }
    },
    unHideCaseNameFld : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'caseNameFields');
        }
    },
    unHideCaseIndexFld : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'caseIndexFields');
        }
    },
    unHideVenueFld : function(component, event, helper){
        if(!event.getSource().get('v.disabled')){
            helper.showParentLookupModal(component,'venueFields');
        }
    },
    
/*************************************************************************
Function Name: typeFieldSelected
status : #Unused
Description : 
**************************************************************************/    
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
    
/*************************************************************************
Function Name: stageFieldSelected
status : #Unused
Description : 
**************************************************************************/    
    stageFieldSelected : function(component, event, helper) {
        let stageFields = component.get("v.stageFields");
        console.log('Selected '+stageFields.selected);
        if(stageFields.map[stageFields.selected]["isReference"]==='true'){
            helper.getParentPicklistFieldsLc(component, event, helper, stageFields.map[stageFields.selected]["fieldApi"],'stage');
            helper.showParentLookupModal(component,'stage');
        }
        else{
            component.set("v.stageFields.selectedParentValue", '');
            component.set("v.stageFields.selectedParentObject",'');
        }
    },
    
/*************************************************************************
Function Name: hideParentLookupModal
Description : To hide the modal on cancel or close
**************************************************************************/    
    hideParentLookupModalType : function(component, event, helper) {
        helper.hideParentLookupModal(component,'type');
    },
    hideParentLookupModalStage: function(component, event, helper) {
        helper.hideParentLookupModal(component,'stage');
    },
    hideParentLookupModalTotValue: function(component, event, helper) {
        helper.hideParentLookupModal(component,'totValueField');
    },
    hideParentLookupModalCloseDate: function(component, event, helper) {
        helper.hideParentLookupModal(component,'closedDateFields');
    },
    hideParentLookupModalGrossFields: function(component, event, helper) {
        helper.hideParentLookupModal(component,'grossFields');
    },
    hideParentLookupModalNetFields: function(component, event, helper) {
        helper.hideParentLookupModal(component,'netFields');
    },
    hideParentLookupModalRetainValue: function(component, event, helper) {
        helper.hideParentLookupModal(component,'retainerFields');
    },
    hideParentLookupModaldollarFeeFld: function(component, event, helper) {
        helper.hideParentLookupModal(component,'dollarFeeFields');
    },
    hideParentLookupModalpctFeeFld: function(component, event, helper) {
        helper.hideParentLookupModal(component,'pctFeeFields');
    },
    hideParentLookupModalcaseNameFld: function(component, event, helper) {
        helper.hideParentLookupModal(component,'caseNameFields');
    },
    hideParentLookupModalcaseIndexFld: function(component, event, helper) {
        helper.hideParentLookupModal(component,'caseIndexFields');
    },
    hideParentLookupModalvenueFld: function(component, event, helper) {
        helper.hideParentLookupModal(component,'venueFields');
    },
 
/*************************************************************************
Function Name: handleStageChange
Status : #Unsed
Description : Method Used for duallist box
**************************************************************************/  
    goBackOne : function(component, event, helper) {
        var activeTab = component.get('v.selectTab');
        if(activeTab == 'caseStageSel'){
            component.set('v.selectTab','caseTypeSel');
        }else{
            component.set('v.selectTab','caseStageSel');
        }
    },
    
/*************************************************************************
Function Name: handleStageChange
Status : #Unsed
Description : Method Used for duallist box
**************************************************************************/    
    handleStageChange : function(component, event, helper) {
        var selVals = event.getParam('value');
        var sourceId = event.getSource().getLocalId();
        var items = component.get('v.'+sourceId);
        console.log('souceInfo '+selVals[1]);
        var options = component.get('v.stageOptions');
        for(var i=0; i< options.length; i++){
            for(var j=0; j< selVals.length; j++){
                if(options[i].value === selVals[j]){
                    console.log('match : option '+options[i].value+'  source '+selVals[j]);
                    options.splice(i, 1);
                    items.push(selVals[j]);
                }
            }
        }
        component.set('v.'+sourceId,items);
        component.set('v.stageOptions',options);
    },       
    
/*************************************************************************
Function Name: getValIndex
Description : Get the selected values from the case type and stage mappings
				dual list and store in a temporary respective attributes
**************************************************************************/    
    getValIndex : function(component, event, helper) {
        var selVal = event.currentTarget.dataset.value;
        var indexPos = event.currentTarget.dataset.index;
        var selection = event.currentTarget.dataset.selection;
        var stdType = event.currentTarget.dataset.type;
        var checked = event.currentTarget.checked;
        var dataType = event.currentTarget.dataset.selType;
        
        console.log(selVal+' '+checked+' '+indexPos+' '+stdType);
        if(selection == 'selected'){
            stdType = stdType+'Selected';
        }
        var selectedItems = component.get('v.'+stdType);
        if(checked){
            selectedItems.push({position : indexPos,value : selVal});
        }else{
            var i=0;
            selectedItems.forEach(function(elemnt){
                if(elemnt.value == selVal){
                    selectedItems.splice(i,1);
                }
                i++;
            });
        }
        component.set('v.'+stdType, selectedItems);
        console.log('items '+JSON.stringify(selectedItems));
    },
    
    
/*************************************************************************
Function Name: addToTypeList
Description : move the selected values from available to selected 
**************************************************************************/    
    addToTypeList : function(component, event, helper) {
        var souceAtt = event.getSource().get('v.class');
        var initialVal = component.get('v.'+souceAtt);
        console.log(JSON.stringify(initialVal));
        component.set('v.'+souceAtt,[]);
        var sourceVal = component.get('v.'+souceAtt+'Fields');
        var tempTypeOptions = component.get('v.tempTypeOptions');
        initialVal.forEach(function(element){
            console.log(element.position)
            var i = 0;
            tempTypeOptions.forEach(function(value){
                if(element.position == value.index){
                    tempTypeOptions.splice(i,1);
                }
                i++;
                console.log(i+'  '+element.value+' '+element.label);
            });
            sourceVal.push({position : element.position,value : element.value});
        });
        component.set('v.'+souceAtt+'Fields',sourceVal);
        component.set('v.tempTypeOptions',tempTypeOptions);
        
    },
    
/*************************************************************************
Function Name: addToStageList
Description :  move the selected values from available to selected 
**************************************************************************/    
    addToStageList : function(component, event, helper) {
        var souceAtt = event.getSource().get('v.class');
        var initialVal = component.get('v.'+souceAtt);
        component.set('v.'+souceAtt,[]);
        var sourceVal = component.get('v.'+souceAtt+'Fields');
        var tempTypeOptions = component.get('v.tempStageOptions');
        initialVal.forEach(function(element){
            console.log(element.position)
            var i = 0;
            tempTypeOptions.forEach(function(value){
                if(element.position == value.index){
                    tempTypeOptions.splice(i,1);
                }
                i++;
                console.log(i+'  '+element.value+' '+element.label);
            });
            sourceVal.push({position : element.position,value : element.value});
        });
        component.set('v.'+souceAtt+'Fields',sourceVal);
        component.set('v.tempStageOptions',tempTypeOptions);
        
    },
    
/*************************************************************************
Function Name: removeFromList
Description : remove the selected values from the selected to the available options
**************************************************************************/    
    removeFromList : function(component, event, helper) {
        var souceAtt = event.getSource().get('v.class');
        var sourceType = event.getSource().get('v.value');
        console.log('sourceType '+sourceType);
        var tempTypeOptions = component.get('v.temp'+sourceType+'Options');
        var listVals =component.get('v.'+souceAtt+'Fields');
        var selVlas = component.get('v.'+souceAtt+'Selected');
        component.set('v.'+souceAtt+'Selected',[]);
        selVlas.forEach(function(element){
            console.log(element.position+' '+element.value);
            var i = 0;
            listVals.forEach(function(value){
                if(element.position == value.position){
                    listVals.splice(i,1);
                }
                i++;
            });
            tempTypeOptions.push({
                 label : element.value,
                 value : element.value,
                 index : element.position
             });
            
        });
        component.set('v.'+souceAtt+'Fields', listVals);
        component.set('v.temp'+sourceType+'Options',tempTypeOptions);
        
    },
    
/*************************************************************************
Function Name: submitTypeAction
Description : case Type submission action when user maps all the other fields
			 	calls the methos, feeds the data in desired format and 
                populates the Mapping template
**************************************************************************/    
    submitTypeAction : function(component, event, helper){
        
        var Master_Object = component.get('v.selectMasterObject');
        
        var typeFields = component.get('v.typeFields');
        var stageFields = component.get('v.stageFields');
        
        var caseType = component.get('v.typeFields.traverse')
        
        var otherList = {};
        
        //Case Type Fields
        otherList.Single_Event = component.get('v.singleEventFields');
        otherList.Mass_Tort = component.get('v.massTortFields');
        otherList.Class_Action = component.get('v.classActionFields');
        otherList.Unmapped_Type_Options = component.get('v.tempTypeOptions');
        otherList.All_Available_TypeOptions = component.get('v.typeOptions');
        otherList.Other_Field_Types = component.get('v.otherFieldsTypes');
        
        helper.callServer(component,"c.storeTypeValues",function(SubmitStatus){
            if(SubmitStatus == 'SUCCESS'){
                //Switch to next tab
                var currentTab = component.get('v.selectTab');
                if(currentTab == 'caseTypeSel'){
                    component.set('v.selectTab','caseStageSel');
                }else if(currentTab == 'caseStageSel'){
                    component.set('v.selectTab','fieldMap');
                }    
                helper.showToast(component,event,helper,"Success!","Case Type mappings are saved successfully!","success");
            }
            else{
                helper.showToast(component,event,helper,"ERROR",SubmitStatus,"error");
            }
        },({
            masterObject : JSON.stringify(Master_Object),
            caseType : JSON.stringify(caseType),
            TypeMappings : JSON.stringify(typeFields),
            otherList : JSON.stringify(otherList),
            stageFields : JSON.stringify(stageFields),
            typeFields : JSON.stringify(typeFields)
        }));
    },
    
    /*submitStageAction : function(component, event, helper){
        var Master_Object = component.get('v.selectMasterObject');
        var typeFields = component.get('v.typeFields');
        var stageFields = component.get('v.stageFields');
        
        var caseStage = component.get('v.stageFields.traverse');
        
        var otherList = {};
        //Case Type Fields
        //Case Stage Fields
        otherList.Stage_A = component.get('v.stageAFields');
        otherList.Stage_B = component.get('v.stageBFields');
        otherList.Stage_C = component.get('v.stageCFields');
        otherList.Stage_D = component.get('v.stageDFields');
        otherList.Unmapped_Stage_Options = component.get('v.tempStageOptions');
        otherList.All_Available_StageOptions = component.get('v.stageOptions');
        
        helper.callServer(component,"c.storeStageValues",function(SubmitStatus){
            if(SubmitStatus == 'SUCCESS'){
                var currentTab = component.get('v.selectTab');
                if(currentTab == 'caseTypeSel'){
                    component.set('v.selectTab','caseStageSel');
                }else if(currentTab == 'caseStageSel'){
                    component.set('v.selectTab','fieldMap');
                }    
                helper.showToast(component,event,helper,"Success!","Case Stage mappings are saved successfully!","success");
            }
            else{
                helper.showToast(component,event,helper,"ERROR",SubmitStatus,"error");
            }
        },({
            masterObject : JSON.stringify(Master_Object),
            CaseStage : JSON.stringify(caseStage),
            stageMappings : JSON.stringify(stageFields),
            otherList : JSON.stringify(otherList),
            stageFields : JSON.stringify(stageFields),
            typeFields : JSON.stringify(typeFields)
        }));        
    },*/
    
    
/*************************************************************************
Function Name: submitStageAction
Description : Stage submission action when user maps all the other fields
			 	calls the methos, feeds the data in desired format and 
                populates the Mapping template
**************************************************************************/    
    submitStageAction : function(component, event, helper){
        var Master_Object = component.get('v.selectMasterObject');
        
        var typeFields = component.get('v.typeFields');
        var caseType = typeFields.traverse;
        /*caseType.Field_Mapping = {
            Object_Name 	:  typeFields.selectedParentObject,
            Field_Name		:  typeFields.selectedParentValue
        };*/
        
        
        var stageFields = component.get('v.stageFields');
        var caseStage = stageFields.traverse;
        /*caseStage.Field_Mapping = {
            Object_Name 	:  stageFields.selectedParentObject,
            Field_Name		:  stageFields.selectedParentValue
        };*/
        
        
        //Other mappings
        var otherList = {};
        //Case Type Fields
        otherList.Single_Event = component.get('v.singleEventFields');
        otherList.Mass_Tort = component.get('v.massTortFields');
        otherList.Class_Action = component.get('v.classActionFields');
        //Case Stage Fields
        otherList.Stage_A = component.get('v.stageAFields');
        otherList.Stage_B = component.get('v.stageBFields');
        otherList.Stage_C = component.get('v.stageCFields');
        otherList.Stage_D = component.get('v.stageDFields');
        
        otherList.Unmapped_Type_Options = component.get('v.tempTypeOptions');
        otherList.All_Available_TypeOptions = component.get('v.typeOptions');
        otherList.Unmapped_Stage_Options = component.get('v.tempStageOptions');
        otherList.All_Available_StageOptions = component.get('v.stageOptions');
        otherList.Other_Field_Types = component.get('v.otherFieldsTypes');
        
        helper.callServer(component,"c.storeStageValues",function(SubmitStatus){
            //if template creation successful
            if(SubmitStatus == 'SUCCESS'){
                var currentTab = component.get('v.selectTab');
                if(currentTab == 'caseStageSel'){
                    component.set('v.selectTab','fieldMap');
                }  
                helper.showToast(component,event,helper,"Success!","Mappings are saved successfully!","success");
                //$A.get('e.force:refreshView').fire();
                //Disable the subit stage button
                var source = event.getSource();
                source.set('v.disabled',true);
            }else{
                helper.showToast(component,event,helper,"Error",SubmitStatus,"error");
            }
        },({
            masterObject : JSON.stringify(Master_Object),
            caseType : JSON.stringify(caseType),
            caseStage : JSON.stringify(caseStage),
            allLists : JSON.stringify(otherList),
            typeMappings : JSON.stringify(typeFields),
            stageMappings : JSON.stringify(stageFields),
        }));
    },
    
/*************************************************************************
Function Name: SubmitAll
Description : Final submission action when user maps all the other fields
			 	calls the methos, feeds the data in desired format and 
                populates the Mapping template
**************************************************************************/    
    SubmitAll : function(component, event, helper){
        
        var Master_Object = component.get('v.selectMasterObject');
        
        var typeFields = component.get('v.typeFields');
        var caseType = typeFields.traverse;
        /*caseType.Field_Mapping = {
            Object_Name 	:  typeFields.selectedParentObject,
            Field_Name		:  typeFields.selectedParentValue
        };*/
        
        
        var stageFields = component.get('v.stageFields');
        var caseStage = stageFields.traverse;
        /*caseStage.Field_Mapping = {
            Object_Name 	:  stageFields.selectedParentObject,
            Field_Name		:  stageFields.selectedParentValue
        };*/
        
        
        var OtherFieldMappings = {};
        OtherFieldMappings['Case_Name']	= JSON.stringify(component.get('v.caseNameFields'));
        OtherFieldMappings['Case_Index'] = JSON.stringify(component.get('v.caseIndexFields'));
        OtherFieldMappings['Venue'] =  JSON.stringify(component.get('v.venueFields'));
        OtherFieldMappings['Estimated_Closed_Date']= JSON.stringify(component.get('v.closedDateFields'));
        OtherFieldMappings['Total_Matter_Value']= JSON.stringify(component.get('v.totValueField'));
        OtherFieldMappings['Retainer']= JSON.stringify(component.get('v.retainerFields'));
        OtherFieldMappings['Gross']= JSON.stringify(component.get('v.grossFields'));
        OtherFieldMappings['Percent_Fee']= JSON.stringify(component.get('v.pctFeeFields'));
        OtherFieldMappings['Dollar_Fee']= JSON.stringify(component.get('v.dollarFeeFields'));
        OtherFieldMappings['Net']= JSON.stringify(component.get('v.netFields'));
        
        console.log('OtherFieldMappings '+JSON.stringify(OtherFieldMappings));
        
        //Other mappings
        var otherList = {};
		//Case Type Fields
        otherList.Single_Event = component.get('v.singleEventFields');
        otherList.Mass_Tort = component.get('v.massTortFields');
        otherList.Class_Action = component.get('v.classActionFields');
        //Case Stage Fields
        otherList.Stage_A = component.get('v.stageAFields');
        otherList.Stage_B = component.get('v.stageBFields');
        otherList.Stage_C = component.get('v.stageCFields');
        otherList.Stage_D = component.get('v.stageDFields');
        
        otherList.Unmapped_Type_Options = component.get('v.tempTypeOptions');
        otherList.All_Available_TypeOptions = component.get('v.typeOptions');
        otherList.Unmapped_Stage_Options = component.get('v.tempStageOptions');
        otherList.All_Available_StageOptions = component.get('v.stageOptions');
        otherList.Other_Field_Types = component.get('v.otherFieldsTypes');
        
        
        //find mehod, call server, push the values to method as params and et the respose and perform action
        helper.callServer(component,"c.storeMappings",function(SubmitStatus){
            // if the submission is successful and mapping template is created
            if(SubmitStatus == 'SUCCESS'){
                helper.showToast(component,event,helper,"Success!","Mappings are saved successfully!","success");
                //$A.get('e.force:refreshView').fire();
                var source = event.getSource();
                source.set('v.disabled',true);
            }else{//if the submission fails and template creation fails
                helper.showToast(component,event,helper,"Error",SubmitStatus,"error");
            }
            //below are the params for the desired method in sting and map formats
        },({
            masterObject : JSON.stringify(Master_Object),
            caseType : JSON.stringify(caseType),
            caseStage : JSON.stringify(caseStage),
            allLists : JSON.stringify(otherList),
            typeMappings : JSON.stringify(typeFields),
            stageMappings : JSON.stringify(stageFields),
            OtherFields : OtherFieldMappings
        }));
    },
    
})