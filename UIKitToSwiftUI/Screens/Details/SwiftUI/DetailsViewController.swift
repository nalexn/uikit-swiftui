//
//  DetailsViewController.swift
//  SwiftUIApp
//
//  Created by Alexey Naumov on 28.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class DetailsViewController: UIHostingController<DetailsView> {
    
    private let viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: DetailsView(viewModel: viewModel))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct DetailsView: View {
    
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.textIO.amount)
                .font(.largeTitle)
            Text(viewModel.textIO.date)
                .font(.body)
            Text(viewModel.textIO.description)
                .font(.subheadline)
                .padding(.top)
            Button(viewModel.textIO.closeTitle, action: {
                self.viewModel.close()
            })
            .padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

// MARK: - Preview

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(viewModel: .init(container: FakeSessionStageContainer(), transaction: Transaction(id: "", date: Date(), amount: 5325, description: "Transaction description")))
    }
}
