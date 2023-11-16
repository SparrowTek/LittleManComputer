# LittleManComputer

-Learn about Little Man Computer and how to structure the assembly language code here: https://en.wikipedia.org/wiki/Little_man_computer 

-Support for iOS and iPadOS

-Enter code into the text field where is says, "Enter assembly code here..." Once the code is entered select the "Assemble into RAM button" After the RAM registers are populated you can either "Step" or "Run" the program

-You may also enter code directly into the RAM registers or "mailboxes"

-Sample code to try:  
LDA ONE   
ADD TEN  
OUT  
INP  
ADD THREE  
OUT  
HLT  
ONE DAT 001  
TEN DAT 010  
THREE DAT 003  

Your output should be 011 and 3 plus the input value you enter

## Project State

The code in this repo is live in the Apple iOS App Store

## Contributing

It is always a good idea to **discuss** before taking on a significant task. That said, I have a strong bias towards enthusiasm. If you are excited about doing something, I'll do my best to get out of your way.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

### Building

**Note**: requires Xcode 15 and macOS 14

- clone the repo
- `cp User.xcconfig.template User.xcconfig`
- update `User.xcconfig` with your personal information
- build/run with Xcode
