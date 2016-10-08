//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol MainThreadCompletable {
    func wrapInMainThread<T>(_ closure: ((T) -> ())?) -> (T) -> ()
}
