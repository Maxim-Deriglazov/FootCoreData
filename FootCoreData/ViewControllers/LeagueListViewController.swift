//
//  LeagueListViewController.swift
//  FootCoreData
//
//  Created by Max on 22.07.2022.
//

import UIKit
import Foundation

class LeagueListViewController: UIViewController {
    
    @IBOutlet weak var leagueTable: UITableView?
        
    let indentifier = "LeagueCell"
    
    var leagues = League.allObjectsLeague()?.sorted(by: { $0.name ?? "" < $1.name ?? "" }) ?? []
    
    var icon: UIImage?
    var tempName: String?
    var tempCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tempName != nil || tempCountry != nil || icon != nil {
            showAddLeagueUI(name: tempName, country: tempCountry, icon: icon)
        }
    } 
    
    func showPhoto() {
        if let vc = PhotoViewController.loadFromStoryboard(name: "Main") {
            vc.saveBlock = { [weak self] (icon) in
                guard let vc = self else { return }
                vc.icon = icon
                vc.navigationController?.popToViewController(vc, animated: true)
            }
            vc.resaltSelectScreen = PhotoScreenConfig.selectScreen(type: PhotoType.legue)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func addLeague() {
        showAddLeagueUI()
    }
    
    func showAddLeagueUI(name: String? = nil, country: String? = nil, icon: UIImage? = nil) {
        let messageIcon = icon != nil ? "icon selected" : "icon not selected"
        
        let alert = UIAlertController(title: "Add league", message: messageIcon, preferredStyle: .alert)
        alert.addTextField(){ textField in
            textField.placeholder = "Enter name league"
            textField.text = name
        }
        alert.addTextField(){ textField in
            textField.placeholder = "Enter country league"
            textField.text = country
        }

        let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned alert] _ in
            guard let fields = alert.textFields else { return }
            var newName = fields[0].text ?? ""
            if newName.count == 0 {
                newName = "No name"
            }
            var newCountry = fields[1].text ?? ""
            if newCountry.count == 0 {
                newCountry = "No country"
            }
            self.tempName = nil
            self.tempCountry = nil
            self.addLeague(name: newName, country: newCountry, icon: self.icon)
            self.icon = nil
        }
        let addImgAction = UIAlertAction(title: "Add icon", style: .default) { (addImgAction) in
            guard let fields = alert.textFields, fields.count >= 2 else { return }
            self.showPhoto()
            self.tempName = fields[0].text
            self.tempCountry = fields[1].text
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.tempName = nil
            self.tempCountry = nil
            self.icon = nil
        }
        alert.addAction(cancelAction)
        alert.addAction(addImgAction)
        alert.addAction(submitAction)

        present(alert, animated: true)
    }
    
    func addLeague(name: String, country: String, icon: UIImage?) {
        guard let league = League.createNewObjectLeague() else { return }
        league.name = name
        league.country = country
        league.emblem = icon
        league.identifier = NSUUID().uuidString
                
        CoreDataService.shared.saveContext()
        
        leagues.insert(league, at: 0)
        leagueTable?.reloadData()
    }
    
    @IBAction func deleteLeagueButton(_ sender: UIButton) {
        guard let tv = leagueTable else {
            return
        }
        tv.isEditing = !tv.isEditing
    }
    
    func openClubScreen(league: League) {
        if let screen = LeagueViewController.loadFromStoryboard(name: "Main") {
            screen.league = league
            navigationController?.pushViewController(screen, animated: true)
        }
    }
}

extension LeagueListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath)
        let myCell = cell as? LeagueCell

        let league = leagues[indexPath.row]

        myCell?.leagueNameCell?.text = league.name
        myCell?.leagueCountryCell?.text = league.country
        myCell?.leagueImgCell?.image = league.emblem
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let league = leagues[indexPath.row]

        openClubScreen(league: league)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let league = leagues[indexPath.row]
            league.managedObjectContext?.delete(league)
            leagues.remove(at: indexPath.row)
            CoreDataService.shared.saveContext()

            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}


class LeagueCell: UITableViewCell {    
    @IBOutlet weak var leagueNameCell: UILabel?
    @IBOutlet weak var leagueCountryCell: UILabel?
    @IBOutlet weak var leagueImgCell: UIImageView?
}
