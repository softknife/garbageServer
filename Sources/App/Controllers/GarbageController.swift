//
//  GarbageController.swift
//  App
//
//  Created by Reed on 2019/8/7.
//
import Vapor
import HTTP
import Fluent

typealias StringDict = [String:String]
final class GarbageController:RouteCollection{
    
    
    func boot(router: Router) throws {
        
        let group = router.grouped("garbage")
        
        group.get("category", use: getCategoryInfo)
        group.get("info", use: findGarbage)
        group.get("translate", use: translate)
    }
}


extension GarbageController{
    
    private func getCategoryInfo(_ req:Request) throws -> Future<Response>{
        
        
       // 垃圾分类，0 为可回收、1 为有害、2 为厨余(湿)、3 为其他(干)

       let list =  [
            [
                "id": "0",
                "name": "ཕྱིར་བསྡུ་ཐ",
                "name_zh": "可回收物",
                "explain": "ཤོག་སྙིགས་དང་། འགྱིག་སྙིགས་དང་། ཤེལ་སྙིགས་ཀྱི་གྲུབ་རྫས། ལྕགས་རིགས་རོ་མ། ཐགས་རོ་སོགས་ཚུར་བསྡུ་རྒྱུར་འཚམ་པ་དང་རྒྱུན་འཁོ",
                "explain_zh":"废纸张、废塑料、废玻璃制品、废金属、废织物等适宜回收、可循环利用的生活废弃物",
                "require": "ལས་སླ་པོར་འཕེན་པ། གཙང་ཞིང་སྐམ་ཤས་ཆེ་བས་སྦགས་བཙོག་མི་ཡོང་བ་བྱེད་དགོས། ཤོག་སྙིགས་ཁོད་སྙོམས་བཟོ་གང་ཐུབ་བྱེད་པ། ལངས་གཟུགས་ཐུམ་སྒྲིལ་དངོས་པོ་རྣམས་ནང་དོན་དངོས་པོ་རྣམས་གཙང་མ་བཟོ་དགོས་པ་དང་། རྣོ་ངར་ཅན་གྱི་ཟུར་དང་། ",
                "require_zh":"轻投轻放；清洁干燥，避免污染；废纸尽量平整；立体包装物请清空内容物，清洁后压扁投放；有尖锐边角的，应包裹后投放",
                "common": "ཚགས་པར་དང་། ཤོག་སྒམ། དཔེ་དེབ། ཤོག་སྒམ། འགྱིག་སྒམ། རྩེད་ཆས། སྣུམ་ཟོམ། བཞོ་སྣོད་། ཟས་རིགས་སོས་ཉར་སྒམ། གོས་སྒྲོམ། ཆང་སྣོད། རྫ་མ། སླང་མ། གཅུས་གྲི། གྱོན་ཆས། ཁུ་ལུའི་རྩེད་ཆས། གློག་ལམ་པང་ལེབ། པང་ལེབ། བསྒར་ཁ",
                "common_zh":"报纸、纸箱、书本、纸袋、塑料瓶、玩具、油桶、乳液罐、食品保鲜盒、衣架、酒瓶、玻璃杯、易拉罐、锅、螺丝刀、皮鞋、衣物、包、毛绒玩具、电路板、砧板、插座"
            ],
            [
                "id": "1",
                "name": "གནོད་ལྡན་ག",
                "name_zh": "有害垃圾",
                "explain": "མིའི་ལུས་ཁམས་བདེ་ཐང་ངམ་རང་བྱུང་ཁོར་ཡུག་ལ་ཐད་ཀར",
                "explain_zh":"对人体健康或自然环境造成直接或潜在的危害废弃物。",
                "require": "གློག་གསོག་གློག་སྨན་དང་། སྣུམ་ཟོ་དང་འབུ་གསོད་སྨན་རྫས་ལྷག་ལུས་ཡོད་ན་ཁ་དམ་པོར་རྒྱག་དགོས། ཁུན་མིང་དང་ནུས་རྒྱུ་བསྲི་ཚགས་ཀྱི་གློག་སྒྲོན། བེད་མེད་དུ་གྱུར་པའི་སྨན་རྫས་",
                "require_zh":"充电电池、纽扣电池、蓄电池投放时应注意轻放；油漆桶、杀虫剂如有残留请密闭后投放；荧光灯、节能灯易破损连带包装或包裹后投放；废药品及其包装一并投放",
                "common": "གློག་སྨན་རིགས་དང་། ཁུན་ཀོན་སྦུ་གུའི་རིགས། དུས་ཡོལ་སྨན་རྫས། སྨན་རྫས་ཐུམ་སྒྲིལ། དུས་ཡོལ་སེན་སྣུམ་དང་། སེན་ཆུ། སྐྲ་རྩི་བྱུགས་རྫས་ཀྱི་ཕྱི་ཤུབས། བེད་མེད་དུ་བསྐྱུར་བའི་སྣུམ་ཟོམ། དངུལ་ཆུ་ལུས་དྲོད་དཔྱད་ཆས་/ཁྲག་ཤེད་དཔྱད་ཆས། དུག་སེལ་སྨན། བྱི་བ་གསོད་སྨན། འབུ་གསོད་སྨུག་པ། Xའོད་ལེབ། འདྲ་པར་གྱི་སྤྱ",
                "common_zh":"电池类、荧光灯管类、过期药物、药品包装、过期指甲油、指甲水、染发剂壳、废油漆桶、水银体温计/血压计、消毒剂、老鼠药、杀虫喷雾、X光片、相片底片"

            ],
            [
                "id": "2",
                "name": "རློན་",
                "name_zh": "湿垃圾",
                "explain": "ས་ཁུལ་ཁ་ཤས་སུ་ཐབ་ཚང་ལྷག་",
                "explain_zh":"部分地区又称”厨余垃圾”，日常生活垃圾产生的容易腐烂的生物质废物。",
                "require": "ཐབ་ཚང་གི་གད་སྙིགས་ལ་ཆུ་སྙིགས་སྐམ་རྗེས་སླར་ཡང་གཏོང་དགོས་པ་དང་ཐུམ་སྒྲིལ་དངོས་པོ་བཏོན་རྗེས་རིགས་དབྱེ་ནས་གཏོང་དགོས་པ། བེ་ཏའི་ཕྱི་ཤུན་ཆེན་པོ་དང་སེ་འབྲུའི་ཕྱི་ཤུན་སོགས་སྐྱེ་དངོས་རྫས་འགྱུར་དང་དབྱེ་ཕྲལ་བྱེད་དཀའ་བར་གྱུར་ནས་གད་སྙིགས་སྐམ་པོ་ཞིག་ཏུ་བརྩིས་ནས་གཏོང་གི་ཡོད། གཤེར་གཟུགས་རྐྱང་བ་(ད",
                "require_zh":"餐厨垃圾应沥干水分后再投放，有包装物的应取出后分类投放；大块骨头和椰子壳，榴莲壳等不易生化降解，作为干垃圾进行投放；纯液体（如牛奶等），可直接倒入下水口",
                "common": "ཟས་ལྷག་དང་། བག་ལེབ། བྱ་ཤ། འབྲས་དང་སྲན་མའི་རིགས། སྔོ་ཚལ། མེ་ཏོགབག་ལེབ་བག་ལེབ། སྲོག་ཆགས་ཀྱི་ནང་ཁྲོལ། ཀུ་ཤུའི་སྙིང་། སྒོ་ང་དང་སྒོང་ང་། འབྲས་དང་སྲན་མའི་རིགས། ཀྲུང་ལུགས་སྨན་སྙིགས། གཅེས་ཉར་སྲོག་ཆག",
                "common_zh":"剩饭剩菜、面包、鸡肉、干果仁、蔬菜、花卉、蛋糕饼干、动物内脏、苹果核、鸡蛋及蛋壳、大米及豆类、中药药渣、宠物饲料"

            ],
            [
                "id": "3",
                "name": "སྐམ་ས",
                "name_zh": "干垃圾",
                "explain": "ས་ཁུལ་ཁ་ཤས་སུ་གད་སྙིགས་གཞན་པའང་ཟེར”ཞེས་པ་དང་། གནོད་ལྡན་གད་སྙིགས་དང་། ཚུར་སྡུད་ཆོག་པའི་དངོས་རྫས། རློན་པའི་གད་སྙི",
                "explain_zh":"部分地区又称”其他垃圾”，除有害垃圾、可回收物、湿垃圾以外的生活废弃物",
                "require": "གང་ཐུབ་ཀྱིས་ཆུ་སྐམ་དུ་འཇུག་དགོས། འཚོ་བའི་",
                "require_zh":"尽量沥干水分；难以辨别的生活垃圾应投入干垃圾容器内",
                "common": "ཟས་ཕྱིས་ཤོག་བུ་དང་། ཤོག་ཕྱིས་དང་། ཤོག་བུའི་གཅིན་དོར་དང་། ཐ་མག་དང་། ཐ་མག་དང་། རྫ་མ། འགྱིག་འདམ། རྨ་ཁ། སྨྱུག་གུས་སྐྱ། མིག་ཤེལ། སྐྲ་དང་། ནང་ལྭ",
                "common_zh":"餐巾纸、纸巾、纸尿裤、烟蒂、陶瓷花盆、胶带、橡皮泥、创可贴、笔、灰土、眼镜、头发、内衣裤、防碎气泡膜、旧毛巾、污损纸张、塑料袋"

            ]
        ]
        
        return try ResponseJSON<[StringDict]>(data: list).encode(for: req)

        
    }
}

