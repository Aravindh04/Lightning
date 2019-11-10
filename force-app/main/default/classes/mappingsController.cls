public class mappingsController {

    @AuraEnabled
    public static Map<String,Object> getAllValues() {
        Map<String,Object> allValues = new Map<String,Object>();
        
        return allValues;
    }
    
    /*@AuraEnabled
    public static Case_Inventory_Summary__c storeMappings(String mappings){
        Case_Inventory_Summary__c cis = new Case_Inventory_Summary__c(Mapping_JSON__c = mappings,Store_Type__c='Mapping');
        insert cis;
        return cis;
    }*/
    
    @AuraEnabled
    public static Mapping_Template__c storeMappings(String mappings){
        Mapping_Template__c cis = new Mapping_Template__c (Mapping_JSON__c = mappings);
        insert cis;
        return cis;
    }
    
    
    
    /*@AuraEnabled
    public static Case_Inventory_Summary__c getMappings(){
        List<Case_Inventory_Summary__c> cis = [SELECT Id, Mapping_JSON__c FROM Case_Inventory_Summary__c WHERE Store_Type__c='Mapping' ORDER BY LastModifiedDate DESC LIMIT 1];
        if(cis.size()>0) return cis[0];
        return null;
    }*/
    
    @AuraEnabled
    public static Mapping_Template__c getMappings(){
        List<Mapping_Template__c> cis = [SELECT Id, Mapping_JSON__c FROM Mapping_Template__c ORDER BY LastModifiedDate DESC LIMIT 1];
        if(cis.size()>0) return cis[0];
        return null;
    }
    
    @AuraEnabled
    public static List<String> getAllObjectsList(){
        List<string> sObjectList = new List<string>();
        
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            // Exclude all the unwanted Sobjects e.g. History, Share etc..
            
            if(!name.containsignorecase('history') && !name.containsignorecase('tag')&&
               !name.containsignorecase('share') && !name.containsignorecase('feed'))
            {      
                sObjectList.add(name);
                System.debug( 'Name : ' + name);
            }
        }
        sObjectList.sort();
        
        return sObjectList;
    }
    
    @AuraEnabled
    public static List<AggregateResult> getSummary(String objectName, String fields) {
        List<AggregateResult> summary = new List<AggregateResult>();
        String soql = '';
        for(Map<String,String> fmap : getNumberFields(objectName)){
            for(String f : fmap.keySet()){
                if(f=='fieldLabel'){
                    soql+= 'SUM('+fmap.get('fieldApi')+') '+fmap.get('fieldLabel').replace(' ','_')+',';
                }
            }
        }
        
        soql = soql.removeEnd(',');
        
        soql = 'SELECT Count(Id) Count_Of_Records,'+soql+','+ fields +' FROM + '+objectName+' + GROUP BY '+fields;
        
        system.debug('SOQL => '+soql);
        
        summary = Database.query(soql);
        
        return summary;
    }
    
    @AuraEnabled
    public Static List<Map<String,String>> getNumberFields(String objectName){
        List<Map<String,String>> options = new List<Map<String,String>>();
        Map<String,Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        for(String field : fieldsMap.keySet()){
            if(fieldsMap.get(field).getDescribe().getType().name()=='CURRENCY' || 
               fieldsMap.get(field).getDescribe().getType().name()=='DOUBLE' ||
               fieldsMap.get(field).getDescribe().getType().name()=='INTEGER'||
              fieldsMap.get(field).getDescribe().getType().name()=='DATE')
            {
                Map<String,String> opt = new Map<String,String>();
                opt.put('custom', field);
                opt.put('customLabel', fieldsMap.get(field).getDescribe().getLabel());
                opt.put('standard', '');
                options.add(opt);
            }
        }
        system.debug('options => '+options);
        return options;
    }
    
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
    
    @AuraEnabled
    public static Map<String,Map<String,String>> getParentPicklistFields(String objectName, String relationshipApi){
        system.debug('relationshipApi => '+relationshipApi);
        system.debug('objectName => '+objectName);
        Schema.SObjectType parentObj = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(relationshipApi).getDescribe().getReferenceTo()[0];
        
        return getPicklistFields(parentObj.getDescribe().getName());
    }
    
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
    
}