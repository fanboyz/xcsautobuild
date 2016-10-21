//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
import XCTest
@testable import xcsautobuild

class FileBotDataStoreTests: XCTestCase {

    var store: FileBotDataStore!
    var bot: Bot!
    let file = NSTemporaryDirectory() + "TestBots"
    let develop = Bot(branchName: "develop", id: "master_bot_id")
    let master = Bot(branchName: "master", id: "develop_bot_id")
    let botWithNoID = Bot(branchName: "new", id: nil)

    override func setUp() {
        super.setUp()
        deleteFile()
        store = FileBotDataStore(file: file)
    }

    override func tearDown() {
        deleteFile()
        super.tearDown()
    }

    // MARK: - save

    func test_save_shouldSaveBotWithoutBotID() {
        let bot = botWithNoID
        save(bot)
        XCTAssertEqual(load(fromBranchName: botWithNoID.branchName), bot)
    }

    func test_save_shouldSaveBotWithID() {
        save(master)
        XCTAssertEqual(load(fromBranchName: "master"), master)
    }

    func test_save_shouldOverwriteBot() {
        save(Bot(branchName: "master", id: "different"))
        save(master)
        XCTAssertEqual(load(fromBranchName: "master"), master)
    }

    func test_save_shouldReturnNil_whenNoBot() {
        XCTAssertNil(load(fromBranchName: "develop"))
    }

    func test_save_shouldSaveAndLoadMultipleBot() {
        save(develop)
        save(master)
        XCTAssertEqual(load(fromBranchName: "develop"), develop)
        XCTAssertEqual(load(fromBranchName: "master"), master)
    }

    // MARK: - load

    func test_load_shouldLoadAllSavedBots() {
        save(develop)
        save(master)
        let loaded = load()
        XCTAssert(loaded.contains(develop))
        XCTAssert(loaded.contains(master))
        XCTAssertEqual(loaded.count, 2)
    }

    func test_load_shouldIgnoreBadFile() {
        writeBadFile()
        XCTAssert(load().isEmpty)
    }

    // MARK: - delete

    func test_delete_shouldRemoveBot() {
        save(develop)
        delete(develop)
        XCTAssert(load().isEmpty)
    }

    func test_delete_shouldNotRemoveAnyBots_whenNotAMatchingBot() {
        save(develop)
        save(master)
        delete(botWithNoID)
        let loaded = load()
        XCTAssert(loaded.contains(develop))
        XCTAssert(loaded.contains(master))
    }

    func test_delete_shouldRemoveBot_whenOnlyTheNameMatches() {
        save(develop)
        delete(Bot(branchName: develop.branchName, id: "a_different_id"))
        XCTAssert(load().isEmpty)
    }

    // MARK: - Helpers

    func save(_ bot: Bot? = nil) {
        store.save(bot ?? self.bot)
    }

    func load() -> [Bot] {
        return store.load()
    }

    func load(fromBranchName name: String) -> Bot? {
        return store.load(fromBranchName: name)
    }

    func delete(_ bot: Bot) {
        store.delete(bot)
    }

    func deleteFile() {
        _ = try? FileManager.default.removeItem(atPath: file)
    }

    func writeBadFile() {
        try! "invalid!".write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
    }
}
