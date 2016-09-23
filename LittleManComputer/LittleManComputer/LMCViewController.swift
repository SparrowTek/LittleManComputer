//
//  ViewController.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

import UIKit

class LMCViewController: UIViewController {
    
    @IBOutlet weak var assemblyCodeTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    
    @IBOutlet weak var stepMessageLabel: UILabel!
    
    @IBOutlet weak var programCounterLabel: UILabel!
    @IBOutlet weak var accumulatorLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var assembleIntoRamButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    
    //lazy var registerTextFieldArray = registersVC.createRegisterTextFieldArray()
    //var registerTextFieldArray: [UITextField]!
    private var registersVC: RegistersViewController!
    
    var activeTextField: UITextField?
    
    var programHalted = false
    var runNotStep = false
    var runSteppingSpeed: Double = 1.0 // TODO: allow user to adjust the run speed in a future version
    
    var littleManComputerModel: LittleManComputerModel!
    //var registers: Registers!
    let registers = Registers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if UIDevice.currentDevice.userInterfaceIdiom == .Pad {
            registers = (tabBarController as! TabRootViewController).registers
            coreDataStack = (tabBarController as! TabRootViewController).coreDataStack
        }
        else {
            registers = (navigationController as! NavRootViewController).registers
            coreDataStack = (navigationController as! NavRootViewController).coreDataStack
        }*/
        
