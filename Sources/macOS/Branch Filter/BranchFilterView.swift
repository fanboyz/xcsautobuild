
import Foundation
import AppKit

class BranchFilterView: NSTextField {
    
    var filterPatternDataStore: PatternDataStore!

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        stringValue = filterPatternDataStore.load() ?? ""
        delegate = self
    }
    
    @IBAction func save(_ sender: NSButton?) {
        filterPatternDataStore.save(pattern: stringValue)
    }
}

extension BranchFilterView: NSTextFieldDelegate {
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSTextView.insertNewline(_:)) {
            textView.insertNewlineIgnoringFieldEditor(self)
            return true
        }
        return false
    }
}
