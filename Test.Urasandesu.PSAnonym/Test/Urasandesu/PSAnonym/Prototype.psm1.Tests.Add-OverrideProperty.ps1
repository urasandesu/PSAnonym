# 
# File: Prototype.psm1.Tests.Add-OverrideProperty.ps1
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



function Test.Add-OverrideProperty_ShouldAddOverrideProperty_IfPrototypeIsPassed {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items $null -PassThru | 
            Add-Member ScriptProperty Items {
                throw New-Object NotImplementedException
            } {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_getterCalled $false -PassThru | 
            Add-Member NoteProperty m_setterCalled $false -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items {
                $Me.m_getterCalled = $true
                $Me.m_items
            } {
                $Me.m_setterCalled = $true
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-InstanceOf ([psobject]) $result
    $result.Items = 42
    $items = $result.Items
    Assert-IsTrue $result.m_getterCalled
    Assert-IsTrue $result.m_setterCalled
    Assert-AreEqual 42 $items
}





function Test.Add-OverrideProperty_ShouldThrowArgumentException_IfNameOfExistingNonPropertyMember {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items $null -PassThru | 
            Add-Member NoteProperty Items {
                throw New-Object NotImplementedException
            } -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items {
                $Me.m_items
            } {
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-Fail
}





function Test.Add-OverrideProperty_ShouldThrowArgumentException_IfTryingOverrideNonExistentProperty {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items $null -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items {
                $Me.m_items
            } {
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-Fail
}





function Test.Add-OverrideProperty_ShouldAddReadOnlyOverrideProperty_IfPrototypeIsPassedWithOnlyGetter {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items 42 -PassThru | 
            Add-Member ScriptProperty Items -Value {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_getterCalled $false -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items -Getter {
                $Me.m_getterCalled = $true
                $Me.m_items
            }

    # Assert
    Assert-InstanceOf ([psobject]) $result
    $items = $result.Items
    Assert-IsTrue $result.m_getterCalled
    Assert-AreEqual 42 $items
}





function Test.Add-OverrideProperty_ShouldThrowRuntimeException_IfSetterIsCalledThoughPropertyIsReadOnly {

    param (
        [Management.Automation.RuntimeException] 
        $ExpectedException = $(New-Object Management.Automation.RuntimeException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items 42 -PassThru | 
            Add-Member ScriptProperty Items -Value {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_getterCalled $false -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items -Getter {
                $Me.m_getterCalled = $true
                $Me.m_items
            }

    # Assert
    $result.Items = 53
    Assert-Fail
}





function Test.Add-OverrideProperty_ShouldThrowArgumentException_IfTryingOverrideNonExistentGetter {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member ScriptProperty Items -Value $null -SecondValue {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_items $null -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items -Getter {
                $Me.m_items
            }

    # Assert
    Assert-Fail
}





function Test.Add-OverrideProperty_ShouldAddWriteOnlyProperty_IfPrototypeIsPassedWithOnlySetter {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items $null -PassThru | 
            Add-Member ScriptProperty Items -Value $null -SecondValue {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_setterCalled $false -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items -Setter {
                $Me.m_setterCalled = $true
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-InstanceOf ([psobject]) $result
    $result.Items = 42
    Assert-IsTrue $result.m_setterCalled
    Assert-AreEqual 42 $result.m_items
}





function Test.Add-OverrideProperty_ShouldReturnNull_IfGetterIsCalledThoughPropertyIsWriteOnly {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member NoteProperty m_items $null -PassThru | 
            Add-Member ScriptProperty Items -Value $null -SecondValue {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_setterCalled $false -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items -Setter {
                $Me.m_setterCalled = $true
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-InstanceOf ([psobject]) $result
    $result.Items = 42
    $items = $result.Items
    Assert-IsNull $items
    Assert-AreEqual 42 $result.m_items
}





function Test.Add-OverrideProperty_ShouldThrowArgumentException_IfTryingOverrideNonExistentSetter {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
            Add-Member ScriptProperty Items -Value {
                throw New-Object NotImplementedException
            } -PassThru | 
            Add-Member NoteProperty m_items $null -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items -Setter {
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-Fail
}





function Test.Add-OverrideProperty_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed {

    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod Newwww { Assert-Fail } -PassThru | 
            Add-Member NoteProperty m_items $null -PassThru | 
            Add-Member ScriptProperty Items {
                throw New-Object NotImplementedException
            } {
                throw New-Object NotImplementedException
            } -PassThru

    # Act
    $result = 
        $mock | 
            Add-OverrideProperty Items {
                $Me.m_items
            } {
                $Me.m_items = $Params[0]
            }

    # Assert
    Assert-Fail
}
