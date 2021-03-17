//
//  StorageHandler.swift
//  DrawingApp-Final
//
//  Created by Travis Mayer on 12/15/20.
//

import Foundation
import PencilKit

struct StorageHandler {
    static var defaultStorage: UserDefaults = UserDefaults.standard
    
    static func getStorage(key: String) -> [PKDrawing] {
        var drawingArray: [Data]
        var drawings: [PKDrawing] = []
        var drawing = PKDrawing()
        
        if isSet(key: key) {
            drawingArray = UserDefaults.standard.dictionaryRepresentation()[key] as! [Data]
            for element in drawingArray {
                do {
                    //print(element)
                    try drawing = PKDrawing.init(data: element)
                    drawings.append(drawing)
                } catch {
                    print("Error getting drawing object")
                }
                
            }
        } else {
            drawings = []
        }
        return drawings
    }
    
    static func isSet(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    static func set(value: PKDrawing) {
        let val = value.dataRepresentation()
        var drawingArray: [Data]
        
        if isSet(key: "drawings") {
            drawingArray = UserDefaults.standard.dictionaryRepresentation()["drawings"] as! [Data]
            drawingArray.append(val)
        } else {
            drawingArray = [val]
        }
        defaultStorage.set(drawingArray, forKey: "drawings")
    }
    
    static func storageCount() -> Int{
        if isSet(key: "drawings") {
            let drawingArray: [Data] = UserDefaults.standard.dictionaryRepresentation()["drawings"] as! [Data]
            return drawingArray.count
        } else {
            return 0
        }
    }
    
}
