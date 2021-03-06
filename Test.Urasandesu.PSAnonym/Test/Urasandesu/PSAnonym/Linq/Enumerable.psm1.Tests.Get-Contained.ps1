# 
# File: Enumerable.psm1.Tests.Get-Contained.ps1
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



function Test.Get-Contained_ShouldReturnTrue_IfSatisfiedValueIsContained {

    # Arrange
    # nop

    # Act
    $result = Get-Contained 2 -InputObject { 0, 2, 4, 6, 8 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnFalse_IfAnySatisfiedValueIsNotContained {

    # Arrange
    # nop

    # Act
    $result = Get-Contained 10 -InputObject { 0, 2, 4, 6, 8 }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-Contained_ShouldEvalShortCircuit_IfSatisfiedValueIsContained {

    # Arrange
    # nop

    # Act
    $result = Get-Contained 2 -InputObject { 0, 2, 4; Assert-Fail }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnTrue_IfSatisfiedValueContainedRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0, 2, 4, 6, 8 } | Get-Contained 2

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnValue_EvenIfBreakingRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Contained 2 -InputObject { 0; 2; 4; break; }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnTrueByExpression_IfSatisfiedValueIsContained {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Contained 2 { $1.Key1 -eq $2 } -InputObject { 0, 2, 4, 6, 8 | % { & $new1 $_ } }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnFalseByExpression_IfAnySatisfiedValueIsNotContained {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Contained 10 { $1.Key1 -eq $2 } -InputObject { 0, 2, 4, 6, 8 | % { & $new1 $_ } }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-Contained_ShouldEvalShortCircuitByExpression_IfSatisfiedValueIsContained {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Contained 2 { $1.Key1 -eq $2 } -InputObject { 0, 2, 4 | % { & $new1 $_ }; Assert-Fail }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnTrueByExpression_IfSatisfiedValueContainedRangeIsPassedFromPipeline {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = { 0, 2, 4, 6, 8 | % { & $new1 $_ } } | Get-Contained 2 { $1.Key1 -eq $2 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnValue_EvenIfBreakingRangeIsPassed {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Contained 2 { $1.Key1 -eq $2 } -InputObject { 0, 2, 4 | % { & $new1 $_ }; break }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnTrueByExpression_IfWithExplicitParameter {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Contained 2 { param ($lhs, $rhs) $lhs.Key1 -eq $rhs } -InputObject { 0, 2, 4, 6, 8 | % { & $new1 $_ } }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-Contained_ShouldReturnTrueByExpression_IfCalledFromOtherScope {

    # Arrange
    function Invoke-Contained {
        param ($Value)
        { 1..10 } | QContains 2 { $1 -eq $Value }.GetNewFastClosure()
    }

    # Act
    $result1 = Invoke-Contained (2)
    $result2 = Invoke-Contained (11)

    # Assert
    Assert-IsTrue $result1
    Assert-IsFalse $result2
}
