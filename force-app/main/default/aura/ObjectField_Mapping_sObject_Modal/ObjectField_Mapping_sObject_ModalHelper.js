({
    
	/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Container type 		: JS Helper
    @ Description			: -
    @ Parent Container		: ObjectField_Mapping_sObject_Modal
    @ Language used			: Javascript
    @ No. of Listeners		: 2 Approx
    @ Extended to others	: No
    @ Cache enabled			: No
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
    
    
/*************************************************************************
Function Name: splitObject
Status : #Unused
Description : Split the list of objects received into standard and custom object
**************************************************************************/
    splitObject :  function(component,event,helper,data) {
        var cusObj = [];
        var stdObj = [];
        data.forEach(function(object){
            if(helper.isNotBlank(object.value)){
                if(object.value.indexOf('__c') >= 0){
                    cusObj.push(object);
                    console.log('custom '+object.value);
                }else{
                    stdObj.push(object);
                }
            }
        });
        component.set('v.cusObj',cusObj);
        component.set('v.stdObj',stdObj);
        component.set('v.listOfObjects',data);
    },
    
/*************************************************************************
Function Name: isNotBlank
Description : check whether the string recieved is empty or null or undefined
**************************************************************************/
    isNotBlank : function(checkString) {
        return (checkString != '' && checkString != null &&
                !$A.util.isEmpty(checkString) && !$A.util.isUndefined(checkString));
    },
})