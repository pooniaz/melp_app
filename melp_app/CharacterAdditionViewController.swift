//
//  CharacterAdditionViewController.swift
//  melp_app
//
//  Created by Manish Punia on 16/11/20.
//


import UIKit

class CharacterAdditionViewController: UITableViewController, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var imageCell: UITableViewCell!
    
    

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToolbar()
    }
    
    @objc private func selectImage()  {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    private func configureToolbar() {
        toolbarItems = [
            
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Select Image", style: .plain, target: self, action: #selector(selectImage)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            
        ]
    }
    
    
    @IBAction func selectAvatar(_ sender: Any) {
     
        
        var character = Character(id: nil, name: nameTextField.text ?? "", description: descriptionTextView.text, image: avatarImageView.image?.jpegData(compressionQuality: 1.0) ??  UIImage.init(named: "spider.jpeg")!.jpegData(compressionQuality: 1.0)!)
        try! AppDatabase.shared.saveCharacter(&character)
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension CharacterAdditionViewController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            picker.dismiss(animated: true, completion: nil)
            return
        } 
        self.avatarImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CharacterAdditionViewController: UITextFieldDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if cell === nameCell {
            nameTextField.becomeFirstResponder()
        } else if cell === descriptionCell {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            nameTextField.becomeFirstResponder()
        }
        return false
    }
    

}

