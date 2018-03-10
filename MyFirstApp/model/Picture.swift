//
//  Picture.swift
//  MyFirstApp
//
//  Created by Ta Nguyen on 2018/03/01.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import UIKit
import os.log

class Picture: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    var position: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pictures")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let position = "position"
    }
    
    init?(name: String, photo: UIImage?, rating: Int, position: Int) {
        /// The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        guard (position >= 0) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.position = position
    }
    
    //MARK: NSCoding
    //encodeWithCoder
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(position, forKey: PropertyKey.position)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Picture object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Picture, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        let position = aDecoder.decodeInteger(forKey: PropertyKey.position)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, position: position)
    }
}

