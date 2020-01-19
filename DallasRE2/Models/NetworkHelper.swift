//
//  Networking.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//
//  Using the decoder method in swift 4 to parse json data


import Foundation
class NetworkHelper {
    
    //MARK: using a completion callback to pass json data after internet fetching is completed
    
    static func getData(completionHandler: @escaping (Any?) -> Void) {

        let headers = [
            "x-rapidapi-host": "realtor.p.rapidapi.com",
            "x-rapidapi-key": "4a9c9d56e1mshf70105ec6b8f980p14fe1fjsn40afebe206bb"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://realtor.p.rapidapi.com/properties/list-for-sale?sort=relevance&radius=10&city=Plano&offset=0&limit=20&state_code=TX")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription ?? "")
                completionHandler(error)
            } else {
                guard let httpResponse = response as? HTTPURLResponse else {return}
                print(httpResponse.statusCode)
                guard let data = data else { return }
                do {
                    let jsonDecoder = JSONDecoder()
                    let json = try jsonDecoder.decode(HomeForSale.self, from: data)
                    let result = json.listings
                    completionHandler(result)
                } catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
}

struct HomeForSale: Codable {
    let listings : [Property]
}

struct Property: Codable {
    let property_id: String
    let is_new_construction: Bool?
    let address: String
    let price: String
    let beds: Int
    let baths: Int
    let sqft: String
    let lot_size: String?
    let lat: Double
    let lon: Double
    let photo: String?
}



