
import Cocoa
import ObjectiveGit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController()! as! NSWindowController

    func applicationDidFinishLaunching(_ notification: Notification) {
        try? FileManager.default.createDirectory(at: Locations.directory, withIntermediateDirectories: true, attributes: nil)
        let tabControllerController = windowController.contentViewController! as! NSTabViewController
        let xcsConfigurationView = tabControllerController.childViewControllers[0].view as! XCSConfigurationForm
        XCSConfigurationLauncher().launch(view: xcsConfigurationView)
        let gitConfigurationView = tabControllerController.childViewControllers[1].view as! TogglingGitConfigurationView
        GitConfigurationLauncher().launch(view: gitConfigurationView)
        let viewController = tabControllerController.childViewControllers[2] as! ViewController
        BotTemplateLauncher().launch(view: viewController.templateView)
        BranchFilterLauncher().launch(view: viewController.branchFilterView)

        windowController.showWindow(nil)

        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [unowned self] _ in
            self.synchronise()
        }
    }

    private func synchronise() {
        BotManagementLauncher().launch()?.execute()
    }
}

