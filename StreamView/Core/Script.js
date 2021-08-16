var open = XMLHttpRequest.prototype.open;

XMLHttpRequest.prototype.open = function() {
    this.addEventListener("load", function() {
        var message = {"status" : this.status, "responseURL" : this.responseURL}
        webkit.messageHandlers.handler.postMessage(message);
    });
    open.apply(this, arguments);
};

function logURL(requestDetails) {
    webkit.messageHandlers.handler.postMessage( requestDetails.url);
}

browser.webRequest.onBeforeRequest.addListener(
  logURL,
  {urls: ["<all_urls>"]}
);
