//
//  Response.swift
//  Regions
//
//  Created by Ersan Shimshek on 30.08.2023.
//

import Foundation

//MARK: Retrieved Models

struct Response: Codable {
    let brands: [Brand]
}

struct Brand: Codable {
    let title: String
    let thumbUrls: [String]
    let viewsCount: Int
    let brandId: String
    
}
