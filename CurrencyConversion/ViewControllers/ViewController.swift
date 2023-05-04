//
//  ViewController.swift
//  CurrencyConversion
//
//  Created by Vaibhav Sadana on 29/04/23.
//

import UIKit

class ViewController: BaseClassVC {
    
    @IBOutlet weak var btnSelectedCurrency: UIButton!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownCollectionView: UICollectionView!
    @IBOutlet weak var lblNorecord: UILabel!
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    @IBOutlet weak var lblAmount: UITextField!
    
    //variables
    let vmObj = CurrencyViewModel()
    var baseCurrency  :  CurrencyEnum = .USD  {
        didSet {
            getCurrencyData()
        }
    }
    var currentCurrecyAmt : Double = 1
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let data = UserDefaults.standard.currencyData, !data.isEmpty {
            //nothing
            if (CurrencyEnum(rawValue: UserDefaults.standard.currencyData?["base"] as! String) ?? .USD) != .USD  {
                baseCurrency = .USD
            }
        } else {
            getCurrencyData()
        }
        addDelegates()
        currencyCollectionView.collectionViewLayout = generateLayout()
        dropDownCollectionView.collectionViewLayout = generateLayoutForDropDown()
        lblAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lblAmount.inputAccessoryView = toolBar()
        timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
        setupUI()
    }
    
    //MARK: get latest data every 30 mins
    @objc func fetchData(){
        getCurrencyData()
    }
    
    func setupUI(){
        btnSelectedCurrency.layer.cornerRadius = 8
        dropDownView.layer.cornerRadius = 10
        dropDownCollectionView.layer.cornerRadius = 10
        
    }
    
    //MARK: add delegates
    func addDelegates(){
        currencyCollectionView.register(UINib(nibName: "CurrencyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "currencyCollectionViewCell")
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        dropDownCollectionView.dataSource = self
        dropDownCollectionView.delegate = self
        lblAmount.delegate = self
        delegate = self
        
    }
    
    //MARK: get data currency from openexchange
    func getCurrencyData(){
        vmObj.getCurrencyData(app_id: app_id,baseCurrency: baseCurrency.rawValue) { data in
            if data != nil {
                UserDefaults.standard.currencyData =  data
                DispatchQueue.main.async {
                    self.currencyCollectionView.isHidden = false
                    self.lblNorecord.isHidden = true
                    self.currencyCollectionView.reloadData()
                    self.dropDownCollectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.currencyCollectionView.isHidden = true
                    self.lblNorecord.isHidden = false
                }
            }
        }
    }
    
    @IBAction func selectCurrencyTapped(_ sender: Any) {
        dropDownView.isHidden = !dropDownView.isHidden
        dropDownView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0,options: .curveEaseInOut) {
            self.dropDownView.alpha = 1
        }
    }
}


//MARK: - collection view delegate methods
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    //MARK: generate layout of collection view
    private func generateLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout{(sectionIndex:Int,layoutEnvironment:NSCollectionLayoutEnvironment)->NSCollectionLayoutSection? in
            let itemsize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: itemsize)
            var group : NSCollectionLayoutGroup!
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: itemsize, repeatingSubitem: item, count: 3)
            } else {
                // Fallback on earlier versions
                group = NSCollectionLayoutGroup.horizontal(layoutSize: itemsize, subitem: item, count: 3)
            }
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 5, bottom: 20, trailing: 0)
            return section
        }
        return layout
    }
    
    //MARK: generate layout of collection view
    private func generateLayoutForDropDown() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{(sectionIndex:Int,layoutEnvironment:NSCollectionLayoutEnvironment)->NSCollectionLayoutSection? in
            
            let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let item = NSCollectionLayoutItem(layoutSize: itemsize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemsize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 20, trailing: 0)
            return section
        }
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data =  UserDefaults.standard.currencyData?["rates"] as? [String:Any]
        return data?.keys.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rates = UserDefaults.standard.currencyData?["rates"] as! [String:Any]
        let sortedKeys = Array(rates.keys).sorted{
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }
        let firstKey = Array(sortedKeys)[indexPath.row]
        
        if collectionView == currencyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currencyCollectionViewCell", for: indexPath) as! CurrencyCollectionViewCell
            cell.configure(amount: getConvertedMoney(rates[firstKey]), lblCurrencyName: firstKey)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DropdownCollectionViewCell
            cell.lblCurrencyName.text = firstKey
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rates = UserDefaults.standard.currencyData?["rates"] as! [String:Any]
        let sortedKeys = Array(rates.keys).sorted{
            $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending
        }
        let firstKey = Array(sortedKeys)[indexPath.row]
        if collectionView == dropDownCollectionView {
            btnSelectedCurrency.setTitle(firstKey, for: .normal)
            dropDownView.isHidden  = true
            baseCurrency = CurrencyEnum(rawValue: firstKey) ?? .USD
        }
    }
    
    //MARK: get converted money
    func getConvertedMoney(_ moneyConverted: Any?)->Double{
        if  moneyConverted is String {
            return currentCurrecyAmt * Double(moneyConverted as! String)!
        } else {
            return currentCurrecyAmt * (moneyConverted as! Double)
        }
    }
}

//MARK: textfield delegates
extension ViewController : TextFieldProtocol {
    func didAmountChangeInTf(text: String) {
        currentCurrecyAmt = text.isEmpty ? 1 : Double(text)!
        currencyCollectionView.reloadData()
    }
}
