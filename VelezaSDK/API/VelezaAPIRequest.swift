//
//  VelezaAPIRequest.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 14/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import Foundation

class VelezaAPIRequest {
    
    var method = "GET"
    var path = "/"
    var params: [String: String] = [:]
    
    public init(withMethod method: String, path: String, params: [String: String]?) {
        self.method = method
        self.path = path
        if let p = params {
            self.params = p
        }
    }
    
    fileprivate func addDefaultParams() -> [String: String] {
        return [
            "platform" : "widget-ios",
            "device" : "mobile",
            "lang" : Bundle.main.preferredLocalizations.first ?? "en",
            "client_id" : VelezaSDK.clientId!,
        ]
    }
    
    fileprivate func urlFor(path: String, withParameters params: [String: String]) -> URL {
        var query: [String] = []
        
        var _params: [String: String] = [:]
        
        var host = "https://widgets.veleza.com"
        var _path = String(format:(path.hasPrefix("//") ? "https:%@" : "http://url.com/%@"), path)
        if let _url = URL(string: _path) {
            
            if _url.host != "url.com" {
                host = String(format: "%@://%@", _url.scheme!, _url.host!)
            }
            _path = _url.path
            
            if let urlComponents = URLComponents(url: _url, resolvingAgainstBaseURL: false) {
                if let queryItems = urlComponents.queryItems {
                    for item in queryItems {
                        if (item.value != nil) {
                            _params[item.name] = item.value
                        }
                        else {
                            _params[item.name] = "1"
                        }
                    }
                }
            }
        }
        else {
            _path = path
        }

        _params += addDefaultParams()
        _params += params
        _params.forEach {
            query.append(String(format: "%@=%@", $0, $1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!))
        }
        
        if _path.hasPrefix("/") {
            _path = String(_path[path.index(_path.startIndex, offsetBy: 1)...])
        }
        
        return URL(string: String(format: "%@/%@?%@", host, _path, query.joined(separator: "&")))!
    }
    
    fileprivate func handleResponseError(_ error: Error?, inResponse response: URLResponse?) -> Error? {
        return nil
    }
    
    public func execute(onSuccess success: @escaping (_ data: [Any], _ items: [Any], _ response: [String: Any]) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {

        var request: NSMutableURLRequest? = nil
        if method.uppercased() == "GET" {
            let url = urlFor(path: path, withParameters: params)
            request = NSMutableURLRequest(url: url)
        }
        else {
            let url = urlFor(path: path, withParameters: [:])
            request = NSMutableURLRequest(url: url)
            request?.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request?.httpMethod = method
        URLSession.shared.dataTask(with: request! as URLRequest) { (data, response, error) in
            if let responseError = self.handleResponseError(error, inResponse: response) {
                DispatchQueue.main.async {
                    failure(responseError)
                }
                return
            }
            
            if let object = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) {
                if let _object = object as? [String: Any] {
                    let data = _object["data"] as? [Any]
                    let items = _object["results"] as? [Any]
                    DispatchQueue.main.async {
                        success(data ?? [], items ?? [], _object)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                failure(nil)
            }
        }.resume()
    }

}
