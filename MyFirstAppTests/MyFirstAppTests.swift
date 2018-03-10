//
//  MyFirstAppTests.swift
//  MyFirstAppTests
//
//  Created by Ta Nguyen on 2018/02/08.
//  Copyright © 2018 Ta Nguyen. All rights reserved.
//

import XCTest
@testable import MyFirstApp

class MyFirstAppTests: XCTestCase {
    //MARK: Picture Class Tests
    func testPictureInitSucceeds() {
        // Zero rating
        let zeroRatingPicture = Picture.init(name: "Zero", photo: nil, rating: 0, position: 1)
        XCTAssertNotNil(zeroRatingPicture)
        
        // Highest positive rating
        let positiveRatingPicture = Picture.init(name: "Positive", photo: nil, rating: 5, position: 1)
        XCTAssertNotNil(positiveRatingPicture)
    }
    
    func testPictureInitializationFails() {
        // Negative rating
        let negativeRatingPicture = Picture.init(name: "Negative", photo: nil, rating: -1, position: 1)
        XCTAssertNil(negativeRatingPicture)
        
        // Rating exceeds maximum
        let largeRatingPicture = Picture.init(name: "Large", photo: nil, rating: 6, position: 1)
        XCTAssertNil(largeRatingPicture)
        
        // Empty String
        let emptyStringPicture = Picture.init(name: "", photo: nil, rating: 0, position: 1)
        XCTAssertNil(emptyStringPicture)
    }
}
