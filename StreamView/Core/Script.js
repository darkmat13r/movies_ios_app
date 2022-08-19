var open = XMLHttpRequest.prototype.open;

XMLHttpRequest.prototype.open = function() {
    autoScrolling() 
    this.addEventListener("load", function() {
        console.log(this)
        var message = {"status" : this.status, "responseURL" : this.responseURL}
        webkit.messageHandlers.handler.postMessage(message);
    });
    this.addEventListener("ready", function() {
        console.log(this)
        var message = {"status" : this.status, "responseURL" : this.responseURL}
        webkit.messageHandlers.handler.postMessage(message);
    });
    open.apply(this, arguments);
};

function logURL(requestDetails) {
    webkit.messageHandlers.handler.postMessage( requestDetails.url);
}
function autoScrolling() {
   window.scrollTo(0,document.body.scrollHeight);
}

window.onload=function () {
    autoScrolling()
}
browser.webRequest.onBeforeRequest.addListener(
  logURL,
  {urls: ["<all_urls>"]}
);
