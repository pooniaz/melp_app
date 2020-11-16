//
//  CharacterDetailViewController.swift
//  melp_app
//
//  Created by Manish Punia on 16/11/20.
//

import UIKit
import Foundation
class CharacterDetailViewController: UITableViewController, UINavigationControllerDelegate {
    
    var character:Character? = nil
    
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public func setCharacter(_ cr:Character)
    {
        self.character = cr
    }
    
    override func viewDidLoad() {
        
        self.title = character?.name
        if let imageData = character?.image {
            self.avatar.layer.cornerRadius = 8.0
            self.avatar.layer.masksToBounds = true
        self.avatar.image =  UIImage.init(data: imageData )
        }
        self.descriptionLabel.text = character?.description
        super.viewDidLoad()
        
    }
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
    
