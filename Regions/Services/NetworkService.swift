//
//  NetworkService.swift
//  Regions
//
//  Created by Ersan Shimshek on 30.08.2023.
//

import Foundation

class NetworkService {
    //MARK: - Singleton
    public static let shared = NetworkService()
    
    //MARK: - Init
    private init(){}
    
    //Gets regions
    func getRegions(completion: @escaping (Response) -> Void) {
        let url = URL(string: "https://vmeste.wildberries.ru/api/guide-service/v1/getBrands")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data else { return }
            let model = try! JSONDecoder().decode(Response.self, from: data)
            completion(model)
        }.resume()
        
    }
    //Gets preview image
    func getFirstImage(url: String, _ completion: @escaping (Data) -> Void) {
        let request = URLRequest(url: URL(string: url)!)
        
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else { return }
            completion(data)
            
        }.resume()
    }
    
    //Gets images of region
    func getImages(urlArray: [String], _ completion: @escaping ([Data]) -> Void) {
        var imagesArray = [Data]()
        let group = DispatchGroup()
        
        for elem in urlArray {
            let request = URLRequest(url: URL(string: elem)!)
            group.enter()
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data else { return }
                imagesArray.append(data)
                group.leave()
            }.resume()
        }
        group.notify(queue: .global()) {
            completion(imagesArray)
        }
    }
    
}
