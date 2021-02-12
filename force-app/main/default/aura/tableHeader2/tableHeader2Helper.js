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
    createNewTrip: function(selectedRooms, component){  
        let allSelectedRoomsIds = Object.keys(selectedRooms)
        let totalOwnerCost = 0
        let totalClientCost = 0
        allSelectedRoomsIds.forEach((item) => {
            totalOwnerCost += selectedRooms[item].totalCostPrice
            totalClientCost += selectedRooms[item].totalSellPrice
        })
        this.apex(component, 'createNewTrip', {
            costForOwner: totalOwnerCost,
            costForClients: totalClientCost
        })
        .then((tripId) => {
            let allPromises = []
            console.log('farov')
            console.log(tripId)
            allSelectedRoomsIds.forEach((roomId) => {
                let room = selectedRooms[roomId]
                console.log('====')
                console.log(JSON.parse(JSON.stringify(room)))
                allPromises.push(this.apex(component, 'createBookedRoom', {
                    relatedPriceId : room.priceId,
                    relatedRoomId: room.roomId,
                    relatedTripId: tripId
               }))
            })
            Promise.all(allPromises)
            .then(() => {
                this.showMyToast('New trip was successfully created')
            })
            .catch((error) => {
                console.log(error)
                this.showMyToast('New trip was not created')
            })
        })
        .catch((error) => {
            console.log(error)
        })
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
                        reject("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        });
    },
})
