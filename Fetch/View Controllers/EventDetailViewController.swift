//
//  EventDetailViewController.swift
//  Fetch
//
//  Created by scott harris on 3/3/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    var event: Event?
    let imageView = UIImageView()
    let dateLabel = UILabel()
    let locationLabel = UILabel()
    let headerView = UIView()
    let likeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        guard let event = event else { return }
        
        configureHeaderView()
        configureImageView(for: event)
        configureDateLabel(for: event)
        configureLocationLabel(for: event)
    }
    
    private func configureImageView(for event: Event) {
        if let data = event.imageData {
            imageView.image = UIImage(data: data)
        }
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16),
        ])
    }
    
    private func configureDateLabel(for event: Event) {
        dateLabel.text = DateFormatter.dayDateTime.string(from: event.dateTime)
        dateLabel.font = .preferredFont(forTextStyle: .headline)
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLocationLabel(for event: Event) {
        locationLabel.text = "\(event.venue.city), \(event.venue.state)"
        locationLabel.font = .preferredFont(forTextStyle: .subheadline)
        if #available(iOS 13, *) {
            locationLabel.textColor = .secondaryLabel
        } else {
            locationLabel.textColor = .gray
        }
        view.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureHeaderView() {
        let containerView = headerView
        let backButton = UIButton()
        let titleLabel = UILabel()
        let seperatorView = UIView()
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        containerView.addSubview(backButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(likeButton)
        containerView.addSubview(seperatorView)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.setBackgroundImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)

        ])
        
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        likeButton.setBackgroundImage(UIImage(named: "heart-gray"), for: .normal)
        likeButton.setBackgroundImage(UIImage(named: "heart-fill-red"), for: .selected)
        likeButton.tintColor = .lightGray
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.text = event?.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -24)
        ])
        
        seperatorView.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            seperatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            seperatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
        
    }
    
    @objc func backTapped() {
        dismiss(animated: true)
    }
    
    @objc func likeTapped() {
        likeButton.isSelected.toggle()
    }
    
}
