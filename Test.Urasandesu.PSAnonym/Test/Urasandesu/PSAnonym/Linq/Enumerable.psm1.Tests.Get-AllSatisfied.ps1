# 
# File: Enumerable.psm1.Tests.Get-AllSatisfied.ps1
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



function Test.Get-AllSatisfied_ShouldReturnTrue_IfAllSatisfiedRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AllSatisfied { $1 % 2 -eq 0 } -InputObject { 0, 2, 4, 6, 8 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AllSatisfied_ShouldReturnFalse_IfNotAllSatisfiedRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AllSatisfied { $1 % 2 -eq 0 } -InputObject { 0, 2, 5, 6, 8 }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-AllSatisfied_ShouldEvalShortCircuit_IfNotAllSatisfiedRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AllSatisfied { (& $1) % 2 -eq 0 } -InputObject { { 0 }, { 2 }, { 5 }, { Assert-Fail } }

    # Assert
    Assert-IsFalse $result
}





function Test.Get-AllSatisfied_ShouldReturnTrue_IfAllSatisfiedRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0, 2, 4, 6, 8 } | QAll { $1 % 2 -eq 0 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AllSatisfied_ShouldReturnValue_EvenIfBreakingRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-AllSatisfied { $1 % 2 -eq 0 } -InputObject { 0; 2; 4; break; }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AllSatisfied_ShouldReturnTrue_IfWithExplicitParameter {

    # Arrange
    # nop

    # Act
    $result = Get-AllSatisfied { param ($val) $val % 2 -eq 0 } -InputObject { 0, 2, 4, 6, 8 }

    # Assert
    Assert-IsTrue $result
}





function Test.Get-AllSatisfied_ShouldReturnTrue_IfCalledFromOtherScope {

    # Arrange
    function Invoke-AllSatisfied {
        param ($Value)
        { 0, 2, 4, 6, 8 } | QAll { $1 % $Value -eq 0 }.GetNewFastClosure()
    }

    # Act
    $result1 = Invoke-AllSatisfied (2)
    $result2 = Invoke-AllSatisfied (3)

    # Assert
    Assert-IsTrue $result1
    Assert-IsFalse $result2
}
