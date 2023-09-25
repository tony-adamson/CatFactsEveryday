//
//  CatPictureViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import UIKit

class CatPictureViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var catPictureView: UIView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBAction
    @IBAction func getPicture(_ sender: Any) {
        // Вызываем функцию для получения случайной картинки кошки
        CatPicAPI.shared.getCatPicture { result in
            switch result {
            case .success(let image):
                // Обновляем UI на главной очереди (UI-потоке)
                DispatchQueue.main.async {
                    // Создаем UIImageView и устанавливаем полученное изображение
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = self.catPictureView.bounds
                    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    
                    // Удаляем все предыдущие подсмотренные изображения (если есть)
                    for subview in self.catPictureView.subviews {
                        subview.removeFromSuperview()
                    }
                    
                    // Добавляем UIImageView на представление catPictureView
                    self.catPictureView.addSubview(imageView)
                }
            case .failure(let error):
                // Обработка ошибок
                self.showErrorAlert(text: "Ошибка при получении изображения")
                print("Ошибка при получении картинки кошки: \(error)")
            }
        }
    }
    
    //MARK: - Other functions
    func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Ошибка!", message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
