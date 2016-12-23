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
    @IBOutlet weak var registersScrollView: UIScrollView!
    fileprivate var registersVC: RegistersViewController!
    var activeTextField: UITextField?
    var programHalted = false
    var runNotStep = false
    var runSteppingSpeed: Double = 0.05 // TODO: allow user to adjust the run speed in a future version
    var littleManComputerModel: LittleManComputerModel!
    let registers = Registers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initalize the LMC model and set its delegate
        littleManComputerModel = LittleManComputerModel(registers: registers)
        littleManComputerModel.delegate = self
        
        // add a gesture recognizer to the view
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(touches:)))
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
    
    // adjust the appearance of the buttons in the view
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
    
    // resets the view and loads the registers using the LMC model
    private func assembleAndReset() {
        littleManComputerModel.reset()
        resetView()
        
        for index in 0...99 {
            registersVC.registerTextFieldArray[index].text = "000"
        }
        
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
        stepMessageLabel.text = "Step or Run code"
        programHalted = false
        registersVC.resetApperanceOfRegisters()
    }
    
    // runs the program. automatically steps through the program at the rate of 'runSteppingSpeed'
    private func executeRun() {
        perform(#selector(executeStep), with: nil, afterDelay: runSteppingSpeed)
    }
    
    // uses the LMC model to execute the next step of the program
    func executeStep() {
        littleManComputerModel.compileAndStep(completion: { (stepDetail: String?, programCounter: Int, accumulator: Int, needInput: Bool, halt: Bool, error: CompileError?) -> Void in
            
            self.stepAndRunHelper(stepDetail: stepDetail, programCounter: programCounter, accumulator: accumulator, needInput: needInput, halt: halt, error: error)
        })
    }
    
    // adjusts the view UI based on the feedback from the executed step provided by the LMC model
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
            
            setRegisters(resetToZero: false)
            
            self.programCounterLabel.text = String(format: "%02d", programCounter)
            self.accumulatorLabel.text = String(format: "%03d", accumulator)
            self.stepMessageLabel.text = stepDetail
            
            if runNotStep && !halt {
                executeRun()
            }
            
        }
    }
    
    // gets an input value from the user when an input command is executed
    // handles all unsupported inputs from the user with a message to the user
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
                    self.createErrorAlert(message: "The input value must be an integer between 0 - 999")
                }
            }
            else {
                self.createErrorAlert(message: "The input value must be an integer between 0 - 999")
            }
            
        })
        
        alert.addAction(inputAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // display an error message to the user based on the error type
    private func handleError(error: CompileError) {
        switch error {
        case CompileError.invalidAssemblyCode:
            createErrorAlert(message: "The assembly code that you entered is not valid. Please adjust your code and try again")
        case CompileError.mailboxOutOfBounds:
            createErrorAlert(message: "Mailbox out of bounds. Mailbox values must be between 0 and 99")
        case CompileError.unknownError:
            createErrorAlert(message: "If you see this error, congratulations! You have completly destroyed the LMC model logic")
        }
    }
    
    fileprivate func createErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops..", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // updates the view to display the proper value in each register
    private func setRegisters(resetToZero: Bool) {
        
        func ensureThreeDigitsInRegister(index: Int) -> String {
            if resetToZero {
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
            registersVC.delegate = self
        }
    }
    
    // MARK: keyboard methods
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboadWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterFromKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // adjusts the UI so that the content of the view is still visible while the keyboard is on screen
    func keyboardWasShown(notification: NSNotification) {
        
        if assemblyCodeTextView.isFirstResponder { // TODO: adjust how high scrolling occurs when keyboard is displayed
            let info = notification.userInfo!
            let keyboardFrame:CGSize = (info[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
            assemblyCodeTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.height - 100, 0)
            assemblyCodeTextView.scrollIndicatorInsets = assemblyCodeTextView.contentInset
            
            if assemblyCodeTextView.text == "Enter assembly code here..." {
                assemblyCodeTextView.text = ""
            }
            
        } else if registersVC.activeTextField != nil {
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = registersScrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            registersScrollView.contentInset = contentInset
        } else {
            var info = notification.userInfo!
            var keyboardFrame:CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        }
    }
 
    // adjusts the ui to adjust for the keyboard to be removed from the screen
    func keyboadWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        registersScrollView.contentInset = contentInsets
        registersScrollView.scrollIndicatorInsets = contentInsets
        
        assemblyCodeTextView.contentInset = contentInsets
        assemblyCodeTextView.scrollIndicatorInsets = contentInsets
    }
    
    // hides the keyboard
    func hideKeyboard(touches: AnyObject) {
        registersVC.activeTextField?.resignFirstResponder()
        
        if assemblyCodeTextView.isFirstResponder {
            assemblyCodeTextView.resignFirstResponder()
        }
    }
    
    // MARK: button actions
    
    // Run the program without the user manually stepping through each command
    @IBAction func run() {
        if programHalted {
            resetView()
        }
        runNotStep = true
        executeRun()
    }
    
    // Run the program one regiter at a time and only advance when the user selects the "step" button
    @IBAction func step() {
        
        if programHalted {
            resetView()
        }
        runNotStep = false
        executeStep()
    }
    
    // analyze assembly language code and fill the memory registers
    @IBAction func assembleIntoRam() {
        assembleAndReset()
    }
    
    // reset the UI
    @IBAction func reset() {
        setRegisters(resetToZero: true)
        assembleAndReset()
    }
    
}

// MARK: RegistersDelegate
extension LMCViewController: RegistersDelegate {
    func RegisterTextFieldDidEndEditing() {
        for index in 0...99 {
            if registersVC.registerTextFieldArray[index].text != nil {
                if let value = Int(registersVC.registerTextFieldArray[index].text!) , value >= 0 && value <= 999 {
                    registers[index] = value
                }
                else {
                    createErrorAlert(message: "RAM registers must contain an integer between 0 and 999.\n Check register \(index)")
                }
            }
            else {
                createErrorAlert(message: "An error has occured with the RAM registers.")
                activeTextField = nil
                return
            }
        }
    }
}

// MARK: LMCDelegate
extension LMCViewController: LMCDelegate {
    func setOutbox(_ outboxValue: Int) {
        outputTextView.text = outputTextView.text + String(format: "%03d", outboxValue) + "\n"
    }
    
    func setCurrentRegisterBeingEvaluated(_ register: Int) {
        registersVC.resetApperanceOfRegisters()
        registersVC.registerTextFieldArray[register].backgroundColor = .sparrowTekGreen()
        registersVC.registerTextFieldArray[register].textColor = .white
    }
}
