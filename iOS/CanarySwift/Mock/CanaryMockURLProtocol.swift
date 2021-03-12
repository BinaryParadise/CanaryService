//
//  CanaryMockURLProtocol.swift
//  Canary
//
//  Created by Rake Yang on 2020/12/15.
//

import Foundation

public let CanaryMockedNotification = "Canary.MockedNotification"
public let CanaryOriginURLKey = "Canary.OriginURLKey"
public let CanaryMockedURLKey = "Canary.MockedURLKey"

@objc public class CanaryMockURLProtocol: URLProtocol {
    
    struct Constants {
        static let RequestHandledKey = "MockURLProtocolHandledKey"
    }
  
    var session: URLSession?
    var sessionTask: URLSessionDataTask?
    var receiveData: Data?
    var mockedURL: URL?
    @objc public static var isEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "Canary.MockEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Canary.MockEnabled")
            if newValue {
                URLProtocol.registerClass(self)
                URLSessionConfiguration.setupSwizzledSessionConfiguration()
            } else {
                URLProtocol.unregisterClass(self)
            }
        }
    }
  
  override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
    super.init(request: request, cachedResponse: cachedResponse, client: client)
    
    if session == nil {
      session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }
  }
    
    public override class func canInit(with task: URLSessionTask) -> Bool {
        guard let request = task.currentRequest else { return false }
        return canInit(with: request)
    }
  
  override public class func canInit(with request: URLRequest) -> Bool {
    if URLProtocol.property(forKey: Constants.RequestHandledKey, in: request) as? Bool ?? false {
        return false;
    }
    if isEnabled && ["http", "https"].contains(request.url?.scheme ?? "") {
        return MockManager.shared.checkIntercept(for: request).should
    }
    return false
  }
  
  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override public func startLoading() {
    
    guard let newRequest = ((request as NSURLRequest).mutableCopy() as? NSMutableURLRequest) else {
      return
    }
    URLProtocol.setProperty(true, forKey: Constants.RequestHandledKey, in: newRequest)
    newRequest.url = MockManager.shared.checkIntercept(for: newRequest as URLRequest).url
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CanaryMockedNotification), object: nil, userInfo: [CanaryOriginURLKey: request.url, CanaryMockedURLKey: newRequest.url])
    receiveData = Data()
    sessionTask = session?.dataTask(with: newRequest as URLRequest)
    sessionTask?.resume()
  }
  
  override public func stopLoading() {
    sessionTask?.cancel()
    sessionTask = nil
    self.session?.invalidateAndCancel()
    receiveData = nil
   }
  
}

extension CanaryMockURLProtocol: URLSessionDataDelegate {
  
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    receiveData?.append(data)
    client?.urlProtocol(self, didLoad: data)
  }
  
  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    completionHandler(.allow)
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    //接口日志收集
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.alamofire.networking.task.complete"), object: task, userInfo: ["com.alamofire.networking.complete.finish.responsedata": receiveData])
    if let error = error {
      client?.urlProtocol(self, didFailWithError: error)
    } else {
      client?.urlProtocolDidFinishLoading(self)
    }
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
    client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
    completionHandler(request)
  }
  
  public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    guard let error = error else { return }
    client?.urlProtocol(self, didFailWithError: error)
  }
  
  public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    let protectionSpace = challenge.protectionSpace
    let sender = challenge.sender
    
    if protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
      if let serverTrust = protectionSpace.serverTrust {
        let credential = URLCredential(trust: serverTrust)
        sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
        return
      }
    }
    if protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
      completionHandler(.performDefaultHandling, nil);
      return
    }
  }
  
  public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    client?.urlProtocolDidFinishLoading(self)
  }
}

extension InputStream {
  
  func readfully() -> Data {
    var result = Data()
    var buffer = [UInt8](repeating: 0, count: 10 * 1024 * 1024)
    
    open()
    
    var amount = 0
    repeat {
      amount = read(&buffer, maxLength: buffer.count)
      if amount > 0 {
        result.append(buffer, count: amount)
      }
    } while amount > 0
    
    close()
    
    return result
  }
}

/// swift swizzle：https://gist.github.com/kashiftriffort/b5f6d2db595ff16dfc00f20cc9305736
extension URLSessionConfiguration {
  
  @objc static func setupSwizzledSessionConfiguration() {    
    guard self == URLSessionConfiguration.self else {
      return
    }
    
    let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))
    let swizzledDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.swizzledDefaultSessionConfiguration))
    method_exchangeImplementations(defaultSessionConfiguration!, swizzledDefaultSessionConfiguration!)
    
    let ephemeralSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.ephemeral))
    let swizzledEphemeralSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.swizzledEphemeralSessionConfiguration))
    method_exchangeImplementations(ephemeralSessionConfiguration!, swizzledEphemeralSessionConfiguration!)
  }
  
  @objc class func swizzledDefaultSessionConfiguration() -> URLSessionConfiguration {
    let configuration = swizzledDefaultSessionConfiguration()
    if CanaryMockURLProtocol.isEnabled {
        configuration.protocolClasses?.removeFirst(where: { (cls) -> Bool in
            return cls == CanaryMockURLProtocol.self
        })
        configuration.protocolClasses?.insert(CanaryMockURLProtocol.self, at: 0)
    }
    return configuration
  }
  
  @objc class func swizzledEphemeralSessionConfiguration() -> URLSessionConfiguration {
    let configuration = swizzledEphemeralSessionConfiguration()
    if CanaryMockURLProtocol.isEnabled {
        configuration.protocolClasses?.removeFirst(where: { (cls) -> Bool in
            return cls == CanaryMockURLProtocol.self
        })
        configuration.protocolClasses?.insert(CanaryMockURLProtocol.self, at: 0)
    }
    return configuration
  }
}
