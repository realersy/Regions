//
//  LikeService.swift
//  Regions
//
//  Created by Ersan Shimshek on 31.08.2023.
//

import Foundation

class LikeService {
    public static let shared = LikeService()
    
    //Keeps unique brand ID inside a set
    private init(){}
    
    var likedIds = Set<String>()
}
