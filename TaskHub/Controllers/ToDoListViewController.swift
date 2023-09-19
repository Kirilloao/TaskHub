//
//  ToDoListViewController.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit
import SnapKit

final class ToDoListViewController: UIViewController {
    
    // MARK: - Private Properties
    private let listView = ListView()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

