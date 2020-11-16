//
//  Character.swift
//  melp_app
//
//  Created by Manish Punia on 13/11/20.
//

import Foundation
import UIKit

import GRDB

/// The Character struct.
struct Character: Hashable {
    var id: Int64?
    var name: String
    var description: String
    var image:Data
    
}


extension Character {
     static let dummyCharacters:[Character] = [Character(id:nil, name: "Captain America", description: "The First Avenger by age, Captain America actually joined the team in their early years after he broke out of a block of ice from the Arctic. Before becoming Captain America, Steve Rogers was weak and sickly, given treatment that granted him superhuman condition. His extraordinary bones and muscles make him capable of breaking wood and steel with a single hit, while his shield makes him resistant to destruction. With incredible lung capacity, Cap has high endurance and is a skilled martial artist.", image: UIImage.init(named: "captain.jpg")!.jpegData(compressionQuality: 1.0)!),
                                                      Character(id:nil, name: "Moon Knight", description:"A hero who truly deserves his own movie, Moon Knight is the Marvel community’s resident super-detective and arbitrator of Justice. Empowered by the phases of the moon, Marc Spector will beat up anyone who he thinks deserves a good knocking and fights like a boxer by taking punches rather than giving them. Don’t mess with this one, he’s a skilled martial artist, gymnast and boxer!",  image: UIImage.init(named: "spider.jpeg")!.jpegData(compressionQuality: 1.0)!),
                                                      Character(id:nil, name: "Wonder Woman", description:"Pouncing from a super-advanced society from deepest Africa, the Black Panther has got to be one of the more distinct of the Avengers roster. As king of his home nation Wakanda, his fights are not in the streets but against threats to his throne, nation, and even the global geopolitical balance. With an extreme ability to hunt and combat, Black Panther sports a costume with features that in some cases, surpass the Iron Man armors and many Batsuits. A skilled acrobat and martial artist, Black Panther is able to run and move at incredible speeds, sense fear and lies, and see in total darkness." , image: UIImage.init(named: "wonder.jpg")!.jpegData(compressionQuality: 1.0)!),
                                                      Character(id:nil, name: "Blade", description:"Called “the Daywalker” by his blood-sucking foes, Blade is known across the world as a man with all the strengths of a vampire, none of the weaknesses and a natural immunity to vampire talents. He heals rapidly, is unaffected by daylight and is gifted with heightened senses including the ability to detect sounds that a regular human can’t, and “smell” supernatural creatures. He’s the ideal predator after the Van Helsings are gone.", image:UIImage.init(named: "spider.jpeg")!.jpegData(compressionQuality: 1.0)!),
                                                      Character(id:nil, name: "Killmonger", description:"T’Challa’s greatest nemesis and one with a greater chip on his shoulder than Man-Ape. Exiled from Wakanda after his father fell into a failed coup with Ulysses Klaue, N’Jadaka took on the name “Erik Killmonger” and attended MIT. After graduating, he returned home and set about dethroning the man who exiled him. Killmonger has already been dubbed one of the best villains on-screen, and there’s no wonder why. In fact, he’s said to be more tougher and enhanced than Black Panther and has enough power to take down an elephant using his hands alone", image: UIImage.init(named: "spider.jpeg")!.jpegData(compressionQuality: 1.0)!),
                                                      Character(id:nil, name: "Wolverine", description:"What discussion of Marvel’s roster would be complete without one of its most iconic of heroes? A hunter by instinct and skilled martial artist and swordsman, he perhaps knows more than any other mutant (thanks to his long life) how distrustful people can be. Wolverine’s strength is enough to break steel and lift weights that no normal human could. With animal-senses that can hear and see more than that of an ordinary person, a healing power like no other, and claws for days, Wolverine is one that goes down in history.", image: UIImage.init(named: "spider.jpeg")!.jpegData(compressionQuality: 1.0)!)
                                            
    ]
    
    static func new() -> Character {
        Character(id: nil, name: "", description: "", image: UIImage.init(named: "spider.jpeg")!.jpegData(compressionQuality: 1.0)!)
    }
    
}

// MARK: - Persistence

/// Make Pharacter a Codable Record.
extension Character: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let name = Column(CodingKeys.name)
        static let description = Column(CodingKeys.description)
        static let image = Column(CodingKeys.image)
    }
    
    //Updates a character id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == Character {
    // A request of characters ordered by name
    func orderedByName() -> Self {
        order(Character.Columns.name)
    }
}
