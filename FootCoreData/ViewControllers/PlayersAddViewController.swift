//
//  PlayersAddViewController.swift
//  FootCoreData
//
//  Created by Max on 03.08.2022.
//

import UIKit
import Foundation

class PlayersAddViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var lastNameTextField: UITextField?
    @IBOutlet weak var numberTextField: UITextField?
    @IBOutlet weak var positionSC: UISegmentedControl?
    @IBOutlet weak var photoImage: UIImageView?
    
    var club: Club?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add player"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePlayer))
    }
    
    @objc func savePlayer() {
        addPlayer()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editPhotoButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func addPlayer() {
        guard let player = Player.createNewObjectPlayer() else { return }      
        
        player.name = nameTextField?.text
        player.lastName = lastNameTextField?.text
        player.number = Int16(numberTextField?.text ?? "0") ?? 0
        
        let selectedIndex = positionSC?.selectedSegmentIndex
        var segmContrPos = "Goalkeeper"
        if selectedIndex == 0 {
            segmContrPos = "Goalkeeper"
        }
        else if selectedIndex == 1 {
            segmContrPos = "Defender"
        }
        else if selectedIndex == 2 {
            segmContrPos = "Midfielder"
        }
        else if selectedIndex == 3 {
            segmContrPos = "Attacker"
        }
        player.position = segmContrPos
        
        player.emblem = photoImage?.image
        player.playClub = club
        player.identifier = NSUUID().uuidString
                
        CoreDataService.shared.saveContext()
    }
}

extension PlayersAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        photoImage?.image = img
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
