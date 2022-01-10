// Copyright © 2020 Stormbird PTE. LTD.

import UIKit

class RoundedImageView: ImageView {

    init(size: CGSize) {
        super.init(frame: .zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

class WalletConnectSessionCell: UITableViewCell {
    private let background = UIView()
    private let nameLabel = UILabel()
    private let urlLabel = UILabel()
    private let iconImageView: RoundedImageView = {
        let imageView = RoundedImageView(size: .init(width: 40, height: 40))
        return imageView
    }()

    private let serverIconImageView: RoundedImageView = {
        let imageView = RoundedImageView(size: .init(width: 16, height: 16))
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        
        let cell0 = [
            nameLabel,
            urlLabel
        ].asStackView(axis: .vertical)
        let stackView = [
            .spacerWidth(Table.Metric.plainLeftMargin),
            iconImageView,
            .spacerWidth(12),
            cell0
        ].asStackView(axis: .horizontal, alignment: .center)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(stackView)
        background.addSubview(serverIconImageView)

        NSLayoutConstraint.activate([
            serverIconImageView.centerXAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: 8),
            serverIconImageView.centerYAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: -8),
            //NOTE: using edge insets to avoid braking constraints
            stackView.anchorsConstraint(to: background, edgeInsets: .init(top: 12, left: 20, bottom: 16, right: 12)),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: WalletConnectSessionCellViewModel) {
        selectionStyle = .none
        backgroundColor = .clear
        
        background.backgroundColor = viewModel.backgroundColor
        background.cornerRadius = 8
        background.layer.shadowColor = Colors.lightGray.cgColor
        background.layer.shadowRadius = 2
        background.layer.shadowOffset = .zero
        background.layer.shadowOpacity = 0.6
        
        nameLabel.attributedText = viewModel.sessionNameAttributedString
        urlLabel.attributedText = viewModel.sessionURLAttributedString
        iconImageView.setImage(url: viewModel.sessionIconURL, placeholder: R.image.walletConnectIcon())
        serverIconImageView.subscribable = viewModel.serverIconImage
    }
}
