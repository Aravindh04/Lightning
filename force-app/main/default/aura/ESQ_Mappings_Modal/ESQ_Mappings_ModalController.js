({
	hideParentLookupModal : function(component, event, helper) {
		component.destroy();
	},
    
    openModal : function(component, event, helper) {
        component.set('v.hideModal', true);
        helper.callComponentToPlaceHolder(component,'c:ESQ_Mappings_Modal','place',({ parentFields : component.get('v.parentFields')}));
    }
})