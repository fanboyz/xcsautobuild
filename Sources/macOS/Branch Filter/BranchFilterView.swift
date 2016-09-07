//
// Created by Sean Henry on 07/09/2016.
//

import Foundation
import AppKit

class BranchFilterView: NSTextField, StringPatternProvider {

    var stringPattern: PatternDataStore!

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        target = self
        action = #selector(BranchFilterView.textDidUpdate)
    }

    @objc private func textDidUpdate() {
        stringPattern.pattern = stringValue
    }
}
