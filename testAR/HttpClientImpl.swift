//
//  File.swift
//  FPVDemo
//
//  Created by 高橋剛 on 2018/12/18.
//  Copyright © 2018年 DJI. All rights reserved.
//

import UIKit

public class HttpClientImpl {
    
    private let session: URLSession
    
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    public func execute(request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var d: Data? = nil
        var r: URLResponse? = nil
        var e: Error? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session
            .dataTask(with: request) { (data, response, error) -> Void in
                d = data
                r = response
                e = error
                semaphore.signal()
            }
            .resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return (d, r, e)
    }
}
