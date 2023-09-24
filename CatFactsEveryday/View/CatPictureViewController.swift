//
//  CatPictureViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import UIKit

class CatPictureViewController: UIViewController {

    @IBOutlet var catPictureView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
                print("Ошибка при получении картинки кошки: \(error)")
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
