
import Cocoa
import ObjectiveGit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController()! as! NSWindowController

    func applicationDidFinishLaunching(_ notification: Notification) {
        try? FileManager.default.createDirectory(at: Locations.directory, withIntermediateDirectories: true, attributes: nil)
        let tabControllerController = windowController.contentViewController! as! NSTabViewController
        let viewController = tabControllerController.childViewControllers[1] as! ViewController
        BotTemplateLauncher().launch(view: viewController.templateView)
        BranchFilterLauncher().launch(view: viewController.branchFilterView)
        let gitConfigurationView = tabControllerController.childViewControllers[0].view as! TogglingGitConfigurationView
        GitConfigurationLauncher().launch(view: gitConfigurationView)

        windowController.showWindow(nil)

        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [unowned self] _ in
            self.synchronise()
        }
    }

    private func synchronise() {
        BotManagementLauncher().launch()?.execute()
    }
}

