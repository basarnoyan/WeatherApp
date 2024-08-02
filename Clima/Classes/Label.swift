import UIKit


public class Label: UILabel {
    @IBInspectable public var localizedText: String? {
        get { text }
        set { text = newValue?.localized() }
    }
    
}
