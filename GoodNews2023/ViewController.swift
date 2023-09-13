//
//  ViewController.swift
//  GoodNews2023
//
//  Created by Глеб on 28.08.2023.
//

import UIKit
import SafariServices

// TableView
// Custom Cell
// API Caller
// Open the News Story
// Search for News Stories

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(GoodNewsTableViewCell.self,
                       forCellReuseIdentifier: GoodNewsTableViewCell.identifier)
        return table
    }()
    
    private var articles = [Article]()
    private var viewModels = [GoodNewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Good News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        fetchTopStories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchTopStories() {
        
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    GoodNewsTableViewCellViewModel(
                        title: $0.title ?? "You have no access to this Title",
                        subtitle: $0.description ?? "You have no access to this Description",
                        imageURL: URL(string: $0.urlToImage ?? "https://visualpharm.com/assets/883/iOS%20Application%20Placeholder-595b40b65ba036ed117d09f7.svg")
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GoodNewsTableViewCell.identifier,
            for: indexPath
        ) as? GoodNewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}

