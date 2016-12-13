import AppKit

class IntrinsicSizeView: NSView {
    
    override var intrinsicContentSize: NSSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for subview in subviews {
            width = max(width, subview.frame.maxX)
            height = max(height, subview.frame.maxY)
        }
        return CGSize(width: width, height: height)
    }
}
