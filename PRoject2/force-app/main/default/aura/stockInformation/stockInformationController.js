({
	displayStock : function(component, event, helper) {        
        
		var action = component.get('c.fetchStockNews');
        var Symbols = component.get('v.myMessage');
        //var action1 = component.get('c.methodTwo');
        
        action.setParams({
            tickerSymbol : Symbols,
            NumberofArticles : 3
        });
        
        action.setCallback(this,function(response){
            console.log(response.getState());
            component.set('v.objClassController',response.getReturnValue());
        });
        
        $A.enqueueAction(action);
   //     $A.enqueueAction(action1);
        
		var newVar = event.getParam("stockName");
        component.set("v.buttonLabel",newVar );
	},
    getLabel : function(component, event, helper) {
        component.set("v.buttonLabel", "Successful !!!!");
    },
    fireAnEvent : function(component, event, helper){
        //component.set("v.buttonLabel","Inside Fire event method !!!!");
        
        var compEve = $A.get("e.c:setstock");
        compEve.setParams({"stockName" : component.get("v.myMessage") });
        compEve.fire();
    },
    handlefiredEvent : function(component, event, helper){
		
       	var newVar = event.getParam("stockName");
        component.set("v.buttonLabel",newVar );
        
    },
})