({
    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Controller
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping_Lookup
    @ Language used			: Javascript
    @ No. of Listeners		: 3 Approx
    @ Extended to others	: No
    @ Cache enabled			: No
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
        
/*************************************************************************
Function Name: selectThisValue
Description : get all the data set and values of the selected field and
				create params for the parent component if not reference
                or set params and register values in the event
**************************************************************************/
	selectThisValue : function(component, event, helper) {
        let value = event.currentTarget.dataset.val;
        let fldLabel = event.currentTarget.dataset.relName;
        let sobject = event.currentTarget.dataset.sobject;
        if(!helper.isNotBlank(sobject)){
            sobject = event.currentTarget.dataset.objectname;
        }
        let valtype = event.currentTarget.dataset.valtype;
        let isref = event.currentTarget.dataset.isref;
        let fieldapi = event.currentTarget.dataset.fieldapi;
        let objectName = event.currentTarget.dataset.objectname;
        
        if(isref==="true"){
            var reOrder = component.get('v.orderLine')+' > '+fldLabel;
            component.set('v.orderLine',reOrder);
            component.set('v.title',objectName);
            helper.getParentPicklistFieldsLc(component, event, helper, fieldapi,valtype,sobject,objectName);
        }
        else{
            component.getEvent("fieldSelected").setParams({
                data:{
                    val:value,
                    traverse : component.get('v.parentFields.traverse')+'>'+value,
                    sobject : sobject,
                    objectName:objectName,
                    valtype:valtype
                }
            }).fire();
        }
	},
    
    
/*************************************************************************
Function Name: handleCheckBox
Description : Enable and disable checkbox to view only the lookups and non-lookups
**************************************************************************/
    handleCheckBox : function(component, event, helper) {
        component.set('v.parentsOnly',event.getParam('checked'));
    },
    
/*************************************************************************
Function Name: clearParentLookupsHolder
Status : #Unused
Description : Clear Parent Lookups Holder if there are any values
**************************************************************************/
    clearParentLookupsHolder: function(component, event, helper) {
        component.find("lookupNavigationPlaceHolder").set("v.body", []);
    },
})