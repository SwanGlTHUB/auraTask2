({
    showMyToast : function(message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'pester',
            duration: 200,
            message: `${message}`,
        });
        toastEvent.fire();
    },
    setHeaderCheckboxStatus : function(component) {
        let selectedRooms = component.get('v.selectedRooms')
        let roomsToDisplay = component.get('v.roomsToDisplay')
        let checkboxDOM = component.find('headerCheckbox')
        if(!Object.keys(selectedRooms).length){
            checkboxDOM.setAttribute('checked', false)
            checkboxDOM.setAttribute('indeterminate', false)
            return
        }
        if(Object.keys(selectedRooms).length != Object.keys(roomsToDisplay).length){
            checkboxDOM.setAttribute('checked', false)
            checkboxDOM.setAttribute('indeterminate', true)
        }
        if(Object.keys(selectedRooms).length == Object.keys(roomsToDisplay).length){
            checkboxDOM.setAttribute('checked', true)
            checkboxDOM.setAttribute('indeterminate', false)
        }
    },
    apex: function(cmp, method, params) {
        return new Promise(function (resolve, reject) {
            var action = cmp.get("c." + method);
            action.setParams(params);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                        reject(errors[0].message);
                    } else {
                        console.log("Unknown error");
                        reject("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        });
    },
})
