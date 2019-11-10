({
	selectThisValue : function(component, event, helper) {
        let value = event.currentTarget.dataset.val;
        let sobject = event.currentTarget.dataset.sobject;
        let valtype = event.currentTarget.dataset.valtype;
        let isref = event.currentTarget.dataset.isref;
        let fieldapi = event.currentTarget.dataset.fieldapi;
        let objectName = event.currentTarget.dataset.objectname;
        
        if(isref==="true"){
            helper.getParentPicklistFieldsLc(component, event, helper, fieldapi,valtype,sobject,objectName);
        }
        else{
            /*component.getEvent("fieldSelected").setParams({
                data:{
                    val:value,
                    sobject:sobject,
                    objectName:objectName,
                    valtype:valtype
                }
            }).fire();*/
        }
	},
    clearParentLookupsHolder: function(component, event, helper) {
        component.find("lookupNavigationPlaceHolder").set("v.body", []);
    },
})