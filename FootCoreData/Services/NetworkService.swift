
//
//  NetworkService.swift
//  FootCoreData
//
//  Created by Max on 28.07.2022.
//

import Foundation
import UIKit


class NetworkService: NSObject {
    
    static let apiKey = "deb221e61bmsh56b16aa67a129f5p10d30ejsna38f2282e451"
    static let apiHost = "api-football-v1.p.rapidapi.com"

    static func makeRequest(club: Club, completion: EmptyBlock?) {
        let headers = [
            "X-RapidAPI-Key": apiKey,
            "X-RapidAPI-Host": apiHost
        ]

        guard let url = URL(string: "https://" + apiHost + "/v3/players?league=39&season=2021") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                print(String(describing: error))
                completion?()
                return
            }
            
            guard let data = data else { return }
            let dictionary = try? JSONDecoder().decode(Response.self, from: data)
            guard let playerInfo = dictionary?.response else { return }
            DispatchQueue.main.async {
                saveResponse(playerInfo, club: club, completion: completion)
            }
        })
        dataTask.resume()
    }
    
    static func saveResponse(_ response: [PlayerInfo], club: Club, completion: EmptyBlock?) {
        let existingPlayerIDs = Player.allObjectsPlayer()?.compactMap({$0.identifier})
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
                     
        for i in response {
            let identifier = String(i.player.id)
            guard existingPlayerIDs?.contains(identifier) == false else {
                continue
            }
            guard let player = Player.createNewObjectPlayer() else { return }
            player.identifier = identifier
            player.name = i.player.name
            player.lastName = i.player.lastName

            player.birthday = dateFormatter.date(from:(i.player.birth?.date) ?? "0000-00-00")
            
            player.injured = i.player.injured
            player.photoURL = i.player.photo
            player.fetchPhoto()            
            player.playClub = club
            player.position = i.statistics.last?.games.position
            player.number = i.statistics.last?.games.number ?? 0
        }
        CoreDataService.shared.saveContext()
        completion?()
    }
}

struct Response: Codable {
    var response: [PlayerInfo]
}

struct PlayerInfo: Codable {
    var player: BPlayer
    var statistics: [PlayerStatistics]
}

struct PlayerStatistics: Codable {
    var games: GamesInfo
}

struct GamesInfo: Codable {
    var position: String?
    var number: Int16?
}

struct BPlayer: Codable {
    var id : Int
    var name : String?
    var firstName : String?
    var lastName : String?
    var age : Int?
    var height: String?
    var weight: String?
    var injured: Bool
    var birth: BirthInfo?
    var photo : String?
}

struct BirthInfo: Codable {
    var date: String?
    var place: String?
    var country: String?
}
 
