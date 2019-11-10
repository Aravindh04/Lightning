({
    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Controller
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping_FieldMapping
    @ Language used			: Javascript
    @ No. of Listeners		: 2 Approx
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
        /*let value = event.currentTarget.dataset.value;
        let label = event.currentTarget.dataset.label;
        let fieldType = event.currentTarget.dataset.fieldType;
        let objectName = event.currentTarget.dataset.objectName;
        let parentRelApi = event.currentTarget.dataset.parentRelApi;*/
        let index = event.currentTarget.dataset.index;
        console.log('index '+ index);
        var parentVal = component.get('v.parentFields');
        console.log('allVlaues '+JSON.stringify(parentVal));
        console.log('selectValue : fieldType '+parentVal[index].fieldType+' parentRelApi '+parentVal[index].parentRelApi+' value '+parentVal[index].value+' label '+parentVal[index].label+' objectName '+parentVal[index].objectName);
        
        if(parentVal[index].fieldType==="REFERENCE"){
            console.log('isReference');
            helper.getNumberFieldsLc(component, event, helper, parentVal[index].parentRelApi,  parentVal[index].value);
        }
        else{
            var traverse = component.get('v.traverse');
            console.log('traverse '+traverse);
            if(helper.isNotBlank(traverse)){
                traverse = traverse +' > '+parentVal[index].value;
            }else{
                traverse = parentVal[index].value ;
            }
            component.getEvent("otherFieldSelected").setParams({
                data:{
                    value:parentVal[index].value,
                    label:parentVal[index].label,
                    objectName:parentVal[index].objectName,
                    attributeName : component.get('v.standardField'),
                    traverse : traverse
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
})