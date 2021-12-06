//
//  SwapViewController.swift
//  AlphaWallet
//
//  Created by Mac Pro on 01/12/21.
//

import UIKit

class SwapViewController: UIViewController {

    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var exchangeFromCurrencyImageVIew: UIImageView!
    @IBOutlet weak var exchangeFromBalanceLabel: UILabel!
    @IBOutlet weak var exchangeFromCurrencyLabel: UILabel!
    @IBOutlet weak var exchangeFromCurrencyTextField: UITextField!
    @IBOutlet weak var exchangeToCurrencyImageVIew: UIImageView!
    @IBOutlet weak var exchangeToCurrencyLabel: UILabel!
    @IBOutlet weak var exchangeToCurrencyTextField: UITextField!
    @IBOutlet weak var exchangeToBalanceLabel: UILabel!

    @IBOutlet weak var currencyConversionView: UIView!
    @IBOutlet weak var currencyConversionLabel: UILabel!

    @IBOutlet weak var swapButton: UIButton!
    
    @IBOutlet weak var exchangeFromDropDownButton: UIButton!
    @IBOutlet weak var exchangeToDropDownButton: UIButton!
    @IBOutlet weak var enterAmountButton: UIButton!
    
    private let viewModel = SwapViewModel()
    private var dropDownView: SwapDropDownView?
    var fromCurrencyItem: SwapDropDownModel?
    var toCurrencyItem: SwapDropDownModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor
        self.title = viewModel.navigationTitle
        currencyConversionView.isHidden = true
        fromCurrencyItem = viewModel.object(at: 0)
        toCurrencyItem = viewModel.object(at: 1)
        configureUI()
    }
    
    @IBAction func swapButtonAction(_ sender: Any) {
        let swapModel = fromCurrencyItem
        fromCurrencyItem = toCurrencyItem
        toCurrencyItem = swapModel
        configureUI()
    }
    
    @IBAction func exchangeFromDropDownButtonAction(_ sender: UIButton) {
        let dropDown = createDropDown(button: sender, view: exchangeView)
        self.dropDownView = dropDown
        dropDown.configure(viewModel: viewModel) { [weak self] (item) in
            guard let self = self else { return }
            self.fromCurrencyItem = item
            self.configureUI()
        }
        view.addSubview(dropDown)
    }
    
    @IBAction func exchangeToDropDownButtonAction(_ sender: UIButton) {
        let dropDown = createDropDown(button: sender, view: toView)
        self.dropDownView = dropDown
        dropDown.configure(viewModel: viewModel) { [weak self] (item) in
            guard let self = self else { return }
            self.toCurrencyItem = item
            self.configureUI()
        }
        view.addSubview(dropDown)
    }
    
    private func createDropDown(button: UIButton, view: UIView) -> SwapDropDownView {
        removeDropDrowView()
        let dropDown = SwapDropDownView.instanceFromNib()
        let xPosition = view.frame.origin.x + button.frame.origin.x
        let yPosition = view.frame.origin.y + button.frame.origin.y + button.frame.size.height
        let width = button.frame.size.width
        dropDown.frame = CGRect(x: xPosition, y: yPosition, width: width, height: viewModel.dropDownHeight())
        dropDown.cornerRadius = 8
        dropDown.borderWidth = 2
        dropDown.borderColor = Colors.headerThemeColor
        return dropDown
    }

    func removeDropDrowView() {
        dropDownView?.removeFromSuperview()
    }
    
    @IBAction func enterAmountButtonAction(_ sender: Any) {
        removeDropDrowView()
        if isSwapButon() {
            let controller = ConfirmSwapViewController(nibName: "ConfirmSwapViewController", bundle: nil)
            controller.modalPresentationStyle = .overCurrentContext
            controller.fromCurrencyItem = fromCurrencyItem
            controller.toCurrencyItem = toCurrencyItem
            controller.delegate = self
            controller.modalTransitionStyle = .crossDissolve
            tabBarController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        if let item = fromCurrencyItem {
            self.exchangeFromCurrencyLabel.text = item.title
            self.exchangeFromCurrencyImageVIew.image = item.image
        }
        
        if let item = toCurrencyItem {
            self.exchangeToCurrencyLabel.text = item.title
            self.exchangeToCurrencyImageVIew.image = item.image
        }
        if let from = exchangeFromCurrencyLabel.text, let to = exchangeToCurrencyLabel.text, !from.isEmpty, !to.isEmpty {
            currencyConversionLabel.text = "1 \(from) - 1 \(to)"
        }
        self.removeDropDrowView()
        self.isSwapButon()
    }
    
    @discardableResult
    private func isSwapButon() -> Bool {
        if fromCurrencyItem != nil && toCurrencyItem != nil {
            enterAmountButton.setTitle(viewModel.swapButtonTitle(isSwap: true), for: .normal)
            currencyConversionView.isHidden = false
            return true
        }
        currencyConversionView.isHidden = true
        enterAmountButton.setTitle(viewModel.swapButtonTitle(isSwap: false), for: .normal)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeDropDrowView()
    }
    
}

extension SwapViewController: ConfirmSwapDelegate {
    func confirm(fromCurrency: SwapDropDownModel, toCurrency: SwapDropDownModel) {
        let controller = WaitSwapConfirmationViewController(nibName: "WaitSwapConfirmationViewController", bundle: nil)
        controller.modalPresentationStyle = .overCurrentContext
        controller.fromCurrencyItem = fromCurrency
        controller.toCurrencyItem = toCurrency
        controller.modalTransitionStyle = .crossDissolve
        tabBarController?.present(controller, animated: true, completion: nil)
    }
}
