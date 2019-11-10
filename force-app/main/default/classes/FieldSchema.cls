public class FieldSchema {
    @AuraEnabled
    Public Static Map<String, List<String>> fieldSchema(List<String> desFldNames, String sObjName){
        //Mapping Fields with their Descriptions
        Map<String, List<String>> mFldDescribe = new Map<String, List<String>>();
        
        
        Map<String, Schema.SObjectField> mSObjFields = new Map<String, Schema.SObjectField>();
        mSObjFields = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        
        try{
            for(String fld : desFldNames){
                Schema.DescribeFieldResult fldDesc = mSObjFields.get(fld).getDescribe();
                List<String> fldDescription = new List<String>();
                fldDescription.add(String.valueOf(fldDesc.getName()));
                fldDescription.add(String.valueOf(fldDesc.getLabel()));
                fldDescription.add(String.valueOf(fldDesc.getType()));
                fldDescription.add(String.valueOf(fldDesc.getSoapType()));
                fldDescription.add(String.valueOf(fldDesc.getDefaultValue()));
                fldDescription.add(String.valueOf(fldDesc.isIdLookup()));
                fldDescription.add(String.valueOf(fldDesc.isNillable()));
                fldDescription.add(String.valueOf(fldDesc.isUpdateable()));
                fldDescription.add(String.valueOf(fldDesc.getRelationshipName()));
                fldDescription.add(String.valueOf(fldDesc.isCreateable()));
                fldDescription.add(String.valueOf(fldDesc.isCustom()));
                fldDescription.add(String.valueOf(fldDesc.isUnique()));
                fldDescription.add(String.valueOf(fldDesc.isRestrictedDelete()));
                mFldDescribe.put(fld, fldDescription);
            }
        }catch(Exception ex){
            System.debug('fieldSchema failed with\nMessage : '+ex.getMessage()+'\nException type :'+ex.getTypeName()+'\nLine number :'+ex.getLineNumber()+'\nCauese :'+ex.getCause());
        }
        
        return mFldDescribe;
    }
}