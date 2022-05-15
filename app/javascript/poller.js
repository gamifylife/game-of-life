let isPolling = false;
let id = null;

function startControllerPolling(generation, size, matrix){
    if(!isPolling) {
        id = setInterval(() => polling(parseInt(generation), JSON.parse(size), JSON.parse(matrix)), 1000);
        isPolling = true;
        console.log("Polling started");
    }
    else
        console.warn("Already polling");
}

function stopControllerPolling(){
    if(id !== null) { 
        clearInterval(id);
        isPolling = false;
        id = null;
        console.log("Polling stopped");
    }
    else
        console.warn("No polling underway");
}

function polling(generation, size, matrix) {
    data = {generation: generation, size: size, matrix: matrix};
    console.log("Polling");
    fetch('compute', {
        method: 'POST',
        mode: 'cors',
        cache: 'no-cache',
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
        },
        redirect: 'follow', // manual, *follow, error
        referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
        body: JSON.stringify(data) // body data type must match "Content-Type" header
    });
}
