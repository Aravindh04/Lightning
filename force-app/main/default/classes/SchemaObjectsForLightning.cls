public class SchemaObjectsForLightning {
    
    @AuraEnabled public static Map<String, Schema.SObjectType> scObjects {get;set;}
    
    public class wrapMasterDetails{
        @AuraEnabled Public Map<String, String> 	mOLabel 		{get;set;}
        @AuraEnabled Public List<Profile>			lstProfile		{get;set;}
        @AuraEnabled Public List<User>				lstUser			{get;set;}
        @AuraEnabled Public User					currentUser		{get;set;}
        @AuraEnabled Public Profile					currentProfile	{get;set;}
    }
    
    @AuraEnabled
    public static wrapMasterDetails getObjectsMap(){
        wrapMasterDetails wrpMasterData = new wrapMasterDetails();
        scObjects 		= Schema.getGlobalDescribe();
        system.debug('scObjects '+scObjects);
        List<String> objNames = new List<String>();
        List<String> sObjLabel = new List<String>();
        
        Map<String, String> mOLabel = new Map<String, String>();
        
        if(!scObjects.keySet().isEmpty()){
            for(String s : scObjects.keySet()){
                schema.DescribeSObjectResult objDes =  scObjects.get(s).getDescribe();
                if (objDes.isAccessible()){
                    objNames.add(s);
                    String oLabel = objDes.getLabel();
                    String oName = objDes.getName();
                    sObjLabel.add(oLabel);
                    mOLabel.put(oName, oLabel);
                }
            }
            objNames.sort();
        }
        
        
        for(String s : mOLabel.keySet()){
            system.debug(s+' '+mOLabel.get(s));
        }
        wrpMasterData.mOLabel 	 = mOLabel;
        wrpMasterData.lstProfile = new List<Profile>();
        wrpMasterData.lstProfile = [SELECT Id, Name FROM Profile LIMIT 10000];
        wrpMasterData.lstUser 	 = new List<User>();
        wrpMasterData.lstUser 	 = [SELECT Id, Name FROM User LIMIT 10000];
        wrpMasterData.currentUser	 = new User();
        wrpMasterData.currentUser	 = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        wrpMasterData.currentProfile = new Profile();
        wrpMasterData.currentProfile = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        
        return wrpMasterData;
    }
    
    @AuraEnabled
    public static Map<String, String> getFields(String sObjName){
        scObjects 		= Schema.getGlobalDescribe();
        Map<String, String> mFLabel =  new Map<String, String>();
        Map<String, Schema.SObjectField> mFields = new Map<String, Schema.SObjectField>();
        
        mFields = scObjects.get(sObjName).getDescribe().fields.getMap();
        
        if(!mFields.keySet().isEmpty()){
            for(String s : mFields.keySet()){
                String fldLabel = mFields.get(s).getDescribe().getLabel();
                String fldName 	= mFields.get(s).getDescribe().getName();
                mFLabel.put(fldName, fldLabel);
            }
        }
        
        return mFLabel;
    }
    
    @AuraEnabled
    public static wrapFieldsData getFieldDetails(String sObjName){
        wrapFieldsData fieldWrapper = new wrapFieldsData();
        
        scObjects 		= Schema.getGlobalDescribe();
        fieldWrapper.mFLabel 		=  new Map<String, String>();
        fieldWrapper.mFType 		=  new Map<String, String>();
        fieldWrapper.mFPickValues 	=  new Map<String, List<String>>();
        Map<String, Schema.SObjectField> mFields = new Map<String, Schema.SObjectField>();
        
        fieldWrapper.stdFields		= new List<String>();
        fieldWrapper.cusFields 		= new List<String>();
        fieldWrapper.allFieldsName  = new List<String>();
        
        mFields = scObjects.get(sObjName).getDescribe().fields.getMap();
        
        if(!mFields.keySet().isEmpty()){
            for(String s : mFields.keySet()){
                Schema.DescribeFieldResult TestField = mFields.get(s).getDescribe();
				String fldLabel = TestField.getLabel();
                String fldType 	= String.valueOf(TestField.getType());
                String fldName 	= TestField.getName();
                fieldWrapper.allFieldsName.add(fldName);
                if(fldType == 'PICKLIST'){
                    List<String> values = new List<String>();
                    List<Schema.PicklistEntry> scPicklstValues = TestField.getPicklistValues();
                    if(!scPicklstValues.isEmpty()){
                        for(Schema.PicklistEntry val : scPicklstValues){
                            values.add(String.valueOf(val.getValue()));
                        }
                        if(!values.isEmpty()){
                            fieldWrapper.mFPickValues.put(fldName, values);
                        }
                    }
                }
                
                //Creating map of fld API and field API
                fieldWrapper.mFLabel.put(fldName, fldLabel);
                fieldWrapper.mFType.put(fldName, fldType);
                if(fldName.Contains('__c') || fldName.Contains('__C') ){
                    fieldWrapper.cusFields.add(fldName);
                    fieldWrapper.cusFields.sort();
                }else{
                    fieldWrapper.stdFields.add(fldName);
                    fieldWrapper.stdFields.sort();
                }
            }
        }
        
        return fieldWrapper;
    }
    
    
    @AuraEnabled
    public static wrapObjectsFeildsValues getRecords(String sObjName, List<String> fieldNames, String fldCondition, String sortBy, String sortOrder, Integer recLimit){
        wrapObjectsFeildsValues wrpCont = new wrapObjectsFeildsValues();
        List<sObject> recordsList = new List<sObject>();
        
        scObjects 		= Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> mFields = new Map<String, Schema.SObjectField>();
        mFields = scObjects.get(sObjName).getDescribe().fields.getMap();
        
        //fieldReferencing 
        system.debug('fieldNames before : '+fieldNames);
        List<String> fldsToQuery = new List<String>();
        for(String eachFld : fieldNames){
            if(eachFld.Contains('__c') || eachFld.Contains('__C') ){
                DescribeFieldResult fldDetails =  mFields.get(eachFld).getDescribe();
                Schema.DisplayType fldType =fldDetails.getType();
                
                String fieldType = String.valueOf(fldType);
                if(fieldType.toUpperCase() == 'REFERENCE'){
                    String refFldName;
                    if(fldDetails.isCustom()){
                        List<String> parts = eachFld.split('__');
                        refFldName = parts[0]+'__r.Name';    
                    }else{
                        refFldName += '__r.Name';
                    }
                    fldsToQuery.add(refFldName);
                }else{
                    fldsToQuery.add(eachFld);
                }
            }else{
                fldsToQuery.add(eachFld);
            }
        }
        
        if(sObjName != null){
            String cusQuery = 'SELECT Id';
            if(!fldsToQuery.isEmpty()){
                for(String fld : fldsToQuery){
                    cusQuery = cusQuery + ', '+fld;
                }
            }
            
            cusQuery = cusQuery + ' FROM '+sObjName;
            System.debug('condition '+fldCondition);
            if(fldCondition != null && fldCondition != ''){
                cusQuery = cusQuery+' WHERE '+ fldCondition;            
            }
            
            System.debug('sortBy '+sortBy);
            if(sortBy != null && sortBy != ''){
                cusQuery = cusQuery +' '+sortBy;
            }
            
            if(sortOrder != null && sortOrder != 'ASC'){
                    cusQuery = cusQuery +' DESC ';
            }
            
            System.debug('recLimit '+recLimit);
            if(recLimit != null){
                cusQuery = cusQuery +' LIMIT '+recLimit;
            }
             System.debug('cusQuery '+ cusQuery);
            try{
                recordsList = Database.query(cusQuery); 
            }catch(Exception ex){
                System.debug('cusQuery '+ cusQuery);
            }
        }
        
        wrpCont.sObjList  	= recordsList ;
        wrpCont.fieldNames 	= fldsToQuery ;
        return wrpCont;
    }
    
    @AuraEnabled
    public static List<String> getFieldDescribe(String sObjName, List<string> fldsD){
        scObjects 		= Schema.getGlobalDescribe();
        List<String> fldDes = new List<string>();
        Map<String, Schema.SObjectField> mFields = new Map<String, Schema.SObjectField>();
        mFields = scObjects.get(sObjName).getDescribe().fields.getMap();
        
        if(!fldsD.isEmpty()){
            for(String s : fldsD){
                Schema.DescribeFieldResult fieldDes = mFields.get(s).getDescribe();
                String fldLabel = ''+fieldDes;
                fldDes.add(fldLabel);
            }
        }
        
        return fldDes;
    }
    
    @AuraEnabled
    Public Static Map<String, List<String>> fieldSchema(String sObjName){
        //Mapping Fields with their Descriptions
        Map<String, List<String>> mFldDescribe = new Map<String, List<String>>();
        
        
        Map<String, Schema.SObjectField> mSObjFields = new Map<String, Schema.SObjectField>();
        mSObjFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        
        try{
            for(String fld : mSObjFields.keySet()){
                Schema.DescribeFieldResult fldDesc = mSObjFields.get(fld).getDescribe();
                List<String> fldDescription = new List<String>();
                fldDescription.add(String.valueOf(fldDesc.getName()));
                fldDescription.add(String.valueOf(fldDesc.getLabel()));
                fldDescription.add(String.valueOf(fldDesc.getType()));
                fldDescription.add(String.valueOf(fldDesc.getSoapType()));
                String defVal;		if(fldDesc.getDefaultValue() != null){  defVal = String.valueOf(fldDesc.getDefaultValue()); }else{ defVal = 'null'; }
                fldDescription.add(defVal);
                fldDescription.add(String.valueOf(fldDesc.isIdLookup()));
                fldDescription.add(String.valueOf(fldDesc.isNillable()));
                fldDescription.add(String.valueOf(fldDesc.isUpdateable()));
                String relationshipName;		if(String.valueOf(fldDesc.getRelationshipName()) != null){  relationshipName = String.valueOf(fldDesc.getRelationshipName()); }else{ relationshipName = 'Not applicable'; }
                fldDescription.add(relationshipName);
                if(String.valueOf(fldDesc.getType()).ToUpperCase() == 'REFERENCE'){
                    fldDescription.add(String.valueOf(fldDesc.getReferenceTo()[0].getDescribe().getName()));
                }else{
                    fldDescription.add('Not Applicable');
                }
                fldDescription.add(String.valueOf(fldDesc.isCreateable()));
                fldDescription.add(String.valueOf(fldDesc.isCustom()));
                fldDescription.add(String.valueOf(fldDesc.isUnique()));
                fldDescription.add(String.valueOf(fldDesc.isRestrictedDelete()));
                system.debug('defVal '+defVal+' getDefaultValue() '+fldDesc.getDefaultValue()+' String  '+String.valueOf(fldDesc.getDefaultValue()));
                mFldDescribe.put(fldDesc.getName(), fldDescription);
            }
        }catch(Exception ex){
            System.debug('fieldSchema failed with\nMessage : '+ex.getMessage()+'\nException type :'+ex.getTypeName()+'\nLine number :'+ex.getLineNumber()+'\nCauese :'+ex.getCause());
        }
        
        return mFldDescribe;
    }
    
    @AuraEnabled
    Public Static wrapObjectsData objectSchema(String sObjName){
        //Mapping Fields with their Descriptions
        wrapObjectsData mSObjDescribe = new wrapObjectsData();
        
        Schema.DescribeSObjectResult myObj = Schema.getGlobalDescribe().get(sObjName).getDescribe();
        
        List<Schema.ChildRelationship> ChildRelationship = myObj.getChildRelationships();
        Map<String, List<String>> 	mObjChildRels 	=  new Map<String,List<String>>();
        Map<String, String> 		mObjString		=  new Map<String, String>();
        
        for(Schema.ChildRelationship sc : ChildRelationship){
            String chldObjName = sc.getChildSObject().getDescribe().getName();
            if(sc.getRelationshipName() != null){
               	mObjChildRels.put(chldObjName, new List<String>());
                mObjChildRels.get(chldObjName).add(chldObjName);
                mObjChildRels.get(chldObjName).add(sc.getRelationshipName());
                mObjChildRels.get(chldObjName).add(String.valueOf(sc.getField()));
            }
        }
        Map<String,Schema.RecordTypeInfo> objRecTypeInfo = myObj.getRecordTypeInfosByName();
        Map<String, List<String>> recTypeInfo = new Map<String, List<String	>>();
        for(String s: objRecTypeInfo.keySet()){
            String recTName = objRecTypeInfo.get(s).getName();
            recTypeInfo.put(recTName , new List<String>());
			recTypeInfo.get(recTName).add(recTName);
            recTypeInfo.get(recTName).add(objRecTypeInfo.get(s).getDeveloperName());
            recTypeInfo.get(recTName).add(String.valueOf(objRecTypeInfo.get(s).getRecordTypeId()));
            recTypeInfo.get(recTName).add(String.valueOf(objRecTypeInfo.get(s).isActive()));
            recTypeInfo.get(recTName).add(String.valueOf(objRecTypeInfo.get(s).isMaster()));
        }
        //List<Schema.RecordTypeInfo> objRecTypeInfo = myObj.getRecordTypeInfos();
        
        Map<String, List<String>> objInfo = new Map<String, List<String>>();
        
        String objTypeInfo;			if(String.valueOf(myObj.getSobjectType()) 	!= null){ objTypeInfo 	= String.valueOf(myObj.getSobjectType());	}else{ objTypeInfo 	= 'null';}
        String objKeyPre; 			if(String.valueOf(myObj.getKeyPrefix()) 	!= null){ objKeyPre		= String.valueOf(myObj.getKeyPrefix());		}else{ objKeyPre	= 'null';}
        String objLabel; 			if(String.valueOf(myObj.getLabel()) 		!= null){ objLabel 		= String.valueOf(myObj.getLabel());			}else{ objLabel 	= 'null';}
        String objLabelPlu;			if(String.valueOf(myObj.getLabelPlural()) 	!= null){ objLabelPlu 	= String.valueOf(myObj.getLabelPlural());	}else{ objLabelPlu 	= 'null';}
        String objLoacalName; 		if(String.valueOf(myObj.getLocalName()) 	!= null){ objLoacalName = String.valueOf(myObj.getLocalName());		}else{ objLoacalName= 'null';}
        String objName; 			if(String.valueOf(myObj.getName()) 			!= null){ objName 		= String.valueOf(myObj.getName());			}else{ objName 		= 'null';}
        
        objInfo.put('SObjectBaseInfo', new List<String>());
        objInfo.get('SObjectBaseInfo').add(objTypeInfo);
        objInfo.get('SObjectBaseInfo').add(objKeyPre);
        objInfo.get('SObjectBaseInfo').add(objLabel);
        objInfo.get('SObjectBaseInfo').add(objLabelPlu);
        objInfo.get('SObjectBaseInfo').add(objLoacalName);
        objInfo.get('SObjectBaseInfo').add(objName);
        
        List<Boolean> assessList = new List<Boolean>();
        
        
        
        Boolean objHasSubT 			= myObj.getHasSubtypes();
        Boolean objAccessible 		= myObj.isAccessible();
        Boolean objCreateable 		= myObj.isCreateable();
        Boolean objDeletable 		= myObj.isDeletable();
        Boolean objIsCustom 		= myObj.isCustom();
        Boolean objIsCustomSetting 	= myObj.isCustomSetting();
        Boolean objIsDepricated 	= myObj.isDeprecatedAndHidden();
        Boolean objIsFeedEnabled 	= myObj.isFeedEnabled();
        Boolean objIsMergeable 		= myObj.isMergeable();
        Boolean objIsQueryable 		= myObj.isQueryable();
        Boolean objIsSearchable 	= myObj.isSearchable();
        Boolean objIsUnDeletable 	= myObj.isUndeletable();
        Boolean objIsUpdateable 	= myObj.isUpdateable();
        
        
        objInfo.put('SObjectInfo', new List<String>());
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objHasSubT));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objAccessible));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objCreateable));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objDeletable));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsCustomSetting));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsFeedEnabled));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsMergeable));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsQueryable));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsSearchable));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsUnDeletable));
        objInfo.get('SObjectBaseInfo').add(String.valueOf(objIsUpdateable));
        
        System.debug('\nChildRelationship -->'+ChildRelationship+'\nhasSubT -->'+objHasSubT+'\nkeyPre -->'+objKeyPre+'\nobjLabel -->'+objLabel+'\nobjLabelPlu -->'+objLabelPlu+'\nobjLoacalName -->'+objLoacalName+'\nobjName -->'+objName+'\nobjRecTypeInfo -->'+objRecTypeInfo+'\nobjTypeInfo -->'+objTypeInfo+'\nobjAccessible -->'+objAccessible+'\nobjCreateable -->'+objCreateable+'\nobjDeletable -->'+objDeletable+'\nobjIsCustom -->'+objIsCustom+'\nobjIsCustomSetting -->'+objIsCustomSetting+'\nobjIsDepricated -->'+objIsDepricated+'\nobjIsFeedEnabled -->'+objIsFeedEnabled+'\nobjIsMergeable -->'+objIsMergeable+'\nobjIsQueryable -->'+objIsQueryable+'\nobjIsSearchable -->'+objIsSearchable+'\nobjIsUnDeletable -->'+objIsUnDeletable+'\nobjIsUpdateable -->'+objIsUpdateable);
        
        try{
            
        }catch(Exception ex){
            System.debug('fieldSchema failed with\nMessage : '+ex.getMessage()+'\nException type :'+ex.getTypeName()+'\nLine number :'+ex.getLineNumber()+'\nCauese :'+ex.getCause());
        }
        
        return mSObjDescribe;
    }
    
    public class wrapFieldsData{
        @auraEnabled public Map<String, String> 		mFLabel 			{get;set;}
        @auraEnabled public Map<String, String> 		mFType 				{get;set;}
        @auraEnabled public Map<String, List<String>>	mFPickValues		{get;set;}
        @auraEnabled public List<String> 				stdFields			{get;set;}
        @auraEnabled public List<String> 				cusFields 			{get;set;}
        @auraEnabled public List<String> 				allFieldsName		{get;set;}
    }
    
    class wrapObjectsData{
        @auraEnabled public Map<String, String> 					mSObjBool	 			{get;set;}
        @auraEnabled public Map<String, String>						mSObjString 			{get;set;}
        @auraEnabled public Map<String, Map<String, List<String>>> 	mSObjList				{get;set;}
    }
    
    @AuraEnabled
    Public Static wrapObjectsFeildsValues MasterDataMapping(){
        wrapObjectsFeildsValues MasterData = new wrapObjectsFeildsValues();
        scObjects 		= Schema.getGlobalDescribe();
        Map<String, String> objInfo = new Map<String, String>();
        for(String objApi : scObjects.keySet() ){
            //Object mapping
            Schema.DescribeSObjectResult myObj = scObjects.get(objApi).getDescribe();
            
            String objTypeInfo;			if(String.valueOf(myObj.getSobjectType()) 	!= null){ objTypeInfo 	= String.valueOf(myObj.getSobjectType());	}else{ objTypeInfo 	= 'null';}
            objInfo.put('objTypeInfo',objTypeInfo);
            String objKeyPre; 			if(String.valueOf(myObj.getKeyPrefix()) 	!= null){ objKeyPre		= String.valueOf(myObj.getKeyPrefix());		}else{ objKeyPre	= 'null';}
            objInfo.put('objKeyPre',objKeyPre);
            String objLabel; 			if(String.valueOf(myObj.getLabel()) 		!= null){ objLabel 		= String.valueOf(myObj.getLabel());			}else{ objLabel 	= 'null';}
            objInfo.put('objLabel',objLabel);
            String objLabelPlu;			if(String.valueOf(myObj.getLabelPlural()) 	!= null){ objLabelPlu 	= String.valueOf(myObj.getLabelPlural());	}else{ objLabelPlu 	= 'null';}
            objInfo.put('objLabelPlu',objLabelPlu);
            String objLoacalName; 		if(String.valueOf(myObj.getLocalName()) 	!= null){ objLoacalName = String.valueOf(myObj.getLocalName());		}else{ objLoacalName= 'null';}
            objInfo.put('objLoacalName',objLoacalName);
            String objName; 			if(String.valueOf(myObj.getName()) 			!= null){ objName 		= String.valueOf(myObj.getName());			}else{ objName 		= 'null';}
            objInfo.put('objName',objName);
            
            //Fields Mapping
            Map<String, Schema.SObjectField> mSObjFields = new Map<String, Schema.SObjectField>();
            mSObjFields = myObj.fields.getMap();
            
            Map<String, List<String>> mFldDescribe = new Map<String, List<String>>();
            
            for(String fld : mSObjFields.keySet()){
                Schema.DescribeFieldResult fldDesc = mSObjFields.get(fld).getDescribe();
                List<String> fldDescription = new List<String>();
                
                String getName = String.valueOf(fldDesc.getName());
                mFldDescribe.put('getName',new List<String>());
                mFldDescribe.get('getName').add(getName);
                
                String getLabel = String.valueOf(fldDesc.getLabel());
                mFldDescribe.put('getLabel',new List<String>());
                mFldDescribe.get('getLabel').add(getLabel);
                
                String getType =  String.valueOf(fldDesc.getType());
                mFldDescribe.put('getType',new List<String>());
                mFldDescribe.get('getType').add(getType);
                
                mFldDescribe.put('getPickListVals',new List<String>());
                if(getType == 'PICKLIST'){
                    List<String> values = new List<String>();
                    List<Schema.PicklistEntry> scPicklstValues = fldDesc.getPicklistValues();
                    if(!scPicklstValues.isEmpty()){
                        for(Schema.PicklistEntry val : scPicklstValues){
                             mFldDescribe.get('getPickListVals').add(String.valueOf(val.getValue()));
                        }
                    }else{
                        mFldDescribe.get('getPickListVals').add('Empty');
                    }
                }else{
                    mFldDescribe.get('getPickListVals').add('Empty');
                }
                
                String getSoapType = String.valueOf(fldDesc.getSoapType());
                mFldDescribe.put('getSoapType',new List<String>());
                mFldDescribe.get('getSoapType').add(getSoapType);
                
                String defVal;		if(fldDesc.getDefaultValue() != null){  defVal = String.valueOf(fldDesc.getDefaultValue()); }else{ defVal = 'null'; }
                mFldDescribe.put('getDefaultValue',new List<String>());
                mFldDescribe.get('getDefaultValue').add(defVal);
                
                String isIdLookup = String.valueOf(fldDesc.isIdLookup());
                mFldDescribe.put('isIdLookup',new List<String>());
                mFldDescribe.get('isIdLookup').add(isIdLookup);
                
                String isNillable = String.valueOf(fldDesc.isNillable());
                mFldDescribe.put('isNillable',new List<String>());
                mFldDescribe.get('isNillable').add(isNillable);
                
                String isUpdateable = String.valueOf(fldDesc.isUpdateable());
                mFldDescribe.put('isUpdateable',new List<String>());
                mFldDescribe.get('isUpdateable').add(isUpdateable);
                
                String relationshipName;		if(String.valueOf(fldDesc.getRelationshipName()) != null){  relationshipName = String.valueOf(fldDesc.getRelationshipName()); }else{ relationshipName = 'Not applicable'; }
                mFldDescribe.put('relationshipName',new List<String>());
                mFldDescribe.get('relationshipName').add(relationshipName);
                
                String isCreateable = String.valueOf(fldDesc.isCreateable());
                mFldDescribe.put('isCreateable',new List<String>());
                mFldDescribe.get('isCreateable').add(isCreateable);
                
                String isCustom = String.valueOf(fldDesc.isCustom());
                mFldDescribe.put('isCustom',new List<String>());
                mFldDescribe.get('isCustom').add(isCustom);
                
                String isUnique = String.valueOf(fldDesc.isUnique());
                mFldDescribe.put('isUnique',new List<String>());
                mFldDescribe.get('isUnique').add(isUnique);
                
                String isRestrictedDelete = String.valueOf(fldDesc.isRestrictedDelete());
                mFldDescribe.put('isRestrictedDelete',new List<String>());
                mFldDescribe.get('isRestrictedDelete').add(isRestrictedDelete);
            
            }
        }
        return MasterData;
    }
    
  
    public class wrapObjectsFeildsValues{
        
        @auraEnabled public Map<String, Map<String, String>> 			mSObjFieldDes	 		{get;set;}
        @auraEnabled public Map<String, Map<String, String>>			mSObjPDes 				{get;set;}
        @auraEnabled public Map<String, Map<String, List<String>>> 		mSObjList				{get;set;}
        @auraEnabled public Map<String, List<String>>					mSObjFlds				{get;set;}
        @auraEnabled public List<sObject>						 		sObjList				{get;set;}
        @auraEnabled public List<String>						 		fieldNames				{get;set;}
        
    }
    
    
}