/***************************************************************************************
@Author				: Rahul
@Name				: ObjectField_MappingClass
@Created Date		: 
@Description		: To get The generic values from the Org and Populate the values 
@API version		: 43.0
@Number of methods 	: 
****************************************************************************************/
public class ObjectField_MappingClass {
    
    
    //Contains all the Describe of the Org
    Public static Map<String, Schema.SObjectType> scObjects = Schema.getGlobalDescribe();
    
/***************************************************************************************
@Author				: Rahul
@Name				: getAllValues
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static Map<String,Object> getAllValues() {
        Map<String,Object> allValues = new Map<String,Object>();
        return allValues;
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: storeTypeValues
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static String storeTypeValues(String masterObject, String caseType, String TypeMappings, String otherList, String typeFields, String stageFields){
        String response;
        Boolean exists = true;
        Mapping_Template__c template = getMappings();
        if(template != null){
            if(template.Master_Object__c != masterObject && template.Net__c != null){
                template = new Mapping_Template__c();
                exists = false;
            }    
        }else{
            template = new Mapping_Template__c();
            exists = false;
        }
        template.Master_Object__c = masterObject;
        template.Case_Type__c = caseType;
        template.Type_Mappings__c = TypeMappings;
        template.All_List__c = otherList;
        template.Type_Mappings__c = typeFields;
        template.Stage_Mappings__c = stageFields;
        system.debug('template '+template);
        try{
            if(exists){
                UPDATE template;
            }else{
                INSERT template;
            }
            response = 'SUCCESS';
        }catch(exception ex){
            response = ex.getMessage();
        }
        return response;
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: storeStageValues
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static String storeStageValues(String masterObject, String caseType, String caseStage, String typeMappings, String stageMappings, String allLists) {
         string responseMessage;
        try{
            Mapping_Template__c template = getMappings();
            template.Master_Object__c = masterObject;
            template.Case_Type__c = caseType;
            template.Stage__c = caseStage;
            template.All_List__c = allLists;
            template.Type_Mappings__c = typeMappings;
            template.Stage_Mappings__c = stageMappings;
            update template;
            responseMessage = 'SUCCESS';
        }catch(Exception ex){
            responseMessage = ex.getMessage();
        }
        return responseMessage;
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: getMappings
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static Mapping_Template__c getMappings(){
        try{
        Mapping_Template__c templateMapping = [SELECT Id, Master_Object__c, Case_Type__c, Stage__c, Case_Name__c, Case_Index_Number__c, 
                                              Venue__c, Estimated_Close_Date__c, Total_Matter_Value__c, Retainer__c, Gross__c,
                                              Pct_Fee_Due_to_Others__c, Dollar_Fee_Due_to_Others__c, Net__c, Mapping_JSON__c,
                                              Type_Mappings__c, Stage_Mappings__c, All_List__c
                                              FROM Mapping_Template__c ORDER BY createdDate DESC LIMIT 1];
            return templateMapping;
        }catch(exception ex){
            return null;
        }
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: storeMappings
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static String storeMappings(String masterObject, String caseType, String caseStage, String typeMappings, String stageMappings, String allLists, Map<String, String> OtherFields){
        string responseMessage;
        Boolean exists = true;
        try{
            Mapping_Template__c template = getMappings();
            if(template != null){
                system.debug('template 1: '+template);
                system.debug('template 1: '+masterObject+' '+caseType+' '+caseStage+' '+OtherFields.get('Case_Name')+' '+OtherFields.get('Case_Index')+' '+OtherFields.get('Venue')+' '+OtherFields.get('Estimated_Closed_Date')+' '+OtherFields.get('Total_Matter_Value')+' '+OtherFields.get('Retainer')+' '+OtherFields.get('Gross')+' '+OtherFields.get('Percent_Fee')+' '+OtherFields.get('Dollar_Fee')+' '+OtherFields.get('Net'));
                if(template.Master_Object__c != masterObject && template.Case_Type__c != caseType && template.Stage__c != caseStage && (OtherFields.get('Case_Name') != '{}' && template.Case_Name__c != OtherFields.get('Case_Name'))&& (OtherFields.get('Case_Index') != '{}' && template.Case_Index_Number__c != OtherFields.get('Case_Index')) && (OtherFields.get('Venue') != '{}' && template.Venue__c  != OtherFields.get('Venue')) && (OtherFields.get('Estimated_Closed_Date') != '{}' && template.Estimated_Close_Date__c != OtherFields.get('Estimated_Closed_Date')) && (OtherFields.get('Total_Matter_Value') != '{}' && template.Total_Matter_Value__c != OtherFields.get('Total_Matter_Value')) && (OtherFields.get('Retainer') != '{}' && template.Retainer__c != OtherFields.get('Retainer')) && (OtherFields.get('Gross') != '{}' && template.Gross__c != OtherFields.get('Gross')) && (OtherFields.get('Percent_Fee') != '{}' && template.Pct_Fee_Due_to_Others__c != OtherFields.get('Percent_Fee')) && (OtherFields.get('Dollar_Fee') != '{}' && template.Dollar_Fee_Due_to_Others__c != OtherFields.get('Dollar_Fee')) && (OtherFields.get('Net') != '{}' && template.Net__c != OtherFields.get('Net'))){
                    template = new Mapping_Template__c();
                    exists = false;
                }    
            }else{
                template = new Mapping_Template__c();
                exists = false;
            }
            template.Master_Object__c = masterObject;
            template.Case_Type__c = caseType;
            template.Stage__c = caseStage;
            template.All_List__c = allLists;
            template.Type_Mappings__c = typeMappings;
            template.Stage_Mappings__c = stageMappings;
            template.Case_Name__c = OtherFields.get('Case_Name');
            template.Case_Index_Number__c = OtherFields.get('Case_Index');
            template.Venue__c = OtherFields.get('Venue');
            template.Estimated_Close_Date__c = OtherFields.get('Estimated_Closed_Date');
            template.Total_Matter_Value__c = OtherFields.get('Total_Matter_Value');
            template.Retainer__c = OtherFields.get('Retainer');
            template.Gross__c = OtherFields.get('Gross');
            template.Pct_Fee_Due_to_Others__c = OtherFields.get('Percent_Fee');
            template.Dollar_Fee_Due_to_Others__c = OtherFields.get('Dollar_Fee');
            template.Net__c = OtherFields.get('Net');
            system.debug('OtherFields '+OtherFields);
            if(exists){
                UPDATE template;
            }else{
                INSERT template;
            }
            responseMessage = 'SUCCESS';
        }catch(Exception ex){
            responseMessage = ex.getMessage();
        }
        return responseMessage;
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: getObjectsMap
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static Map<String, String> getObjectsMap(){
        Map<String, String> mapObjects = new Map<String, String>();
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
        
        return mOLabel;
    }
    
    
    
/***************************************************************************************
@Author				: Rahul
@Name				: getPicklistFields
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    //Get Map picklist vals
    @AuraEnabled
    public static Map<String,Map<String,String>> getPicklistFields(String objectName) {
        system.debug('objectName => '+objectName);
        Map<String,Map<String,String>> options = new Map<String,Map<String,String>>();
        Map<String,Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        
        for(String field : fieldsMap.keySet()){
            
            if(fieldsMap.get(field).getDescribe().getType().name()=='PICKLIST' ||
               fieldsMap.get(field).getDescribe().getType().name()=='STRING'){
                   
                   Map<String,String> innerMap = new Map<String,String>();
                   innerMap.put('name',fieldsMap.get(field).getDescribe().getName());
                   innerMap.put('label',fieldsMap.get(field).getDescribe().getLabel());
                   innerMap.put('objectName',objectName);
                   innerMap.put('fieldApi',String.valueOf(fieldsMap.get(field).getDescribe().getSobjectField()));
                   innerMap.put('relationshipApi',String.valueOf(fieldsMap.get(field).getDescribe().getRelationshipName()));
                   innerMap.put('relationshipParentApi',objectName);
                   innerMap.put('isReference',String.isNotBlank(String.valueOf(fieldsMap.get(field).getDescribe().getRelationshipName())) ? 'true':'false');
                   options.put(fieldsMap.get(field).getDescribe().getLabel(),innerMap);
               }
        }
        for(String field : fieldsMap.keySet()){
            if(fieldsMap.get(field).getDescribe().getType().name()=='REFERENCE'){
                Schema.SObjectType parentObj = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(String.valueOf(fieldsMap.get(field).getDescribe().getName())).getDescribe().getReferenceTo()[0];
                
                Map<String,String> innerMap = new Map<String,String>();
                innerMap.put('name',fieldsMap.get(field).getDescribe().getName());
                innerMap.put('objectName',objectName);
                innerMap.put('fieldApi',String.valueOf(fieldsMap.get(field).getDescribe().getSobjectField()));
                innerMap.put('relationshipApi',String.valueOf(fieldsMap.get(field).getDescribe().getRelationshipName()));
                innerMap.put('relationshipParentApi',String.valueOf(parentObj));
                innerMap.put('isReference',String.isNotBlank(String.valueOf(fieldsMap.get(field).getDescribe().getRelationshipName())) ? 'true':'false');
                options.put(fieldsMap.get(field).getDescribe().getLabel(),innerMap);
            }
        }
        
        return options;         
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: getParentPicklistFields
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static Map<String,Map<String,String>> getParentPicklistFields(String objectName, String relationshipApi){
        system.debug('relationshipApi => '+relationshipApi);
        system.debug('objectName => '+objectName);
        Schema.SObjectType parentObj = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(relationshipApi).getDescribe().getReferenceTo()[0];
        
        return getPicklistFields(parentObj.getDescribe().getName());
    }
    
    
/***************************************************************************************
@Author				: Rahul
@Name				: getNumberFields
@Created Date		: 
@Description		:
@API version		: 43.0
****************************************************************************************/
    //For Getting all values
    @AuraEnabled
    public Static List<Map<String,String>> getNumberFields(String objectName){
        List<Map<String,String>> options = new List<Map<String,String>>();
        Map<String,Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        for(String field : fieldsMap.keySet()){
            if(fieldsMap.get(field).getDescribe().getType().name()=='CURRENCY' || 
               fieldsMap.get(field).getDescribe().getType().name()=='DOUBLE' ||
               fieldsMap.get(field).getDescribe().getType().name()=='INTEGER'||
               fieldsMap.get(field).getDescribe().getType().name()=='PERCENT'||
              fieldsMap.get(field).getDescribe().getType().name()=='DATE' ||
               fieldsMap.get(field).getDescribe().getType().name()=='TEXTAREA' ||
                 fieldsMap.get(field).getDescribe().getType().name()=='REFERENCE')
            {
                Map<String,String> opt = new Map<String,String>();
                opt.put('custom', field);
                opt.put('customLabel', fieldsMap.get(field).getDescribe().getLabel());
                opt.put('standard', '');
                opt.put('fieldType',fieldsMap.get(field).getDescribe().getType().name());
                opt.put('objectName',objectName);
                if(fieldsMap.get(field).getDescribe().getType().name()=='REFERENCE'){
                    Schema.SObjectType parentObj = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(String.valueOf(fieldsMap.get(field).getDescribe().getName())).getDescribe().getReferenceTo()[0];
                	opt.put('parentRelApi',String.valueOf(parentObj));    
                }
                options.add(opt);
            }
        }
        system.debug('options => '+options);
        return options;
    }
    
/***************************************************************************************
@Author				: Rahul
@Name				: getPicklistValues
@Description		: If the Field type is a picklist select all the values of the Picklist
						else return the field values for the selected Objetc
@API version		: 43.0
****************************************************************************************/
    @AuraEnabled
    public static Map<String,String> getPicklistValues(String objectName, String picklistField) {
        picklistField = picklistField.trim();
        
        String fieldType = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(picklistField).getDescribe().getType().name();
        if(fieldType == 'PICKLIST'){
            Schema.DescribeFieldResult stagesFR = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(picklistField).getDescribe();
            List<Schema.PicklistEntry> stagesPle = stagesFR.getPicklistValues();
            
            Map<String,String> valuesMap = new Map<String,String>();
            
            for( Schema.PicklistEntry s : stagesPle){
                valuesMap.put(s.getLabel(), s.getValue());
            }
            
            return valuesMap;   
        }
        else{
            
            List<sObject> recs = Database.query('SELECT '+picklistField+' FROM '+objectName);
            Map<String,String> valuesMap = new Map<String,String>();
            
            for(sObject s : recs){
                valuesMap.put(String.valueOf(s.get(picklistField)), String.valueOf(s.get(picklistField)));
            }
            
            return valuesMap;
        }
    }
 
}