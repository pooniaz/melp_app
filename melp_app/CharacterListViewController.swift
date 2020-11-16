//
//  CharacterListViewController.swift
//  melp_app
//
//  Created by Manish Punia on 13/11/20.
//

import UIKit
import GRDB

class CharacterListViewController: UITableViewController {
    
    
    @IBOutlet weak var createNewCharacter: UIBarButtonItem!
    private var dataSource: CharacterDataSource!
    private var charactersCancellable: DatabaseCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureDataSourceContent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    
    private func configureDataSource() {
        dataSource = CharacterDataSource(tableView: tableView) { (tableView, indexPath, character) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath)
            if character.name.isEmpty {
                cell.textLabel?.text = "(anonymous)"
            } else {
                cell.textLabel?.text = character.name
            }
            cell.detailTextLabel?.text = character.description
            cell.imageView!.image = UIImage.init(data:character.image)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
    }
    
    private func configureDataSourceContent() {
        
            charactersCancellable = AppDatabase.shared.observeCharacterOrderedByName(
                onError: { error in fatalError("Unexpected error: \(error)") },
                onChange: { [weak self] characters in
                    guard let self = self else { return }
                    self.updateDataSourceContent(with: characters)
                })
        
    }
    
    private func updateDataSourceContent(with characters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Character>()
        snapshot.appendSections([0])
        snapshot.appendItems(characters, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let character = dataSource.itemIdentifier(for: indexPath) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as! CharacterDetailViewController
            let nvc = UINavigationController.init(rootViewController: vc)
            vc.setCharacter(character )
            self.present(nvc, animated: true, completion: nil)
        }

    }
}


// MARK: - UITableViewDataSource

/// Subclass of UITableViewDiffableDataSource that supports row deletion
private class CharacterDataSource: UITableViewDiffableDataSource<Int, Character> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let character = itemIdentifier(for: indexPath), let id = character.id {
            try! AppDatabase.shared.deleteCharacters(ids: [id])
        }
    }
}