        littleManComputerModel = LittleManComputerModel(registers: registers)
        littleManComputerModel.delegate = self
        //createRegisterTextFieldArray()
        //registerTextFieldArray = registersVC.createRegistersArray()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LMCViewController.hideKeyboard(touches:)))
        view.addGestureRecognizer(gestureRecognizer)
        
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterFromKeyboardNotifications()
    }
    
    private func setupButtons(){
        assembleIntoRamButton.layer.cornerRadius = 5  // creates rounded corners
        assembleIntoRamButton.clipsToBounds = true
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        
        stepButton.layer.cornerRadius = 5
        stepButton.clipsToBounds = true
        runButton.layer.cornerRadius = 5
        runButton.clipsToBounds = true
        
    }
    
    private func assembleAndReset() {
        littleManComputerModel.reset()
        resetView()
        littleManComputerModel.loadRegisters(code: assemblyCodeTextView.text, completion: { (error) -> Void in
            
            if let error = error {
                
                self.handleError(error: error)
            }
            
            self.setRegisters(resetToZero: false)
        })
    }
    
    private func resetView() {
        programCounterLabel.text = "00"
        accumulatorLabel.text = "000"
        outputTextView.text = nil
        inputLabel.text = "000"
        stepMessageLabel.text = "Enter program"
        programHalted = false
        
        for index in 0...99 {
            //registerTextFieldArray[index].text = "000"
            registersVC.registerTextFieldArray[index].text = "000"
        }
    }
    
    private func executeRun() {
        perform(#selector(LMCViewController.executeStep), with: nil, afterDelay: runSteppingSpeed)
    }
    
    func executeStep() {
        littleManComputerModel.compileAndStep(completion: { (stepDetail: String?, programCounter: Int, accumulator: Int, needInput: Bool, halt: Bool, error: CompileError?) -> Void in
            
            self.stepAndRunHelper(stepDetail: stepDetail, programCounter: programCounter, accumulator: accumulator, needInput: needInput, halt: halt, error: error)
        })
    }
    
    private func stepAndRunHelper(stepDetail: String?, programCounter: Int, accumulator: Int, needInput: Bool, halt: Bool, error: CompileError?) {
        
        if needInput {
            stepMessageLabel.text = stepDetail
            getInput()
            return
        }
        
        if let error = error {
            self.littleManComputerModel.reset()
            handleError(error: error)
        }
        else {
            if halt {
                self.littleManComputerModel.reset()
                programHalted = true
            }
            
            self.programCounterLabel.text = String(format: "%02d", programCounter)
            self.accumulatorLabel.text = String(format: "%03d", accumulator)
            self.stepMessageLabel.text = stepDetail
            
            if runNotStep && !halt {
                executeRun()
            }
            
        }
    }
    
    private func getInput() {
        let alert = UIAlertController(title: "Enter Input", message: "Enter an integer between 0 and 999 to continue", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Input"
        })
        
        let inputAction = UIAlertAction(title: "Enter", style: .default, handler: { (action) in
            if let text = alert.textFields!.first!.text {
                
                if let value = Int(text) , value >= 0 && value <= 999 {
                    self.littleManComputerModel.inboxSet = true
                    self.littleManComputerModel.inbox = value
                    
                    if self.runNotStep {
                        self.executeRun()
                    }
                    else {
                        self.executeStep()
                    }
                }
                else {
                    self.createErrorAlert(message: "1") // TODO: handle error
                }
            }
            else {
                self.createErrorAlert(message: "2") // TODO: handle error
            }
            
        })
        
        alert.addAction(inputAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func handleError(error: CompileError) {
        switch error {
        case CompileError.branchError:
            createErrorAlert(message: "Branch error: If the accumulator is less than 0 or greater than 999 a branch cannot occur")
        case CompileError.invalidAssemblyCode:
            createErrorAlert(message: "The assembly code that you entered is not valid. Please adjust your code and try again")
        case CompileError.mailboxOutOfBounds:
            createErrorAlert(message: "Mailbox out of bounds. Mailbox values must be between 0 and 99")
        case CompileError.unknownError:
            createErrorAlert(message: "If you see this error, congratulations! You have completly destroyed the LMC model logic")
        }
    }
    
    private func createErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: {
            self.assembleAndReset()
        })
    }
    
    private func setRegisters(resetToZero bool: Bool) {
        
        func ensureThreeDigitsInRegister(index: Int) -> String {
            if bool {
                return "000"
            }
            return String(format: "%03d", registers[index])
        }
        
        for index in 0...99 {
            registersVC.registerTextFieldArray[index].text = ensureThreeDigitsInRegister(index: index)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegistersViewController , segue.identifier == "RegistersSegue" {
            registersVC = vc
        }
    }
    
    // MARK: keyboard and textField
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LMCViewController.keyboardWasShown(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LMCViewController.keyboadWillBeHidden(aNotification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterFromKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        if assemblyCodeTextView.isFirstResponder { // TODO: adjust how high scrolling occurs when keyboard is displayed
            let info = notification.userInfo!
            //let keyboardFrame:CGSize = info[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
            let keyboardFrame:CGSize = (info[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
            assemblyCodeTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.height, 0)
            assemblyCodeTextView.scrollIndicatorInsets = assemblyCodeTextView.contentInset
        }
        else {
            var info = notification.userInfo!
            var keyboardFrame:CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            //var contentInset:UIEdgeInsets = registersScrollView.contentInset
            //contentInset.bottom = keyboardFrame.size.height + (view.frame.minY - registersView.frame.minY)
            //registersScrollView.contentInset = contentInset // TODO: uncomment these 3 lines after a scroll view is added to the view
            
/*var info = notification.userInfo!
 var keyboardFrame:CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
 keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
 
 var contentInset:UIEdgeInsets = registersScrollView.contentInset
 contentInset.bottom = keyboardFrame.size.height + (view.frame.minY - registersView.frame.minY)
 registersScrollView.contentInset = contentInset*/
        }
    }
 
    func keyboadWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        //registersScrollView.contentInset = contentInsets
        //registersScrollView.scrollIndicatorInsets = contentInsets //TODO: uncomment these 2 lines after a scroll view is added to the view
        
        assemblyCodeTextView.contentInset = contentInsets
        assemblyCodeTextView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        for index in 0...99 {
            if registersVC.registerTextFieldArray[index].text != nil {
                if let value = Int(registersVC.registerTextFieldArray[index].text!) , value >= 0 && value <= 999 {
                    registers[index] = value
                }
                else {
                    createErrorAlert(message: "RAM registers must contain an integer between 0 and 999")
                }
            }
            else {
                createErrorAlert(message: "") // TODO: handle error
                activeTextField = nil
                return
            }
        }
        activeTextField = nil
    }
    
    func hideKeyboard(touches: AnyObject) {
        activeTextField?.resignFirstResponder()
        
        if assemblyCodeTextView.isFirstResponder {
            assemblyCodeTextView.resignFirstResponder()
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: button actions
    @IBAction func run() {
        if programHalted {
            resetView()
        }
        runNotStep = true
        executeRun()
    }
    @IBAction func step() {
        if programHalted {
            resetView()
        }
        runNotStep = false
        executeStep()
    }
    @IBAction func assembleIntoRam() {
        assembleAndReset()
    }
    @IBAction func reset() {
        setRegisters(resetToZero: true)
        assembleAndReset()
    }
}

// MARK: LMCDelegate methods
extension LMCViewController: LMCDelegate {
    func setOutbox(_ outboxValue: Int) {
        outputTextView.text = outputTextView.text + String(format: "%03d", outboxValue) + "\n"
    }
}

