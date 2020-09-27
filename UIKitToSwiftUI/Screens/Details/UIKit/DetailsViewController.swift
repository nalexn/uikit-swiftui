//
//  DetailsViewController.swift
//  UIKitApp
//
//  Created by Alexey Naumov on 27.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    private var cancelBag = CancelBag()
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountLabel.text = viewModel.textIO.amount
        dateLabel.text = viewModel.textIO.date
        detailsLabel.text = viewModel.textIO.description
        closeButton.setTitle(viewModel.textIO.closeTitle, for: .normal)
    }
    
    @IBAction func handleCloseButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
