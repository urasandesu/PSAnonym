# 
# File: Enumerable.psm1.Tests.Group-SequenceBy.ps1
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



function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfRangeIsPassed1 {

    # Arrange
    # nop

    # Act
    $result = Group-SequenceBy { $_ } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 `
                              $(& $result -WithSpecialInvoker | % { $_ | % { $_ } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfRangeIsPassed2 {

    # Arrange
    # nop

    # Act
    $result = Group-SequenceBy { $_[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0 `
                              $(& $result -WithSpecialInvoker | % { $_ | % { $_ } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0, 1, 0, 1, 0 } | QGroupBy { $_ }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 $(& $result -WithSpecialInvoker | % { $_ | % { $_ } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfChainingPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0, 1, 0, 1, 0 } | QGroupBy { $_ } | QGroupBy { $_.Key }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 $(& $result -WithSpecialInvoker | % { $_ | % { $_ | % { $_ } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfWithExplicitParameter {

    # Arrange
    # nop

    # Act
    $result = Group-SequenceBy { param ($key) $key } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 `
                              $(& $result -WithSpecialInvoker | % { $_ | % { $_ } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeByExpression_IfRangeIsPassed1 {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Group-SequenceBy { $_.Key1 } { $1 -eq $2 } { $_ } -InputObject { 0, 1, 0, 1, 0 | % { & $new1 $_ } }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 $(& $result -WithSpecialInvoker | % { $_ | % { $_.Key1 } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeByExpression_IfRangeIsPassed2 {

    # Arrange
    $new123 = {
        param ($Key123)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key123[0] -PassThru | 
            Add-Member NoteProperty Key2 $Key123[1] -PassThru | 
            Add-Member NoteProperty Key3 $Key123[2] -PassThru
    }

    # Act
    $result = Group-SequenceBy { $_.Key1 } { $1 -eq $2 } { $_ } `
                -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0 `
                              $(& $result -WithSpecialInvoker | % { $_ | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeByExpression_IfRangeIsPassedPipeline {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = { 0, 1, 0, 1, 0 | % { & $new1 $_ } } | Group-SequenceBy { $_.Key1 } { $1 -eq $2 } { $_ }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 $(& $result -WithSpecialInvoker | % { $_ | % { $_.Key1 } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeByExpression_IfChainingPipeline {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = { 0, 1, 0, 1, 0 | % { & $new1 $_ } } | 
                Group-SequenceBy { $_.Key1 } { $1 -eq $2 } { $_ } | 
                Group-SequenceBy { $_.Key } { $1 -eq $2 } { $_ } 

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 $(& $result -WithSpecialInvoker | % { $_ | % { $_ | % { $_.Key1 } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeByExpression_IfWithExplicitParameter {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Group-SequenceBy { param ($val) $val.Key1 } `
                               { param ($keyLhs, $keyRhs) $keyLhs -eq $keyRhs } `
                               { param ($key) $key } `
                -InputObject { 0, 1, 0, 1, 0 | % { & $new1 $_ } }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1, 1, 0, 0, 0 $(& $result -WithSpecialInvoker | % { $_ | % { $_.Key1 } })
}





function Test.Group-SequenceBy_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [Urasandesu.PSAnonym.Linq.InvalidInvocationException] 
        $ExpectedException = $(New-Object Urasandesu.PSAnonym.Linq.InvalidInvocationException)
    )

    # Arrange
    # nop

    # Act
    $result = Group-SequenceBy { $_ } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    & $result
    Assert-Fail
}