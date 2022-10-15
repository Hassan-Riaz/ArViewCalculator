//
//  UserDefaults.swift
//  Silver-Calculator
//
//  Created by Hassan on 23/08/2022.
//

import Foundation

extension UserDefaults {
    var totalDownloads: Int {
        get {
            UserDefaults.standard.integer(forKey: "totalDownloads")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "totalDownloads")
        }
    }
    
    var downloadPosition: Int {
        get {
            UserDefaults.standard.integer(forKey: "downloadPosition")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "downloadPosition")
        }
    }
    
    var limit: String {
        get {
            UserDefaults.standard.string(forKey: "limit") ?? "10,000"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "limit")
        }
    }
    
    var isRelaunching: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isRelaunching")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isRelaunching")
        }
    }
    
    
}
