//
//  ViewController.swift
//  xcsautobuild_macOS
//
//  Created by Sean Henry on 19/07/2016.
//
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var templateView: TextFieldBotTemplateView!
    @IBOutlet var branchFilterView: BranchFilterView! {
        didSet {
            BranchFilterLauncher().launch(view: branchFilterView)
        }
    }
}
