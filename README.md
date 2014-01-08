Transcript
==========

SenTestObserver is designed in such a way that creating objects which output test data to the console can be more difficult than necessary.

Transcript makes it easier to customise SenTestingKit test output.

The following test case:

    @implementation SomeTests
    - (void)testGasIsOn {}
    - (void)testEggsAreFlipped
    {
        [NSException raise:NSInternalInconsistencyException format:@"failed to find eggs"];
    }
    - (void)testBaconIsCooked {}
    - (void)testSausagesAreCooked {}
    - (void)testToastIsReady {}
    @end

Will produce the following test output:

    SomeTests started.
        -[SomeTests testBaconIsCooked]
    [F]	-[SomeTests testEggsAreFlipped]
    	-[SomeTests testGasIsOn]
    	-[SomeTests testSausagesAreCooked]
    	-[SomeTests testToastIsReady]

    [F] -[SomeTests testEggsAreFlipped]
    	Unknown.m:0: failed to find eggs
    SomeTests ended.

If you're using a different testing tool, Transcript will work with no additional effort, provided that each test provides a useful name:

    TSCObserverSpecification started.
        should override the default SenTestObserver class in NSUserDefaults in +load
      	+activeReporter should be an instance of TSCTidyReporter
      	+testSuiteDidStart: should forward to active reporter's -suiteDidStart:
      	+testStepDidStart: should forward to active reporter's -testDidStart:
      	+testStepDidFail: should forward to active reporter's -testDidFail:
      	+testStepDidStop: should forward to active reporter's -testDidEnd:
      	+testSuiteDidStop: should forward to active reporter's -suiteDidEnd:
    TSCObserverSpecification ended.

This is the default logging format.

Custom logging formats can be easily implemented by writing a custom class which conforms to `TSCReporter`. To see an example implementation, see the `TSCTidyReporter` class.

Important note
==============

Xcode relies on a specific logging format to provide error reporting as part of its user interface - that is, green and red tests. Transcript is useful if you rely more on console support or are building tests from the command line, but not if you rely on support from the Xcode interface.

Installation
============

To use Transcript, include it in your Podfile: `pod 'Transcript', '~> 0.1.0'`.

License
=======

    Copyright (c) 2013 Ryan Davies
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
