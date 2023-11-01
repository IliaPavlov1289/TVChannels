import UIKit

protocol SwitchViewDelegate: AnyObject {
    func switchTapped(isSelectedAll: Bool)
}

class SwitchView: UIView {

    private lazy var allLabel: SwitchElementView = {
        let view = SwitchElementView()
        view.label.text = "Все"
        view.border.isHidden = false
        view.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.allLabelTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var favouritesLabel: SwitchElementView = {
        let view = SwitchElementView()
        view.label.text = "Избранное"
        view.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.favouritesLabelTapped))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isSelectedAll = true {
        didSet {
            if isSelectedAll {
                allLabel.isSelected()
                favouritesLabel.isNotSelected()
            } else {
                allLabel.isNotSelected()
                favouritesLabel.isSelected()
            }
        }
    }
    
    weak var delegate: SwitchViewDelegate?

    func setupView() {
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        addSubview(allLabel)
        addSubview(favouritesLabel)
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            allLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            allLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            allLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            favouritesLabel.centerYAnchor.constraint(equalTo: allLabel.centerYAnchor),
            favouritesLabel.leadingAnchor.constraint(equalTo: allLabel.trailingAnchor, constant: 12),
            favouritesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @objc func allLabelTapped() {
        if !isSelectedAll {
            isSelectedAll = true
            delegate?.switchTapped(isSelectedAll: isSelectedAll)
        }
    }
    
    @objc func favouritesLabelTapped() {
        if isSelectedAll {
            isSelectedAll = false
            delegate?.switchTapped(isSelectedAll: isSelectedAll)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Unsupported initializer, please use init()")
    }

}
