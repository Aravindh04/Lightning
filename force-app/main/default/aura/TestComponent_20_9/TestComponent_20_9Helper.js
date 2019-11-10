({
	testThebutton : function(component,event) {
        var source = event.getSource().get('v.label');
        alert('Name of the Button : '+source);
	}
})