function startControllerPolling(linkId){
    if(!isPolling) {
        pollingId = setInterval(() => document.getElementById(linkId).click(), 1000);
        isPolling = true;
        console.log("Polling started");
    }
    else
        console.warn("Already polling");
}

function stopControllerPolling(linkId){
    if(pollingId!==null) {
        clearInterval(pollingId);
        pollingId = null;
        isPolling = false;
        console.log("Polling stopped");
    }
    else
        console.warn("No polling underway");
}
