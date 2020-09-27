//
//  HomeViewController.swift
//  SwiftUIApp
//
//  Created by Alexey Naumov on 26.09.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class HomeViewController: UIHostingController<HomeView> {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(rootView: HomeView(viewModel: viewModel))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Group {
            if viewModel.progress.status.isLoading {
                ProgressView()
            } else {
                VStack {
                    Text(viewModel.userInfo.name)
                        .font(.title)
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                    Text(viewModel.userInfo.balance)
                        .font(.body)
                    List(viewModel.transactions) { transaction in
                        TransactionCell(transaction: transaction)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.select(transaction: transaction)
                            }
                    }
                }
                .overlay(logOutButton)
            }
        }
        .onAppear(perform: {
            self.viewModel.loadContent()
        })
    }
    
    private var logOutButton: some View {
        Button(viewModel.textIO.logoutTitle, action: {
            self.viewModel.logOut()
        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

extension HomeView {
    struct TransactionCell: View {
        
        let transaction: HomeViewModel.TransactionInfo
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(transaction.amount)
                    Spacer()
                    Text(transaction.date)
                        .font(.footnote)
                }
                Text(transaction.description)
                    .font(.footnote)
            }
            .frame(height: 44)
        }
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init(container: FakeSessionStageContainer()))
    }
}
