//
//  AppDelegate.swift
//  xcsautobuild_macOS
//
//  Created by Sean Henry on 19/07/2016.
//
//

import Cocoa
import ObjectiveGit


class AppDelegate: NSObject, NSApplicationDelegate {
    
    var interactor: BotSyncingInteractor!
    let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController()! as! NSWindowController

    func applicationDidFinishLaunching(_ notification: Notification) {
        try? FileManager.default.createDirectory(at: Locations.directory, withIntermediateDirectories: true, attributes: nil)
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: Configuration.gitDirectory, remoteName: Configuration.gitRemoteName, credential: Configuration.gitCredential),
            botSynchroniser: Dependencies.botSynchroniser,
            branchFilter: Dependencies.wildcardBranchFilter,
            branchesDataStore: FileXCSBranchesDataStore(file: Locations.branchesDataStore.path)
        )
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [unowned self] _ in
            self.interactor.execute()
        }
        let viewController = windowController.contentViewController! as! ViewController
        BotTemplateLauncher().launch(view: viewController.templateView)
        windowController.showWindow(nil)
    }
}

