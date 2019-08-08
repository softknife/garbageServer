//
//  Const.swift
//  App
//
//  Created by Reed on 2019/8/8.
//

import Vapor

public let CrawlerHeader: HTTPHeaders = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"
    ,"Cookie": "__cfduid=d8965f82364956ea3ab8feea035d0f9761565254256"]


func getHTMLResponse(_ req:Request,url: String) throws -> Future<String> {

    return try req.client().get(url,headers: CrawlerHeader).map {
        return $0.utf8String
    }
}



extension Response {
    
    var utf8String: String {
        return String(data: self.http.body.data ?? Data(), encoding: .utf8) ?? "n/a"
    }
    
//    func convertGBKString(_ req: Request) throws -> Future<String> {
//
//        let iconv = try Iconv(from: Iconv.CodePage.GBK, to: Iconv.CodePage.UTF8)
//
//        return http.body.consumeData(on: req) // 1) read complete body as raw Data
//            .map { (data: Data) -> String in
//                var bytes = [UInt8](repeating: 0, count: data.count)
//                let buffer = UnsafeMutableBufferPointer(start: &bytes, count: bytes.count)
//                _ = data.copyBytes(to: buffer)
//
//                let utf8Bytes = iconv.convert(buf: bytes) // !
//                let utf8String = String(bytes: utf8Bytes, encoding: .utf8) // !
//                return utf8String ?? "g/u"
//        }
//    }
}
