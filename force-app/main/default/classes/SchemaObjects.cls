public class SchemaObjects {
    Public Map<String, Schema.SObjectType> mObjs {get;set;}
    Public List<String> objList {get;set;}
    Public List<SelectOption> objects {get;set;}
    Public String selectedObj {get;set;}
    Public String objectDescription {set;get;}
    Public Map<String, Schema.SObjectField> mfields {get;set;}
    Public List<String> fields {get;set;}
    Public List<String> sfields {get;set;}
    Public List<String> rfields {get;set;}
    Public List<SelectOption> fsOptions {get;set;}
    Public List<SelectOption> fnsOptions {get;set;}
    Public Set<String> fnotSelected {get;set;}
    Public Set<String> fSelected {get;set;}
    Public List<SObject> myData {get;set;}
    Public List<String> queryFields {get;set;}
    
    
    //Default constructor
    Public SchemaObjects(){
        //Set<String> objs = new Set<String>();
        objList =  new List<String>();
        queryFields = new List<String>();
        myData = new List<SObject>();
        objects =  new List<SelectOption>();
        fields =  new List<String>();
        sfields =  new List<String>();
        rfields =  new List<String>();
        fSelected = new set<String>();
        fnotSelected = new set<String>();
        fsOptions = new List<SelectOption>();
        fnsOptions = new List<SelectOption>();
        
        mObjs = Schema.getGlobalDescribe();
        objList.addAll(mObjs.keySet());
        objList.sort();
        SelectOption p = new SelectOption('None','--None--');
        objects.add(p);
        for(String s : objList){
            SelectOption op = new SelectOption(s,s);
            objects.add(op);
        }

    }
    
    Public void details(){
        Schema.DescribeSObjectResult myObj = mObjs.get(selectedObj).getDescribe();
        objectDescription = 'Description: '+myObj;
        mfields = mObjs.get(selectedObj).getDescribe().fields.getMap();
        fields.addAll(mfields.keySet());
        fields.sort();
        fnotSelected.addAll(fields);
        show();
    }	
    
    public void show(){
        
        fnsOptions.clear();
        for(string s:fnotSelected){
            SelectOption op =  new SelectOption(s,s);
            fnsOptions.add(op);
        }
        
        fsOptions.clear();
        for(String s : fSelected){
            SelectOption op = new SelectOption(s,s);
            fsOptions.add(op);
        }
    }
    
    public void addFields(){
        fnotSelected.removeAll(sfields);
        fSelected.addAll(sfields);
        show();
    }
    
    public void removeFields(){
        fnotSelected.addAll(rfields);
        fSelected.removeAll(rfields);
        show();
    }
    
    public void queryMyData(){
        String query = 'SELECT Id';
        queryFields.addAll(fSelected);
        for(String s :fSelected){
            query = query +', '+s;
        }
        query = query + ' FROM '+selectedObj;
        
        myData = Database.query(query);
    }
}