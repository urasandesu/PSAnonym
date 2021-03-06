# 
# File: Prototype.psm1.Tests.New-Prototype.ps1
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



function Test.New-Prototype_ShouldReturnNewPSObject_IfNoParameter {

    # Arrange
    # nop

    # Act
    $result = New-Prototype MyType

    # Assert
    Assert-InstanceOf ([psobject]) $result
    Assert-IsTrue ($null -ne ($result | Get-Member New -MemberType ScriptMethod))
    Assert-AreEqual 'MyType' $result.psobject.TypeNames[0]
    Assert-AreEqual 'Urasandesu.PSAnonym.Prototype' $result.psobject.TypeNames[1]
}



function Test.New-Prototype_ShouldReturnNewPSObjectWithMethod_IfDeclarationsArePassed {

    # Arrange
    # nop

    # Act
    $result = 
        New-Prototype MyType { 
            , ((New-Object Management.Automation.PSScriptMethod GetMessage, { 'Added!!' }), 
                ([Urasandesu.PSAnonym.Prototype.AddModes]::None)) 
        }

    # Assert
    Assert-InstanceOf ([psobject]) $result
    Assert-IsTrue ($null -ne ($result | Get-Member New -MemberType ScriptMethod))
    Assert-AreEqual 'MyType' $result.psobject.TypeNames[0]
    Assert-AreEqual 'Urasandesu.PSAnonym.Prototype' $result.psobject.TypeNames[1]
    Assert-AreEqual 'Added!!' $result.GetMessage()
}



function Test.New-Prototype_ShouldCallMethodNew_IfParameterHasIt {

    # Arrange
    $called = @($false)
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $called[0] = $true; $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru | 
            Add-Member NoteProperty __inheritances__ @{} -PassThru | 
            Add-Member NoteProperty __me__ { } -PassThru | 
            Add-Member NoteProperty __cache__ @{} -PassThru | 
            Add-Member ScriptMethod SetMe { } -PassThru
    $mock.psobject.TypeNames.Insert(0, 'Urasandesu.PSAnonym.Prototype')
    
    # Act
    $result = ($mock | New-Prototype MyType).New()

    # Assert
    Assert-IsTrue $called[0]
}





function Test.New-Prototype_ShouldReturnInheritedObject_IfObjectIsPassed {

    # Arrange
    $mock = 
        & $NewPrototypeMock Mock | 
        Add-Member NoteProperty Item1 10 -PassThru

    # Act
    $result = $mock | New-Prototype MyType

    # Assert
    Assert-IsNotNull $result
    Assert-AreEqual 10 $result.Item1
    Assert-IsTrue ($null -ne ($result | Get-Member New -MemberType ScriptMethod))
    Assert-AreEqual 'MyType' $result.psobject.TypeNames[0]
    Assert-AreEqual 'Mock' $result.psobject.TypeNames[1]
}





function Test.New-Prototype_ShouldReturnMultipleInheritedObject_IfMultiObjectsArePassed {

    # Arrange
    $mock1 = 
        & $NewPrototypeMock Mock1 | 
        Add-Member NoteProperty Item1 10 -PassThru
    
    $mock2 = 
        & $NewPrototypeMock Mock2 | 
        Add-Member NoteProperty Item2 20 -PassThru

    # Act
    $result = $mock1, $mock2 | New-Prototype MyType

    # Assert
    Assert-IsNotNull $result
    Assert-AreEqual 10 $result.Item1
    Assert-AreEqual 20 $result.Item2
    Assert-IsTrue ($null -ne ($result | Get-Member New -MemberType ScriptMethod))
    Assert-AreEqual 'MyType' $result.psobject.TypeNames[0]
    Assert-AreEqual 'Mock1' $result.psobject.TypeNames[1]
    Assert-AreEqual 'Mock2' $result.psobject.TypeNames[2]
}





function Test.New-Prototype_ShouldThrowArgumentException_IfDuplicatedMemberMultiObjects {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock1 = 
        & $NewPrototypeMock Mock1 | 
        Add-Member NoteProperty Item1 10 -PassThru
    
    $mock2 = 
        & $NewPrototypeMock Mock2 | 
        Add-Member NoteProperty Item1 20 -PassThru

    # Act
    $result = New-Prototype MyType -InputObject $mock1, $mock2

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldReturnOverridenObject_IfDuplicatedMemberMultiObjectsButForcedOption {

    # Arrange
    $mock1 = 
        & $NewPrototypeMock Mock1 | 
        Add-Member NoteProperty Item1 10 -PassThru
    
    $mock2 = 
        & $NewPrototypeMock Mock2 | 
        Add-Member NoteProperty Item1 20 -PassThru

    # Act
    $result = $mock1, $mock2 | New-Prototype MyType -Force

    # Assert
    Assert-IsNotNull $result
    Assert-AreEqual 20 $result.Item1
    Assert-IsTrue ($null -ne ($result | Get-Member New -MemberType ScriptMethod))
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed1 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod Newwww { Assert-Fail } -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed2 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCoreeeee() } -PassThru | 
            Add-Member ScriptMethod NewCoreeeee { Assert-Fail } -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed3 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed4 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed5 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru | 
            Add-Member NoteProperty __inheritances__ @{} -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed6 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru | 
            Add-Member NoteProperty __inheritances__ @{} -PassThru | 
            Add-Member NoteProperty __me__ { } -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed7 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru | 
            Add-Member NoteProperty __inheritances__ @{} -PassThru | 
            Add-Member NoteProperty __me__ { } -PassThru | 
            Add-Member NoteProperty __cache__ @{} -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed8 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru | 
            Add-Member NoteProperty __inheritances__ @{} -PassThru | 
            Add-Member NoteProperty __me__ { } -PassThru | 
            Add-Member NoteProperty __cache__ @{} -PassThru | 
            Add-Member ScriptMethod SetMe { } -PassThru

    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}





function Test.New-Prototype_ShouldThrowArgumentException_IfInvalidBaseObjectIsPassed9 {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $mock = 
        New-Object psobject | 
            Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
            Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
            Add-Member NoteProperty __abstracts__ @{} -PassThru | 
            Add-Member NoteProperty __inheritances__ @{} -PassThru | 
            Add-Member NoteProperty __me__ { } -PassThru | 
            Add-Member NoteProperty __cache__ @{} -PassThru | 
            Add-Member ScriptMethod SetMe { } -PassThru
    $mock.psobject.TypeNames.Insert(0, 'Urasandesu.PSAnonym.Prototypeeeeee')
    
    # Act
    $mock | New-Prototype MyType

    # Assert
    Assert-Fail
}

