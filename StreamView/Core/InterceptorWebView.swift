//
//  InterceptorWebView.swift
//  StreamView
//
//  Created by Dark Matter on 16/08/21.
//

import Foundation
import WebKit
class InterceptorWebView : WKWebView{
    let handlerCallback = MessageHandler()
    private let handler = "handler"
    private var isInititated : Bool = false
    var interceptDelegate : (_ url : String) -> Void = {_ in }
    private func getScript() -> String {
            if let filepath = Bundle.main.path(forResource: "Script", ofType: "js") {
                do {
                    return try String(contentsOfFile: filepath)
                } catch {
                    print(error)
                }
            } else {
                print("script.js not found!")
            }
            return ""
        }
    func setup(){
        if isInititated {
            return
        }
        let prefs = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            prefs.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
        }
        handlerCallback.interceptDelegate = interceptDelegate
        configuration.defaultWebpagePreferences = prefs
        let userScript = WKUserScript(source: self.getScript(), injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(userScript)
        configuration.userContentController.add(handlerCallback, name : handler)
        isInititated = true
    }
    func loadUrl(url : URL?){
        setup()
        
        guard let url = url else{
            return
        }
        let request = URLRequest(url: url)
        load(request)
    }
 
   
    
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dict = message.body as? Dictionary<String, AnyObject>, let status = dict["status"] as? Int, let responseUrl = dict["responseURL"] as? String {
            print(status)
            print(responseUrl)
        }
    }
   
    class MessageHandler : NSObject, WKScriptMessageHandler{
        var interceptDelegate : (_  url : String) -> Void = {_ in }
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            //print("MEssage =>>>>> \(message.name)")
           
            if let data = message.body as? [String:Any],let responseUrl = data["responseURL"] as? String{
              //  print("MEssage =>>>>> \(responseUrl)")
                interceptDelegate( responseUrl)
            }
        }
    }
}
protocol InterceptorDelegate{
    func onLoadRequest(url:String)
}
