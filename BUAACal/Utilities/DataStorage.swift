//
//  DataStorage.swift
//  BUAACal
//
//  Created by roife on 10/16/20.
//

import Foundation

public struct DataStorage {
    public typealias dictDataType = [Date:[CalendarEvent<CalendarEventDataModel>]]
    
    public static func saveData(data: dictDataType) {
        let standard = UserDefaults.standard
        standard.set(object: data, forKey: "SavedCourses")
        standard.synchronize()
    }

    public static func loadData() -> dictDataType {
        return UserDefaults.standard.object(dictDataType.self, with: "SavedCourses") ?? [:]
    }
    
    public static func saveUserId(userId:String) {
        let standard = UserDefaults.standard
        standard.setValue(userId, forKey: "userId")
        standard.synchronize()
    }
    
    public static func loadUserId() -> String {
        return UserDefaults.standard.string(forKey: "userId") ?? ""
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
