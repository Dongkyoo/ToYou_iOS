//
//  User.swift
//  ToYou_iOS
//
//  Created by dongkyoo on 2020/02/02.
//  Copyright © 2020 dongkyoo. All rights reserved.
//

import Foundation
import Firebase

public class User: Codable {
    
    // 아이디(이메일)
    var id: String!
    
    // 휴대폰 번호
    var phoneNumber: String!
    
    // 이름
    var name: String!
    
    // 파트너
    var partner: User?
    
    // 가입일시
    var createdAt: Date
    
    // 성별
    var gender: Gender!
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber
        case name
        case partner
        case createdAt
        case gender
    }
    
    init() {
        self.id = ""
        self.phoneNumber = ""
        self.name = ""
        self.partner = nil
        self.createdAt = Date()
        self.gender = .male
    }
    
    init(id: String?, phoneNumber: String?, name: String?, partner: User?, createdAt: Date, gender: Gender?) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.name = name
        self.partner = partner
        self.createdAt = createdAt
        self.gender = gender
    }
    
    init(_ map: [String: Any]) {
        self.id = map["id"] as? String
        self.phoneNumber = map["phoneNumber"] as? String
        self.name = map["name"] as? String
        self.partner = map["partner"] as? User
        if let timestamp = map["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }

        self.gender = Gender(rawValue: map["gender"] as? Int ?? 0)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //        self.id = (try? values.decode(String.self, forKey: .id)) ?? ""
                self.id = try values.decode(String.self, forKey: .id)
                self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
                self.name = try values.decode(String.self, forKey: .name)
                self.partner = try? values.decode(User.self, forKey: .partner)
                self.createdAt = try values.decode(Date.self, forKey: .createdAt)
                self.gender = try values.decode(Gender.self, forKey: .gender)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(name, forKey: .name)
        try container.encode(partner, forKey: .partner)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(gender, forKey: .gender)
    }
    
    public func decode() -> [String: Any] {
        var map = [String: Any]()
        map["id"] = id
        map["phoneNumber"] = phoneNumber
        map["name"] = name
        map["partner"] = partner
        map["createdAt"] = createdAt
        map["gender"] = gender == Gender.male ? 1 : 0
        return map
    }
}
