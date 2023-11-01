import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchTextFieldDidChange(searchText: String?)
}

class SearchView: UIView {
    
    lazy var searchIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Search")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .white
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        textField.attributedPlaceholder = NSAttributedString(string: "Напишите название телеканала", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 0.56, green: 0.57, blue: 0.59, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    weak var delegate: SearchViewDelegate?

    func setupView() {
        setupSubviews()
        setupLayout()
    }
    
    private func setupSubviews() {
        addSubview(searchIconImageView)
        addSubview(searchTextField)
    }
    
    private func setupLayout() {

        NSLayoutConstraint.activate([
            searchIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 24),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchIconImageView.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.searchTextFieldDidChange(searchText: textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Unsupported initializer, please use init()")
    }
}
