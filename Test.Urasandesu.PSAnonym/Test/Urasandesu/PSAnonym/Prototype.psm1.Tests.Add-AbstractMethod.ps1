# 
# File: Prototype.psm1.Tests.Add-AbstractMethod.ps1
# 
# Author: Akira Sugiura (urasandesu@gmail.com)
# 
# 
# Copyright (c) 2012 Akira Sugiura
#  
#  This software is MIT License.
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#



function Test.Add-AbstractMethod_ShouldAddAbstractMethod_IfPrototypeIsPassed {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock

    # Act
    $result = 
        $mock | 
            Add-AbstractMethod Generate

    # Assert
    Assert-InstanceOf ([psobject]) $result
    try {
        $result.Generate()
        Assert-Fail
    } catch [Management.Automation.MethodInvocationException] {
        $innerException = $_.Exception.InnerException
        Assert-InstanceOf ([Management.Automation.RuntimeException]) $innerException
        $innerException = $innerException.InnerException
        Assert-InstanceOf ([NotImplementedException]) $innerException
    }
    Assert-Greater 0 $result.__abstracts__.Count
}





function Test.Add-AbstractMethod_ShouldThrowArgumentException_IfNameOfExistingMember {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member ScriptMethod Generate { } -PassThru

    # Act
    $result = 
        $mock | 
            Add-AbstractMethod Generate

    # Assert
    Assert-Fail
}





function Test.Add-AbstractMethod_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod Newwww { Assert-Fail } -PassThru

    # Act
    $result = 
        $mock | 
            Add-AbstractMethod Generate

    # Assert
    Assert-Fail
}

