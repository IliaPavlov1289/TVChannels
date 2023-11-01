import UIKit

protocol ChannelCollectionViewCellDelegate: AnyObject {
    func favouriteButtonTapped(channel: Channel, isFavourite: Bool)
    func channelTapped(channel: Channel)
}

class ChannelCollectionViewCell: UICollectionViewCell {
    
    private lazy var channelImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.white
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 0.91, green: 0.92, blue: 0.94, alpha: 1)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    weak var delegate: ChannelCollectionViewCellDelegate?
    
    private var channel: Channel? = nil {
       didSet{
           setupData(channel: channel)
       }
   }
    
    var isFavourite = false {
        didSet{
            let image = isFavourite ? UIImage(named: "Star.fill") : UIImage(named: "Star")
            favouriteButton.setImage(image, for: .normal)
        }
    }
    
    private func setupData(channel: Channel?) {
        guard let channel = channel else { return }
        titleLabel.text = channel.name
        subtitleLabel.text = channel.current.title
        
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: channel.image),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.channelImageView.image = image
            }
        }
    }
    
    func setup(channel: Channel) {
        self.channel = channel
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(channelImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(favouriteButton)

        NSLayoutConstraint.activate([

            channelImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            channelImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            channelImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            channelImageView.heightAnchor.constraint(equalToConstant: 60),
            channelImageView.widthAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: channelImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -4),

            subtitleLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: channelImageView.trailingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -16),

            favouriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 32),
            favouriteButton.widthAnchor.constraint(equalToConstant: 32),
        ])
        setupTapGesture()
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.21, alpha: 1)
    }
    
    @objc func favouriteButtonTapped(sender: UIButton) {
        guard let channel = channel else { return }
        isFavourite = !isFavourite
        delegate?.favouriteButtonTapped(channel: channel, isFavourite: isFavourite)
    }
    
    override func tapGestureSelector() {
        guard let channel = channel else { return }
        delegate?.channelTapped(channel: channel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channelImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
