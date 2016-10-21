
import Cocoa
import ObjectiveGit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var interactor: BotSyncingInteractor!
    let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController()! as! NSWindowController

    func applicationDidFinishLaunching(_ notification: Notification) {
        try? FileManager.default.createDirectory(at: Locations.directory, withIntermediateDirectories: true, attributes: nil)
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: Configuration.gitDirectory, remoteName: Configuration.gitRemoteName, credentialProvider: Configuration.gitCredentialProvider),
            botSynchroniser: Dependencies.botSynchroniser,
            branchFilter: Dependencies.wildcardBranchFilter,
            botDataStore: PlistBotDataStore(file: Locations.synchronisedBotsFile.path)
        )
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [unowned self] _ in
            self.interactor.execute()
        }
        let viewController = windowController.contentViewController! as! ViewController
        BotTemplateLauncher().launch(view: viewController.templateView)
        windowController.showWindow(nil)
    }
}

