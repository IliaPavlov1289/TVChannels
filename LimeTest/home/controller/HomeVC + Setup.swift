import UIKit

extension HomeViewController {
    
    func setupView() {
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(mainView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
