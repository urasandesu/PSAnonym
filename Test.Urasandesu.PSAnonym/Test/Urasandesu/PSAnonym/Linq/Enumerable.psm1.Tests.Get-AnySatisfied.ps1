# 
# File: Enumerable.psm1.Tests.Get-AnySatisfied.ps1
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



function Test.Get-AnySatisfied_ShouldReturnTrue_IfAnySatisfiedRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AnySatisfied { $1 % 2 -eq 0 } -InputObject { 1, 3, 4, 7, 8 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AnySatisfied_ShouldReturnFalse_IfEmptyRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AnySatisfied -InputObject { @() }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-AnySatisfied_ShouldReturnFalse_IfNotAnySatisfiedRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AnySatisfied { $1 % 2 -eq 0 } -InputObject { 1, 3, 5, 7, 9 }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-AnySatisfied_ShouldEvalShortCircuit_IfAnySatisfiedRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AnySatisfied { (& $1) % 2 -eq 0 } -InputObject { { 1 }, { 3 }, { 4 }, { Assert-Fail } }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AnySatisfied_ShouldReturnTrue_IfAnySatisfiedRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 1, 3, 4, 7, 8 } | QAny { $1 % 2 -eq 0 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AnySatisfied_ShouldReturnValue_EvenIfBreakingRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AnySatisfied { $1 % 2 -eq 0 } -InputObject { 1; 3; break; }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-AnySatisfied_ShouldReturnTrue_IfWithExplicitParameter {

    # Arrange
    # nop

    # Act
    $result = Get-AnySatisfied { param ($val) $val % 2 -eq 0 } -InputObject { 1, 3, 4, 7, 8 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AnySatisfied_ShouldReturnTrue_IfCalledFromOtherScope {

    # Arrange
    function Invoke-AnySatisfied {
        param ($Value)
        { 1, 3, 4, 7, 8 } | QAny { $1 % $Value -eq 0 }.GetNewFastClosure()
    }

    # Act
    $result1 = Invoke-AnySatisfied (2)
    $result2 = Invoke-AnySatisfied (5)

    # Assert
    Assert-IsTrue $result1
    Assert-IsFalse $result2
}
