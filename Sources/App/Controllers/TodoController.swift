import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}

/*
 
 {
 "reason": "success",
 "result": [
 {
 "id": "1",
 "name": "ཕྱིར་བསྡུ་ཐ",
 "explain": "ཤོག་སྙིགས་དང་། འགྱིག་སྙིགས་དང་། ཤེལ་སྙིགས་ཀྱི་གྲུབ་རྫས། ལྕགས་རིགས་རོ་མ། ཐགས་རོ་སོགས་ཚུར་བསྡུ་རྒྱུར་འཚམ་པ་དང་རྒྱུན་འཁོ",
 "require": "ལས་སླ་པོར་འཕེན་པ། གཙང་ཞིང་སྐམ་ཤས་ཆེ་བས་སྦགས་བཙོག་མི་ཡོང་བ་བྱེད་དགོས། ཤོག་སྙིགས་ཁོད་སྙོམས་བཟོ་གང་ཐུབ་བྱེད་པ། ལངས་གཟུགས་ཐུམ་སྒྲིལ་དངོས་པོ་རྣམས་ནང་དོན་དངོས་པོ་རྣམས་གཙང་མ་བཟོ་དགོས་པ་དང་། རྣོ་ངར་ཅན་གྱི་ཟུར་དང་། ",
 "common": "ཚགས་པར་དང་། ཤོག་སྒམ། དཔེ་དེབ། ཤོག་སྒམ། འགྱིག་སྒམ། རྩེད་ཆས། སྣུམ་ཟོམ། བཞོ་སྣོད་། ཟས་རིགས་སོས་ཉར་སྒམ། གོས་སྒྲོམ། ཆང་སྣོད། རྫ་མ། སླང་མ། གཅུས་གྲི། གྱོན་ཆས། ཁུ་ལུའི་རྩེད་ཆས། གློག་ལམ་པང་ལེབ། པང་ལེབ། བསྒར་ཁ"
 },
 {
 "id": "2",
 "name": "གནོད་ལྡན་ག",
 "explain": "མིའི་ལུས་ཁམས་བདེ་ཐང་ངམ་རང་བྱུང་ཁོར་ཡུག་ལ་ཐད་ཀར",
 "require": "གློག་གསོག་གློག་སྨན་དང་། སྣུམ་ཟོ་དང་འབུ་གསོད་སྨན་རྫས་ལྷག་ལུས་ཡོད་ན་ཁ་དམ་པོར་རྒྱག་དགོས། ཁུན་མིང་དང་ནུས་རྒྱུ་བསྲི་ཚགས་ཀྱི་གློག་སྒྲོན། བེད་མེད་དུ་གྱུར་པའི་སྨན་རྫས་",
 "common": "གློག་སྨན་རིགས་དང་། ཁུན་ཀོན་སྦུ་གུའི་རིགས། དུས་ཡོལ་སྨན་རྫས། སྨན་རྫས་ཐུམ་སྒྲིལ། དུས་ཡོལ་སེན་སྣུམ་དང་། སེན་ཆུ། སྐྲ་རྩི་བྱུགས་རྫས་ཀྱི་ཕྱི་ཤུབས། བེད་མེད་དུ་བསྐྱུར་བའི་སྣུམ་ཟོམ། དངུལ་ཆུ་ལུས་དྲོད་དཔྱད་ཆས་/ཁྲག་ཤེད་དཔྱད་ཆས། དུག་སེལ་སྨན། བྱི་བ་གསོད་སྨན། འབུ་གསོད་སྨུག་པ། Xའོད་ལེབ། འདྲ་པར་གྱི་སྤྱ"
 },
 {
 "id": "3",
 "name": "རློན་",
 "explain": "ས་ཁུལ་ཁ་ཤས་སུ་ཐབ་ཚང་ལྷག་",
 "require": "ཐབ་ཚང་གི་གད་སྙིགས་ལ་ཆུ་སྙིགས་སྐམ་རྗེས་སླར་ཡང་གཏོང་དགོས་པ་དང་ཐུམ་སྒྲིལ་དངོས་པོ་བཏོན་རྗེས་རིགས་དབྱེ་ནས་གཏོང་དགོས་པ། བེ་ཏའི་ཕྱི་ཤུན་ཆེན་པོ་དང་སེ་འབྲུའི་ཕྱི་ཤུན་སོགས་སྐྱེ་དངོས་རྫས་འགྱུར་དང་དབྱེ་ཕྲལ་བྱེད་དཀའ་བར་གྱུར་ནས་གད་སྙིགས་སྐམ་པོ་ཞིག་ཏུ་བརྩིས་ནས་གཏོང་གི་ཡོད། གཤེར་གཟུགས་རྐྱང་བ་(ད",
 "common": "ཟས་ལྷག་དང་། བག་ལེབ། བྱ་ཤ། འབྲས་དང་སྲན་མའི་རིགས། སྔོ་ཚལ། མེ་ཏོགབག་ལེབ་བག་ལེབ། སྲོག་ཆགས་ཀྱི་ནང་ཁྲོལ། ཀུ་ཤུའི་སྙིང་། སྒོ་ང་དང་སྒོང་ང་། འབྲས་དང་སྲན་མའི་རིགས། ཀྲུང་ལུགས་སྨན་སྙིགས། གཅེས་ཉར་སྲོག་ཆག"
 },
 {
 "id": "4",
 "name": "སྐམ་ས",
 "explain": "ས་ཁུལ་ཁ་ཤས་སུ་གད་སྙིགས་གཞན་པའང་ཟེར”ཞེས་པ་དང་། གནོད་ལྡན་གད་སྙིགས་དང་། ཚུར་སྡུད་ཆོག་པའི་དངོས་རྫས། རློན་པའི་གད་སྙི",
 "require": "གང་ཐུབ་ཀྱིས་ཆུ་སྐམ་དུ་འཇུག་དགོས། འཚོ་བའི་",
 "common": "ཟས་ཕྱིས་ཤོག་བུ་དང་། ཤོག་ཕྱིས་དང་། ཤོག་བུའི་གཅིན་དོར་དང་། ཐ་མག་དང་། ཐ་མག་དང་། རྫ་མ། འགྱིག་འདམ། རྨ་ཁ། སྨྱུག་གུས་སྐྱ། མིག་ཤེལ། སྐྲ་དང་། ནང་ལྭ"
 }
 ],
 "code": 0
 }
 
 https://laji.lr3800.com/api.php?name=
 调用方式：HTTP post get
 name = 关键字
 例子： https://laji.lr3800.com/api.php?name=槟榔
 
 返回参数 type=0
 
 垃圾分类，0 为可回收、1 为有害、2 为厨余(湿)、3 为其他(干)
 

 */