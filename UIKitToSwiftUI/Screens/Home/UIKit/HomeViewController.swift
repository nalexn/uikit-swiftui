//
//  HomeViewController.swift
//  UIKitApp
//
//  Created by Alexey Naumov on 20.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var cancelBag = CancelBag()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIButton!
    
    private var transactions: [HomeViewModel.TransactionInfo] = []
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reuse(TransactionTableViewCell.self)
        tableView.tableFooterView = UIView()
        setupBindings()
        viewModel.loadContent()
    }
    
    private func setupBindings() {
        cancelBag.collect {
            viewModel.$userInfo.map(\.name)
                .sink { [weak self] name in
                    self?.nameLabel.text = name
                }
            viewModel.$userInfo.map(\.balance)
                .sink { [weak self] balance in
                    self?.balanceLabel.text = balance
                }
            viewModel.$transactions
                .sink { [weak self] transactions in
                    self?.transactions = transactions
                    self?.tableView.reloadData()
                }
            viewModel.$progress.map { $0.status.isLoading }
                .sink { [weak self] isLoading in
                    self?.loadingIndicator.animating = isLoading
                    [self?.nameLabel, self?.balanceLabel, self?.tableView, self?.logoutButton]
                        .forEach { $0?.isHidden = isLoading }
                }
            viewModel.$textIO.map(\.logoutTitle)
                .sink { [weak self] title in
                    self?.logoutButton.setTitle(title, for: .normal)
                }
        }
    }
    
    @IBAction func handleLogOutButtonPressed() {
        viewModel.logOut()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TransactionTableViewCell
        else { return }
        let transaction = transactions[indexPath.row]
        cell.setup(viewModel: transaction)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(TransactionTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = viewModel.transactions[indexPath.row]
        viewModel.select(transaction: transaction)
    }
}

class TransactionTableViewCell: UITableViewCell {
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = detailTextLabel?.font
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            label.firstBaselineAnchor.constraint(equalTo: textLabel!.firstBaselineAnchor),
        ])
        return label
    }()
    
    func setup(viewModel: HomeViewModel.TransactionInfo) {
        textLabel?.text = viewModel.amount
        detailTextLabel?.text = viewModel.description
        dateLabel.text = viewModel.date
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
