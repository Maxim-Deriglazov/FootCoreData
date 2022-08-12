//
//  ClubViewController.swift
//  FootCoreData
//
//  Created by Max on 26.07.2022.
//

import UIKit
import Foundation

class ClubViewController: UIViewController {
    
    var club: Club?
    
    @IBOutlet weak var playersTable: UITableView?
    
    let indentifier = "PlayerCell"
    
    func obtainPlayers() -> [Player] {
        let arrPlayers = Array(club?.clubPlay as Set? ?? Set<Player>()) as? [Player]
        var result = arrPlayers ?? []
        result.sort(by: { $0.name ?? "" < $1.name ?? "" } )
        return result
    }
    
    var players = [Player]() {
        didSet {
            playersTable?.reloadData()
        }
    }
        
    var icon: UIImage?
    var tempName: String?
    var tempCountry: String?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = club?.name
        NotificationCenter.default.addObserver(self, selector: #selector(photoUpdated(_:)), name: Player.PlayerPhotoUpdateNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        players = obtainPlayers()
    }
    
    @objc func photoUpdated(_ notification: Notification) {
        guard let player = notification.object as? Player else { return }
        guard let index = players.firstIndex(of: player) else { return }
        let ip = IndexPath(row: index, section: 0)
        guard let indexVisibleCell = playersTable?.indexPathsForVisibleRows else { return }
        
        if indexVisibleCell.contains(ip) == true { playersTable?.reloadRows(at: [ip], with: .none) }
    }
        
    @IBAction func addPlayerButton(_ sender: UIButton) {
        openAddPlayersScreen()
    }
    
    @IBAction func addPlayersAuto(_ sender: UIButton) {
        guard let club = club else {
            return
        }
        NetworkService.makeRequest(club: club) { [weak self] in
            guard let self = self else { return }
            self.players = self.obtainPlayers()
            self.playersTable?.reloadData()
        }
    }
    
    @IBAction func deletePlayers(_ sender: UIButton) {
        guard let tv = playersTable else {
            return
        }
        tv.isEditing = !tv.isEditing
    }
}

extension ClubViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath)
        let myClubCell = cell as? PlayerCell
        
        let player = players[indexPath.row]
        
        myClubCell?.playerNameCell?.text = player.fullName
        myClubCell?.playerNumberCell?.text = String(player.number)
        myClubCell?.playerPositionCell?.text = player.position
        myClubCell?.playerImgCell?.image = player.emblem
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let player = players[indexPath.row]
            player.managedObjectContext?.delete(player)
            players.remove(at: indexPath.row)
            
            CoreDataService.shared.saveContext()
        }
    }   
    
    func openAddPlayersScreen() {
        if let screen = PlayersAddViewController.loadFromStoryboard(name: "Main") {
            screen.club = club
            navigationController?.pushViewController(screen, animated: true)
        }
    }
}

class PlayerCell: UITableViewCell {
    @IBOutlet weak var playerNameCell: UILabel?
    @IBOutlet weak var playerNumberCell: UILabel?
    @IBOutlet weak var playerPositionCell: UILabel?
    @IBOutlet weak var playerImgCell: UIImageView?
}
