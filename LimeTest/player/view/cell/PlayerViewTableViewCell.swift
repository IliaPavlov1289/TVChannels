import UIKit

protocol PlayerViewTableViewCellDelegate: AnyObject {
    func selectVideoQuality(videoQuality: VideoQualityType)
}

class PlayerViewTableViewCell: UITableViewCell {
    
    private lazy var titleLabel:  UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.1, green: 0.11, blue: 0.14, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var videoQuality: VideoQualityType? = nil {
        didSet {
            titleLabel.text = videoQuality?.description
        }
    }
    
    func isSelected() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        self.backgroundColor = UIColor(red: 0, green: 0.47, blue: 1, alpha: 1)
    }
    
    func isNotSelected() {
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.11, blue: 0.14, alpha: 1)
        self.backgroundColor = .white
    }
    
    weak var delegate: PlayerViewTableViewCellDelegate?

    func setup(videoQuality: VideoQualityType) {
        self.videoQuality = videoQuality
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        selectionStyle = .none
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        setupTapGesture()
    }
    
    override func tapGestureSelector() {
        guard let videoQuality = videoQuality else { return }
        delegate?.selectVideoQuality(videoQuality: videoQuality)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
