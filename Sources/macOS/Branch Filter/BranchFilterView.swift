//
// Created by Sean Henry on 07/09/2016.
//

import Foundation
import AppKit

class BranchFilterView: NSTextField {
    
    var filterPatternDataStore: PatternDataStore!

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        target = self
        action = #selector(BranchFilterView.textDidUpdate)
    }

    @objc private func textDidUpdate() {
        filterPatternDataStore.save(pattern: stringValue)
    }
}
