function startControllerPolling(linkId){
    setInterval(() => document.getElementById(linkId).click(), 1000);
    console.log("Polling started");
}
