//
//  Utils.swift
//  MyFirstApp
//
//  Created by Ta Nguyen on 2018/02/12.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import Foundation


class Utils {
    static func loadPictures() -> [Picture]? {
        let positionSortDescriptor = NSSortDescriptor(key: "position", ascending: false)
        let pictures = NSKeyedUnarchiver.unarchiveObject(withFile: Picture.ArchiveURL.path) as? [Picture]
        
//        return ((pictures! as NSArray).sortedArray(using: [positionSortDescriptor]) as! [Picture])
        return pictures
    }
}
