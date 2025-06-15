//
//  ViewController.swift
//  Airlance
//
//  Created by resoul on 15.06.2025.
//

import UIKit

struct DecodableType: Decodable {
    var id: Int
    var name: String
    var email: String
}

class ViewController: UIViewController {
    
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label.text = "Загрузка..."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        guard let url = URL(string: "http://localhost:8080/user?id=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.label.text = "Ошибка: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.label.text = "Нет данных"
                }
                return
            }
            
            do {
                let user = try JSONDecoder().decode(DecodableType.self, from: data)
                DispatchQueue.main.async {
                    self.label.text = "Имя: \(user.name)\nEmail: \(user.email)"
                }
            } catch {
                DispatchQueue.main.async {
                    self.label.text = "Ошибка парсинга: \(error)"
                }
            }
        }
        
        task.resume()
    }
}
