//
//  ViewController.swift
//  NativeRequest
//
//  Created by DISMOV on 13/05/22.
//

import UIKit

extension ViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personajes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ri, for: indexPath)
        let dict = personajes[indexPath.row]
        cell.textLabel?.text = dict["name"] as? String ?? "Un personaje"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "tDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let nuevoVC = segue.destination as! ViewControllerD
            if let indexPath = tableV.indexPathForSelectedRow{
                let personaje = personajes[indexPath.row]
                nuevoVC.personaje = personaje
            }
    }
    
}

class ViewController: UIViewController {
    var tableV = UITableView()
    var personajes = [[String:Any]]()
    let ri = "reusedId"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        let _ = InternetStatus.instance
        
        /*
        self.view.frame // Propiedades "generales" respecto al superview
        self.view.bounds // propiedades "especificas" respecto a su propia orientacion
        */
        tableV.frame = self.view.bounds
        self.view.addSubview(tableV)
        tableV.register( UITableViewCell.self, forCellReuseIdentifier: ri)
        tableV.dataSource = self
        tableV.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var alrt = UIAlertController(title: "Error",message: "No hay conexion a internet", preferredStyle: .alert)
        
        if InternetStatus.instance.internetType == .none{
            alrt = UIAlertController(title: "Error",message: "No hay conexion a internet", preferredStyle: .alert)
            alrt.addAction(UIAlertAction(title: "Ok", style: .default){  alert in
                exit(666);
            })
            self.present(alrt,animated: true)
        }else if InternetStatus.instance.internetType == .cellular{
            alrt = UIAlertController(title: "Confirmacion",message: "Conexion solo por Datos Celular", preferredStyle: .alert)
            let btn1 = UIAlertAction(title: "Continuar", style: .default){
                elrt in
                self.descargar()
            }
            alrt.addAction(btn1)
            alrt.addAction(UIAlertAction(title: "Cancelar", style: .cancel,handler: nil))
            
            self.present(alrt,animated: true)
        }else{
            descargar()
        }
    }
    
    func descargar(){
        if let url = URL (string: "https://rickandmortyapi.com/api/character") {
            let request = NSMutableURLRequest(url: url)
            
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let tarea = session.dataTask(with: request as URLRequest){
                datos, respuesta, error in
                
                if error != nil {
                    print("Algo salio mal. \(error?.localizedDescription)")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: datos!, options: .fragmentsAllowed) as! [String: Any]
                        // Presentar apropiadamente la info
                        //print(json)
                        self.personajes = json["results"] as! [[String:Any]]
                        DispatchQueue.main.async {
                            self.tableV.reloadData()
                        }
                    }catch{
                        print("Algo salio mal al convertir JSON \(error.localizedDescription)")
                    }
                }
            }
            tarea.resume()
        }
            }
            
    }