//import FluentSQLite
//
//
//struct Detail  : Codable,Content {
//    var name: String?
//    var type: Int = 0
//    var aipre: Int = 0
//    var explain: String?
//    var contain: String?
//    var tip: String?
//
////    static var defaultContentType: MediaType {
////        return .html
////    }
//
//}
//
//struct GarbageResult:Codable,Content{
//    var code:Int = 0
//    var msg:String = ""
//    var newList:[Detail]? = nil
//
////    static var defaultContentType: MediaType {
////        return .html
////    }
////    enum CodingKeys:String,CodingKey  {
////        case code = "code"
////        case msg = "msg"
////        case newList = "newList"
////    }
////
//
////    init(from decoder: Decoder) throws {
////        let vals = try decoder.container(keyedBy: CodingKeys.self)
////        code = try vals.decode(Int.self, forKey: CodingKeys.code)
////        msg = try vals.decode(String.self, forKey: CodingKeys.msg)
////
////
////
////    }
//}


extension GarbageController{
    
    private func findGarbage(_ req:Request) throws -> Future<Response>{

        /*

         https://laji.lr3800.com/api.php?name=
         调用方式：HTTP post get
         name = 关键字
         例子： https://laji.lr3800.com/api.php?name=槟榔
         返回参数 type=0

         垃圾分类，0 为可回收、1 为有害、2 为厨余(湿)、3 为其他(干)

         
         https://quark.sm.cn/api/quark_sug?q=烧烤签是什么垃圾
         */
        
        
        let name = try req.query.get(String.self, at: "name")
        guard  let encodingString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)  else {
            return try ResponseJSON<Empty>(status: .error,message: "参数'name'为空").encode(for: req)
        }

