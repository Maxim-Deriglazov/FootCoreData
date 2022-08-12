//
//  LeagueViewController.swift
//  FootCoreData
//
//  Created by Max on 26.07.2022.
//

import UIKit
import Foundation

class LeagueViewController: UIViewController {
    
    var league: League?

    var icon: UIImage?
    
    @IBOutlet weak var clubTable: UITableView?
    
    @IBOutlet weak var alertView: UIView?
    @IBOutlet weak var nameClubTextField: UITextField?
    @IBOutlet weak var lcSwitch: UISwitch?
        
    let indentifier = "ClubCell"
    
    var clubs = [Club]()

    override func viewDidLoad() {
        super.viewDidLoad()
        alertView?.isHidden = true
        title = league?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let arrClubs = Array(league?.legClub as Set? ?? Set<Club>()) as? [Club]
        clubs = arrClubs?.sorted(by: { $0.name ?? "" < $1.name ?? "" }) ?? []
    }
    
    func showPhoto() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(identifier: "PhotoViewController") as? PhotoViewController {
            vc.saveBlock = { [weak self] (icon) in
                guard let vc = self else { return }
                vc.icon = icon
                vc.navigationController?.popToViewController(vc, animated: true)
            }
            vc.resaltSelectScreen = PhotoScreenConfig.selectScreen(type: .club)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addClubButton(_ sender: UIButton) {
        alertView?.isHidden = false
    }
    
    @IBAction func addIconClubButton(_ sender: UIButton) {
        showPhoto()
    }
    
    @IBAction func saveClubButton(_ sender: UIButton) {
        let newName = nameClubTextField?.text ?? "no name"
        guard let newActive = lcSwitch?.isOn else { return }
        
        addClub(name: newName, active: newActive, icon: icon)
        
        alertView?.isHidden = true
    }
    
    func addClub(name: String, active: Bool, icon: UIImage? = nil) {
        guard let club = Club.createNewObjectClub() else { return }
        club.name = name
        club.championsLeague = active
        club.emblem = icon
        club.identifier = NSUUID().uuidString
        club.clubLeag = league
        
        CoreDataService.shared.saveContext()
        
        self.icon = nil
          
        clubs.insert(club, at: 0)
        clubTable?.reloadData()
    }
    
    @IBAction func deleteClubButton(_ sender: UIButton) {
        guard let tv = clubTable else {
            return
        }
        tv.isEditing = !tv.isEditing
    }
    
    
    @IBAction func cancelAddClubButton(_ sender: UIButton) {
        icon = nil
        alertView?.isHidden = true
    }
    
    func openPlayersScreen(club: Club) {
        if let screen = ClubViewController.loadFromStoryboard(name: "Main") {
            screen.club = club

            navigationController?.pushViewController(screen, animated: true)
        }
    }
}

extension LeagueViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath)
        let myClubCell = cell as? ClubCell
        
        let club = clubs[indexPath.row]

        myClubCell?.clubNameLabel?.text = club.name
        myClubCell?.clubIconImg?.image = club.emblem
                
        if club.championsLeague == false {
            myClubCell?.clubLCImg?.image = UIImage(named: "Leag")
        }
        else {  
            myClubCell?.clubLCImg?.image = UIImage()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let club = clubs[indexPath.row]
        openPlayersScreen(club: club)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let club = clubs[indexPath.row]
            club.managedObjectContext?.delete(club)
            clubs.remove(at: indexPath.row)
            
            CoreDataService.shared.saveContext()

            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

class ClubCell: UITableViewCell {
    @IBOutlet weak var clubNameLabel: UILabel?
    @IBOutlet weak var clubIconImg: UIImageView?
    @IBOutlet weak var clubLCImg: UIImageView?    
}
