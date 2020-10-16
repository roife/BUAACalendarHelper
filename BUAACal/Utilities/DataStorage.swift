//
//  DataStorage.swift
//  BUAACal
//
//  Created by 吴家焱 on 10/16/20.
//

import Foundation

public struct DataStorage {
    public static func saveData(data: [Date:[CalendarEvent<CalendarEventDataModel>]]) {
        let standard = UserDefaults.standard
        standard.set(object: data, forKey: "SavedCourses")
        standard.synchronize()
    }

    public static func loadData() -> [Date:[CalendarEvent<CalendarEventDataModel>]] {
        let standard = UserDefaults.standard
        
        guard let data = standard.object([Date:[CalendarEvent<CalendarEventDataModel>]].self,
                                         with: "SavedCourses") else {
            return [:]
        }
        
        return data
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
