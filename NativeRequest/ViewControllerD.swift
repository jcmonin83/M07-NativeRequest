//
//  ViewControllerD.swift
//  NativeRequest
//
//  Created by DISMOV on 16/05/22.
//

import UIKit

class ViewControllerD: UIViewController {
    @IBOutlet weak var Nombre: UILabel!
    @IBOutlet weak var Imagen: UIImageView!
    @IBOutlet weak var Especie: UILabel!
    @IBOutlet weak var Estatus: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
    var personaje = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Nombre.text = personaje["name"] as? String ?? "Nombre"
        Especie.text = personaje["species"] as? String ?? "Especie"
        Estatus.text = personaje["status"] as? String ?? "Estatus"
    }
    private func getImage(){
        guard let url = URL(string: personaje["image"] as? String ?? "https://cdn.iconscout.com/icon/premium/png-256-thumb/no-link-3313634-2793905.png" ) else { return }
        let req = URLRequest(url: url)
        let sess = URLSession(configuration: .default)
        
        //sess.dataTask(with: req) {dat, res, er, in
        sess.dataTask(with: req){ data, response, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                guard let d = data else { return }
                do{
                    DispatchQueue.main.async {
                        self.Imagen.image = UIImage(data:d)
                    }
                }catch{
                    print("Error al obtener JSON \(error.localizedDescription)")
                }
            }
        }.resume()
        
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
