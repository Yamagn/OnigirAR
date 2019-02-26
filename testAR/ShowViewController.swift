//
//  ShowRecordViewController.swift
//  testAR
//
//  Created by 高橋剛 on 2019/02/26.
//  Copyright © 2019年 ymgn. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let Kororin = OmusubiKororin()
    var swichText : String!
    var swichKey : String!
    
    var tabelDataArray : [table.Ranking] = []
    
    struct table : Codable{
        var ranking:[Ranking]
        struct Ranking : Codable{
            let name : String?
            let point : Int!
        }
    }
    
    
    @IBOutlet weak var recordTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backToStart(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = swichText
        swichKey = (swichText == "ラ ン キ ン グ") ? "rank":"score"
        
        switch swichKey {
        case "rank":
            print("ランキングを表示します")
            rankAction()
        case "score":
            print("スコア一覧を表示します")
            scoreAction()
        default:
            print("予期せぬエラー")
        }
    }
    
    func rankAction(){
        let httpSession = HttpClientImpl()
        let url:URL = URL(string: "http://wp-16416.azurewebsites.net/hackthon/showRanking.php")!
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = "POST"
        let (data, _, _) = httpSession.execute(request: req as URLRequest)
        if data != nil {
            print("受信結果 \n\(String(data: data!, encoding: String.Encoding.utf8)!)")
            
            let decoder: JSONDecoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let decodedData = try decoder.decode(table.self, from: data!)
                tabelDataArray = decodedData.ranking
                tabelDataArray.removeFirst()
                recordTableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func scoreAction(){
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let targetPath = documentPath + "/score.txt"
        do {
            let text = try String( contentsOfFile: targetPath, encoding: String.Encoding.utf8)
            var strs = text.split(separator: "$")
            strs.removeFirst()
            var Points:[Int] = []
            for s in strs{
                Points.append(Int(s)!)
            }
            Points.sort(by: {$0 > $1})
            for p in  Points{
                tabelDataArray.append(.init(name: nil, point: p))
            }
            recordTableView.reloadData()
            
        } catch let error as NSError{
            print("読み込みエラー:\(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabelDataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (swichKey == "rank") ? 155:95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch swichKey {
        case "rank":
            let cell = tableView.dequeueReusableCell(withIdentifier: "rank") as! RankingTableViewCell
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.numLabel.text = "\(indexPath.row + 1)"
            cell.pointLabel.text = "\(tabelDataArray[indexPath.row].point!)点"
            cell.nameLabel.text = tabelDataArray[indexPath.row].name
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(tapGesture(sender:)))
            cell.tapView.tag = indexPath.row
            cell.tapView.accessibilityIdentifier = "cell"
            cell.tapView.addGestureRecognizer(tapGesture)
            return cell
        case "score":
            let cell = tableView.dequeueReusableCell(withIdentifier: "score") as! ScoreTableViewCell
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.numLabel.text = "\(indexPath.row + 1)"
            cell.pointLabel.text = "\(tabelDataArray[indexPath.row].point!)点"
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(tapGesture(sender:)))
            cell.tapView.tag = indexPath.row
            cell.tapView.accessibilityIdentifier = "cell"
            cell.tapView.addGestureRecognizer(tapGesture)
            return cell
        default:
            print("予期せぬエラー")
        }
        return UITableViewCell()
    }
    @objc func tapGesture(sender: UITapGestureRecognizer){
        if sender.view?.accessibilityIdentifier == "cell"{
            let targetCell = recordTableView.cellForRow(at: [0,(sender.view?.tag)!])
            let view = targetCell!.contentView.viewWithTag(3) as! UIImageView
            Kororin.kororin(view: view)
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
    
    
    
    /*
     let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
     let targetPath = documentPath + "/score.txt"
     let output = OutputStream(toFileAtPath: targetPath, append: true)
     output?.open()
     let bytes = [UInt8]("$900".data(using: .utf8)!)
     let size = "$900".lengthOfBytes(using: .utf8)
     output?.write(bytes, maxLength: size)
     output?.close()
     */
}
