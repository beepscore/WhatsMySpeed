# Purpose:
Do unit test exercises in Lynda.com tutorial.  

# References:
Unit Testing iOS Applications with Xcode 4 with Ron Lisle  
<http://www.lynda.com/iOS-tutorials/Unit-Testing-iOS-Applications-Xcode/91949-2.html>

About Unit Testing  
Written for Xcode 4.2  
<http://developer.apple.com/library/ios/#documentation/DeveloperTools/Conceptual/UnitTesting/00-About_Unit_Testing/about.html#//apple_ref/doc/uid/TP40002143>

iOS application unit tests from the command line: Xcode 4.5 update  
<http://longweekendmobile.com/2012/11/11/ios-application-unit-tests-from-the-command-line-xcode-4-5-update/>

Xcode 4.5 command line unit testing  
<http://stackoverflow.com/questions/12557935/xcode-4-5-command-line-unit-testing?lq=1>

Xcode 4: Run tests from the command line (xcodebuild)?  
<http://stackoverflow.com/questions/5403991/xcode-4-run-tests-from-the-command-line-xcodebuild/10823483#10823483>

# Results:
The project code is based on code copyright Lynda.com.

## Logic Tests vs Application Tests

|                       | Logic                      | Application                                   |
| ---------             | -----                      | -----------                                   |
| Code                  | must include all code used | Can reference objects in application bundle   |
| Platform              | simulator                  | simulator or device                           |
| How to add to project | Add Target                 | when creating app, check "include unit tests" |


## Application Tests
In application tests the application bundle is loaded before the tests are run.
Test doesn't need to instantiate objects from application.  
