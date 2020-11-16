//
//  Database.swift
//  melp_app
//
//  Created by Manish Punia on 13/11/20.
//

import Foundation

import GRDB


final class AppDatabase {

    static var shared: AppDatabase!
    
    private let dbQueue: DatabaseQueue
    

    init(_ dbQueue: DatabaseQueue) throws {
        self.dbQueue = dbQueue
        try migrator.migrate(dbQueue)
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        
        migrator.registerMigration("createCharacter") { db in
            try db.create(table: "character") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                    .collate(.localizedCaseInsensitiveCompare)
                t.column("description", .text).notNull()
                t.column("image", .blob).notNull()
            }
        }
        
        
        return migrator
    }
}

// MARK: - Database Access
//
// This extension defines methods that fulfill application needs, both in terms
// of writes and reads.
extension AppDatabase {
    // MARK: Writes
    func saveCharacter(_ character: inout Character) throws {
        try dbQueue.write { db in
            try character.save(db)
        }
    }
    
    func deleteCharacters(ids: [Int64]) throws {
        try dbQueue.write { db in
            _ = try Character.deleteAll(db, keys: ids)
        }
    }
    
    func deleteAllCharacters() throws {
        try dbQueue.write { db in
            _ = try Character.deleteAll(db)
        }
    }
    

    
    func createRandomCharactersIfEmpty() throws {
        try dbQueue.write { db in
            if try Character.fetchCount(db) == 0 {
                try createRandomCharacters(db)
            }
        }
    }
    
    private func createRandomCharacters(_ db: Database) throws {
        for character in Character.dummyCharacters
        {
            var cr = character
            try cr.insert(db)
        }
        
    }
    
    // MARK: Reads
    
    func observeCharacterCount(
        onError: @escaping (Error) -> Void,
        onChange: @escaping (Int) -> Void)
    -> DatabaseCancellable
    {
        ValueObservation
            .tracking(Character.fetchCount)
            .start(
                in: dbQueue,
                onError: onError,
                onChange: onChange)
    }
    
    func observeCharacterOrderedByName(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Character]) -> Void)
    -> DatabaseCancellable
    {
        ValueObservation
            .tracking(Character.all().orderedByName().fetchAll)
            .start(
                in: dbQueue,
                onError: onError,
                onChange: onChange)
    }
}

