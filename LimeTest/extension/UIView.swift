import UIKit

extension UIView {
    func setupTapGesture() {
        self.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelector))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapGestureSelector() {
        self.endEditing(true)
    }
}
