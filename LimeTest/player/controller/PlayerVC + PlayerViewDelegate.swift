import UIKit

extension PlayerViewController: PlayerViewDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