        let httpReq = HTTPRequest(
                                method: .GET,
                                url: "/api.php?name=\(encodingString)",
                                headers: [
                                    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3" ,
                                    "accept-encoding":"gzip, deflate, br",
                                    "accept-language":"zh-CN,zh;q=0.9,en;q=0.8",
                                    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36"])

        let client = HTTPClient.connect(scheme:.https,hostname: "laji.lr3800.com",port: 443, on: req)
        let httpRes = client.flatMap(to: HTTPResponse.self) { client in
            return client.send(httpReq)
        }

        return httpRes.flatMap{ (httpRes) -> EventLoopFuture<Response> in

            print(httpRes)
            return try Response(http: httpRes, using: req).encode(for: req)
        }
//

//        print("httpRes-future:\(httpRes)")
//        let data = httpRes.flatMap(to: GarbageResult.self) { httpResponse in
//            print("httpres:\(httpResponse)")
//            let response = Response(http: httpResponse, using: req)
//            print("response:\(response)")
//
//            return try response.content.decode(GarbageResult.self)
//        }
//
//        data.map { (garbage)  in
//            print(garbage)
//        }
//
//        return try data.encode(for: req)

    }
}


extension GarbageController{
    
    private func translate(_ req:Request) throws -> Future<Response>{
        
        let name = try req.query.get(String.self, at: "name")
        
        let body = ["from":"zh","to":"zw","src_text":name]
        let param = try JSONEncoder().encode(body)
        let httpReq = HTTPRequest(method: .POST, url: "/translate/trans", headers: ["Accept": "application/json, text/javascript, */*; q=0.01",
                                                                                    "Content-Type": "application/json;charset=UTF-8",
                                                                                    "Referer": "http://www.mzywfy.org.cn/mainIndex.jsp",
                                                                                    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36"]
            , body: HTTPBody(data: param) )
        
        let client = HTTPClient.connect(scheme:.http,hostname: "218.241.146.94",port: 8989, on: req)
        let httpRes = client.flatMap(to: HTTPResponse.self) { client in
            return client.send(httpReq)
        }
        
        return httpRes.flatMap{ (httpRes) -> EventLoopFuture<Response> in

            print(httpRes)
            return try Response(http: httpRes, using: req).encode(for: req)
        }

    }
}
