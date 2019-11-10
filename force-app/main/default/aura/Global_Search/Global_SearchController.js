({
	scriptsLoaded : function(component, event, helper) {
        console.log('Script Loaded....');
    },
    
    intialLoad : function(component, event, helper) {
        helper.callServer(component,"c.getObjectsMap",function(objMap){
            component.set('v.mSObjects', objMap.mOLabel);
            component.set('v.profiles',objMap.lstProfile);
            component.set('v.users',objMap.lstUser);
            window.setTimeout(function(){
                component.set('v.currentUser',objMap.currentUser);
                    console.log(JSON.stringify(objMap.currentUser));
                    component.set('v.currentProfile',objMap.currentProfile);
                    console.log(JSON.stringify(objMap.currentProfile));
                    component.find('userName').set("v.value", objMap.currentUser);
                    component.find('profileName').set("v.value", objMap.currentProfile);
            }, 500);
                
            console.log(JSON.stringify(objMap));
            helper.mapToList(component, event, helper,objMap.mOLabel,function(list){
                component.set("v.sObjects", list);
            });
        });
        /*
        //Getting Screen resolution
        var availHeight = window.screen.height;
        var setHeight = availHeight+'px';
        component.set('v.screenHeight',setHeight);
        console.log('availHeight '+availHeight+' window height '+window.screen.height)*/
    },
    
    onObjChange : function(component, event, helper) {
        var sObjKey = event.getSource().get('v.value');
        
        var fldSelect 	= component.find('fldName');
        var listBox 	= component.find('fldBox');
        var getRecBt 	= component.find('getRecBtn');
        var getsObjBt 	= component.find('getsObjDesBtn');
        
                    
        if(sObjKey != '-- Select --'){
            
            helper.callServer(component,"c.getFieldDetails",function(fldMap){
                
                helper.mapToList(component, event, helper,fldMap.mFLabel,function(list){
                    component.set('v.options', list);
                    console.log(JSON.stringify(list));
                });
                
                fldSelect.set	('v.disabled',	false);
                listBox.set		('v.disabled',	false);
                component.set	('v.mSObjFlds', fldMap);
                $A.util.removeClass(getRecBt,	'slds-hide');
                $A.util.removeClass(getsObjBt,	'slds-hide');
                component.set('v.allFields',fldMap.allFieldsName);
                component.set('v.tempAllFields',fldMap.allFieldsName);
                component.set('v.strdFields',undefined);
                component.set('v.custFields',undefined);
                component.set('v.selSObjName',sObjKey);
                
                
            },({ sObjName : sObjKey }));
        
        }else{
            var value = {label:'--Select--',value:'--Select--'};
            component.set('v.options', value);
            fldSelect.set('v.disabled',true);
        }
    },
    
    handleChange : function(component, event, helper) {
        var selectedValues = event.getParam('value');
        component.set('v.values',selectedValues);
        
        var getDesBt = component.find('getDesBtn');
        if(selectedValues.length > 0){
            $A.util.removeClass(getDesBt, 'slds-hide');
        }else{
            $A.util.addClass(getDesBt, 'slds-hide');
        }
    },
    
    handleCNdFldChange : function(component, event, helper) {
        var cndFldOper = component.find('ipCondition');
        var ipField = component.find('ipValue');
		var mFldMap = component.get('v.mSObjFlds');
        var keyVal 		= event.getSource().get('v.value');
        var dataType 	= mFldMap.mFType[keyVal];
        component.set('v.pkListVals',[]);
        var dsable		= false;
        var oprOptions = [{
            label :'=',
            value :'='
        },{
            label :'!=',
            value :'!='
        }];
        console.log('Data type '+dataType);
        var opts;
        
        if( keyVal == '--Select--' ){
            dsable = true;
        }else if( dataType == 'PICKLIST' ){
            component.set('v.pkListVals',mFldMap.mFPickValues[keyVal]);
        }else if( dataType == 'ID' ){
            
        }else if( dataType == 'REFERENCE' ){
            
        }else if( dataType == 'BOOLEAN' ){
            component.set('v.pkListVals',['true','false']);
        }else if( dataType == 'PHONE' ){
            
        }else if( dataType == 'ADDRESS' ){
            
        }else if( dataType == 'STRING' ){
            
        }else if( dataType == 'TEXTAREA' ){
            
        }else if( dataType == 'MULTIPICKLIST' ){
            
        }else if( dataType == 'PERCENT' ){
            var operator1 = {label :'>=',	value :'>='	};
            var operator2 = {label :'>',	value :'>'	};
            var operator3 = {label :'<=',	value :'<='	};
            var operator4 = {label :'<',	value :'<'	};
            oprOptions.push(operator1);
            oprOptions.push(operator2);
            oprOptions.push(operator3);
            oprOptions.push(operator4);
            
        }else if( dataType == 'URL' ){
            
        }else if( dataType == 'LOCATION' ){
            
        }else if( dataType == 'CURRENCY' ){
            var operator1 = {label :'>=',	value :'>='	};
            var operator2 = {label :'>',	value :'>'	};
            var operator3 = {label :'<=',	value :'<='	};
            var operator4 = {label :'<',	value :'<'	};
            oprOptions.push(operator1);
            oprOptions.push(operator2);
            oprOptions.push(operator3);
            oprOptions.push(operator4);
            
        }else if( dataType == 'EMAIL' ){
            
        }else if( dataType == 'CALCULATED' ){
            
        }else if( dataType == 'DATE' ){
            var ipField = component.find('ipValue');
            ipField.set('v.type','date');
        }
        
        component.set('v.cndOperts',oprOptions);
        cndFldOper.set('v.disabled',dsable);
    },
    
    handleGetRecords : function(component, event, helper) {
        var sObjectName = component.find('sObjName').get('v.value');
        
        //List of Fields To be Queried
        var fldsToQuery = component.get('v.values');
        
        //Condition for the Query
        var queryCondition = null;
        
        //Record Limit
        var recordLimit = null;
        
        //Setting Where condition
        var fieldName		= component.find('fldName').get('v.value');
        var condition		= component.find('ipCondition').get('v.value');
        var conditionPicklist 	= component.find('pklstVals');
        var conditionInput	 	= component.find('ipValue');
        var conditionValue1 	= null;
        var conditionValue2		= null;
        if(conditionPicklist != null){var conditionValue1		= conditionPicklist.get('v.value');	}
        if(conditionInput	 != null){var conditionValue2		= conditionInput.get('v.value');	}
        
        console.log('fieldName '+fieldName+' condition '+condition+' value '+conditionValue1+' value2 '+conditionValue2);
        if(fieldName != '--Select--' && fieldName != '' && condition != '' ){
            var cnVal;
            if(conditionValue1 != null){
                var cnVal = conditionValue1;
            }else if(conditionValue2 != null){
                var cnVal = conditionValue2;
            }
            if(cnVal != null){
            	queryCondition = fieldName+' '+condition+' '+cnVal;    
            }
        }
        
        console.log('fieldName '+fieldName+' condition '+condition+' value '+conditionValue1+' value2 '+conditionValue2+'\n queryCondition'+queryCondition);
        console.log('65');
        var recordLimit = null;
        var limit = component.find('limit').get('v.value');
        if(limit != null && limit != ''){
            recordLimit = limit;
        }
        console.log('71');
        
        var sortType = null;
        var sortTypeVal  = component.find('sordCnd').get('v.value');
        var sortFld   = component.find('sortByfld').get('v.value');
        if(sortFld != null && sortFld != '' && sortFld != '--Selected--'){
            sortType = sortTypeVal+' '+sortFld;
        }
        console.log('78 '+ sortType);
        var srtOrder = null;
        var sortOrderVal = component.find('sordOrd').get('v.value');
        if(sortFld != null && sortFld != '' && sortFld != 'ASC'){
            srtOrder =  sortOrderVal;
        }
        console.log('84');
        
        
        console.log('88 '+ sortType);
        helper.callServer(component,"c.getRecords",function(wrpFieldsRecords){
            component.set('v.records',wrpFieldsRecords);
            setTimeout(function(){ 
                $('#tableId').DataTable();
                // add lightning class to search filter field with some bottom margin..  
                $('div.dataTables_filter input').addClass('slds-input');
                $('div.dataTables_filter input').css("marginBottom", "10px");
            },500);
        },({ sObjName : sObjectName, fieldNames : fldsToQuery , fldCondition : queryCondition, sortBy : sortType, recLimit : recordLimit, sortOrder : srtOrder }));
    },
    
    handleGetFldDescribe : function(component, event, helper) {
        var sObjectName = component.find('sObjName').get('v.value');
        /*
        var fldsToQuery = component.get('v.values');
        if(fldsToQuery.length > 1){
            helper.callServer(component,"c.getFieldDescribe",function(result){
                component.set('v.feildDescribe',result);
                console.log('records received '+ JSON.stringify(result) );
            },({ sObjName : sObjectName, fldsD : fldsToQuery }));
            */
            helper.callServer(component,"c.fieldSchema",function(result){
                component.set('v.fldDescription',result);
                console.log('records received '+ JSON.stringify(result) );
            },({ sObjName : sObjectName}));
    },
    
    handleGetSObjDescribe : function(component, event, helper) {
        var mFldDes = component.get('v.mSObjFlds');
        var stdFields =[];
        var cusFields =[];
        for(var fldName in mFldDes.mFLabel){
            console.log('fldName :'+fldName);
            if(fldName.indexOf('__c')>=0){
                cusFields.push({
                    value : fldName,
                    label : mFldDes.mFLabel[fldName]
                });
            }else{
                stdFields.push({
                    value : fldName,
                    label : mFldDes.mFLabel[fldName]
                });
            }
        }
        //stdFields.sort();
        //cusFields.sort();
        console.log('stdFields : '+stdFields+'\ncusFields : '+cusFields);
        
        component.set('v.strdFields',stdFields);
        component.set('v.custFields',cusFields);
    },
    
    
    onFieldChange : function(component, event, helper) {
        
    },
    
    /*handleActiveTab :  function(component, event, helper) {
        setTimeout(function(){
            var tabKey =  event.getSource().get('v.class'); 
            var tableId = tabKey+' dTable';
            var Mfields = component.get('v.fldDescription');
            var fldTitle = ['Name', 'Label', 'Field type', 'Data type', 'Default value', 'Is Lookup', 'Non - mandatory', 'Updatable', 'Relationship Name', 'Writable', 'Cutom field', 'Unique value', 'Delete Restricted'];
            //Array of Map values
            var fldSeps = Mfields[tabKey];
            helper.tableCreation(component, event, helper, tableId, fldTitle, fldSeps);
            
        }, 100);
    },*/
    
    hideEditor : function(component, event, helper) {
        var btn = event.getSource();
        var editor = component.find('editorSection');
        $A.util.addClass(editor,'slds-hide');
        var dataV  = component.find('dataSection');
        dataV.set('v.size','12');
        var viewer = component.find('rightBtn');
        var hider  = component.find('leftBtn');
        $A.util.removeClass(viewer,'slds-hide');
        $A.util.addClass(hider,'slds-hide');
    },
    
    viewEditor : function(component, event, helper) {
        var btn = event.getSource();
        var editor = component.find('editorSection');
        $A.util.removeClass(editor,'slds-hide');
        var dataV  = component.find('dataSection');
        dataV.set('v.size','9');
        var viewer = component.find('rightBtn');
        var hider  = component.find('leftBtn');
        $A.util.addClass(viewer,'slds-hide');
        $A.util.removeClass(hider,'slds-hide');
    },
    
    expandEditor : function(component, event, helper) {
        var editor = component.find('editorSection');
        editor.set('v.size','4');
        var dataV  = component.find('dataSection');
        dataV.set('v.size','8');
    },
    
    shrinkEditor : function(component, event, helper) {
        var editor = component.find('editorSection');
        editor.set('v.size','3');
        var dataV  = component.find('dataSection');
        dataV.set('v.size','9');
    },
    
    handleFieldNavigation : function(component, event, helper) {
        helper.fieldSelections(component,event,helper,'fldTable');
    },
    
    handleFieldSelection : function(component, event, helper) {
        helper.fieldSelections(component,event,helper,'fldTable2');
    },
    
    
    getVal :  function(component, event, helper) {
    	var x = event.getSource();var av = component.find('ipCondition').get('v.value');
        console.log('x '+x.get('v.value'));
        
        console.log('find '+av);
    },
    
    filterFields : function(component, event, helper) {
        let value = event.getParam('value');
        let allFields = component.get('v.allFields');
        let templist = [];
        allFields.forEach(function (eachField) {
            if(eachField.includes(value)){
                templist.push(eachField);
            }
        });
        console.log(templist);
        component.set('v.tempAllFields',templist);
    }
    
})