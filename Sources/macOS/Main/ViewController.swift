
import Cocoa

class ViewController: NSViewController {
    @IBOutlet var templateView: TextFieldBotTemplateView!
    @IBOutlet var branchFilterView: BranchFilterView! {
        didSet {
            BranchFilterLauncher().launch(view: branchFilterView)
        }
    }
}
