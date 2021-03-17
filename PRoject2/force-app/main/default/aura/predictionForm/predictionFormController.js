({
	handleComponentEvent : function(component, event, helper) {
        
        component.setParam("v.CurrentUser", "userId");
	},
    
    handleSubmit : function(cmp, event, helper) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
        fields.LastName = 'My Custom Last Name'; // modify a field
        cmp.find('myRecordForm').submit(fields);
    },
    
    handlefiredEvent : function(component, event, helper){
		var newValue = event.getSource().getName();
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var newVar = event.getParam("stockName");
        component.set("v.stock",newVar);
        comonent.set("v.CurrentUser",userId);
    },
})