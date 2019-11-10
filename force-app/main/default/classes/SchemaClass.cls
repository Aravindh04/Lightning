public class SchemaClass {
    
    Public static Map<String, Schema.SObjectType> scObjects 		= Schema.getGlobalDescribe();
    
	@AuraEnabled
    Public Static Map<String, Map<String,String>> MasterDataMapping(){
        Map<String, Map<String,String>> objDes = new Map<String, Map<String,String>>();
        
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
            
            objDes.put(objApi,objInfo);
        
        }
        return objDes;
    }
    
    public Map<String, List<String>> getPickList(String sObjName){
        Map<String, List<String>> mFPickValues = new Map<String, List<String>>();
        Map<String, Map<String, String>> mFldDescribe = new Map<String, Map<String, String>>();
        Map<String, String> mDes = new Map<String, String>();
        Map<String, Schema.SObjectField> mFields = new Map<String, Schema.SObjectField>();
        mFields = scObjects.get(sObjName).getDescribe().fields.getMap();
        
        if(!mFields.keySet().isEmpty()){
            for(String s : mFields.keySet()){
                Schema.DescribeFieldResult fldDesc = mFields.get(s).getDescribe();
                String fldType 	= String.valueOf(fldDesc.getType());
                String fldName 	= fldDesc.getName();
                if(fldType == 'PICKLIST'){
                    List<String> values = new List<String>();
                    List<Schema.PicklistEntry> scPicklstValues = fldDesc.getPicklistValues();
                    if(!scPicklstValues.isEmpty()){
                        for(Schema.PicklistEntry val : scPicklstValues){
                            values.add(String.valueOf(val.getValue()));
                        }
                        if(!values.isEmpty()){
                            mFPickValues.put(s, values);
                        }
                    }
                }
                
                String getName = String.valueOf(fldDesc.getName());
                mDes.put('getName',getName);
                
                String getLabel = String.valueOf(fldDesc.getLabel());
                mDes.put('getLabel',getLabel);
                
                String getType =  String.valueOf(fldDesc.getType());
                mDes.put('getType',getType);
                
                String getSoapType = String.valueOf(fldDesc.getSoapType());
                mDes.put('getSoapType',getSoapType);
                
                String defVal;		if(fldDesc.getDefaultValue() != null){  defVal = String.valueOf(fldDesc.getDefaultValue()); }else{ defVal = 'null'; }
                mDes.put('getDefaultValue',defVal);
                
                String isIdLookup = String.valueOf(fldDesc.isIdLookup());
                mDes.put('isIdLookup',isIdLookup);
                
                String isNillable = String.valueOf(fldDesc.isNillable());
                mDes.put('isNillable',isNillable);
                
                String isUpdateable = String.valueOf(fldDesc.isUpdateable());
                mDes.put('isUpdateable',isUpdateable);
                
                String relationshipName;		if(String.valueOf(fldDesc.getRelationshipName()) != null){  relationshipName = String.valueOf(fldDesc.getRelationshipName()); }else{ relationshipName = 'Not applicable'; }
                mDes.put('relationshipName',relationshipName);
                
                String isCreateable = String.valueOf(fldDesc.isCreateable());
                mDes.put('isCreateable',isCreateable);
                
                String isCustom = String.valueOf(fldDesc.isCustom());
                mDes.put('isCustom',isCustom);
                
                String isUnique = String.valueOf(fldDesc.isUnique());
                mDes.put('isUnique',isUnique);
                
                String isRestrictedDelete = String.valueOf(fldDesc.isRestrictedDelete());
                mDes.put('isRestrictedDelete',isRestrictedDelete);
                
                mFldDescribe.put(s, mDes);
                
                
            }
        }
        return mFPickValues;
    }
    
    
    public class wrapFieldsData{
        @auraEnabled public Map<String, Map<String, String>>			mSObjFieldDes	 		{get;set;}
        @auraEnabled public Map<String, Map<String, String>>			mSObjPDes 				{get;set;}
        @auraEnabled public Map<String, Map<String, List<String>>> 		mSObjPicklistVals		{get;set;}
    }
}