//
//  ResponseJSON.swift
//  App
//
//  Created by Reed on 2019/7/5.
//

import Foundation

import Vapor

struct Empty: Content {}

struct ResponseJSON<T: Content>: Content {
    
    private var status: ResponseStatus
    private var message: String
    private var data: T?
    
    init(data: T) {
        self.status = .ok
        self.message = status.desc
        self.data = data
    }
    
    init(status:ResponseStatus = .ok) {
        self.status = status
        self.message = status.desc
        self.data = nil
    }
    
    
    init(status:ResponseStatus = .ok,
         message: String = ResponseStatus.ok.desc) {
        self.status = status
        self.message = message
        self.data = nil
    }
    
    init(status:ResponseStatus = .ok,
         message: String = ResponseStatus.ok.desc,
         data: T?) {
        self.status = status
        self.message = message
        self.data = data
    }
}


enum ResponseStatus:Int,Content {
    case ok = 0
    case error = 1
    case missesPara = 3
    case token = 4
    case unknown = 10
    case userExist = 20
    case userNotExist = 21
    case passwordError = 22
    case pictureTooBig = 30
    
    var desc : String {
        switch self {
        case .ok:
            return "请求成功"
        case .error:
            return "请求失败"
        case .missesPara:
            return "缺少参数"
        case .token:
            return "Token 已失效，请重新登录"
        case .unknown:
            return "未知失败"
        case .userExist:
            return "用户已存在"
        case .userNotExist:
            return "用户不存在"
        case .passwordError:
            return "密码不正确"
        case .pictureTooBig:
            return "图片太大，需要压缩"
        }
        
    }
    
}



//public let CrawlerHeader: HTTPHeaders = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
//    ,"Cookie": "__cfduid=d8965f82364956ea3ab8feea035d0f9761565254256"]
//
//
//func getHTMLResponse(_ req:Request,url: String) throws -> Future<String> {
//
//    return try req.client().get(url,headers: CrawlerHeader).map {
//        return $0.utf8String
//    }
//}
//
//
//
//extension Response {
//
//    var utf8String: String {
//        return String(data: self.http.body.data ?? Data(), encoding: .utf8) ?? "n/a"
//    }
//
////    func convertGBKString(_ req: Request) throws -> Future<String> {
////
////        let iconv = try Iconv(from: Iconv.CodePage.GBK, to: Iconv.CodePage.UTF8)
////
////        return http.body.consumeData(on: req) // 1) read complete body as raw Data
////            .map { (data: Data) -> String in
////                var bytes = [UInt8](repeating: 0, count: data.count)
////                let buffer = UnsafeMutableBufferPointer(start: &bytes, count: bytes.count)
////                _ = data.copyBytes(to: buffer)
////
////                let utf8Bytes = iconv.convert(buf: bytes) // !
////                let utf8String = String(bytes: utf8Bytes, encoding: .utf8) // !
////                return utf8String ?? "g/u"
////        }
////    }
//}
