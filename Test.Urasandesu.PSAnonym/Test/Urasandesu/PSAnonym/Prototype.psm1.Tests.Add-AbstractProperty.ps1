# 
# File: Prototype.psm1.Tests.Add-AbstractProperty.ps1
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



function Test.Add-AbstractProperty_ShouldAddAbstractProperty_IfPrototypeIsPassed {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock

    # Act
    $result = 
        $mock | 
            Add-AbstractProperty Items -Getter -Setter

    # Assert
    Assert-InstanceOf ([psobject]) $result
    Assert-IsTrue $result.psobject.Members['Items'].IsGettable
    Assert-IsTrue $result.psobject.Members['Items'].IsSettable
    Assert-IsNull $result.Items
    try {
        $result.Items = 10
        Assert-Fail
    } catch [Management.Automation.RuntimeException] {
        $innerException = $_.Exception.InnerException
        Assert-InstanceOf ([Management.Automation.RuntimeException]) $innerException
        $innerException = $innerException.InnerException
        Assert-InstanceOf ([NotImplementedException]) $innerException
    }
    Assert-Greater 0 $result.__abstracts__.Count
}





function Test.Add-AbstractProperty_ShouldThrowArgumentException_IfNameOfExistingMember {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty Items @() -PassThru

    # Act
    $result = 
        $mock | 
            Add-AbstractProperty Items -Getter -Setter

    # Assert
    Assert-Fail
}





function Test.Add-AbstractProperty_ShouldAddAbstractReadOnlyProperty_IfPrototypeIsPassedWithOnlyGetter {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock

    # Act
    $result = 
        $mock | 
            Add-AbstractProperty Items -Getter

    # Assert
    Assert-InstanceOf ([psobject]) $result
    Assert-IsTrue $result.psobject.Members['Items'].IsGettable
    Assert-IsFalse $result.psobject.Members['Items'].IsSettable
}





function Test.Add-AbstractProperty_ShouldAddAbstractWriteOnlyProperty_IfPrototypeIsPassedWithOnlySetter {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock

    # Act
    $result = 
        $mock | 
            Add-AbstractProperty Items -Setter

    # Assert
    Assert-InstanceOf ([psobject]) $result
    Assert-IsFalse $result.psobject.Members['Items'].IsGettable
    Assert-IsTrue $result.psobject.Members['Items'].IsSettable
}





function Test.Add-AbstractProperty_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed {

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
            Add-AbstractProperty Items -Getter -Setter

    # Assert
    Assert-Fail
}

