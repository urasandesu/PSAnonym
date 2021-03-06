# 
# File: Enumerable.psm1.Tests.Get-Count.ps1
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



function Test.Get-Count_ShouldReturnCount_IfRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Count -InputObject { 0..9 }

    # Assert
    Assert-AreEqual 10 $result
}





function Test.Get-Count_ShouldReturnCount_IfRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | QCount

    # Assert
    Assert-AreEqual 10 $result
}





function Test.Get-Count_ShouldReturnCount_EvenIfBreakingRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Count -InputObject { 0..9; break }

    # Assert
    Assert-AreEqual 10 $result
}





function Test.Get-Count_ShouldReturnCountByExpression_IfRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Count { $1 % 2 -eq 0 } -InputObject { 0..9 }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Count_ShouldReturnCountByExpression_IfRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | QCount { $1 % 2 -eq 0 }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Count_ShouldReturnCountByExpression_EvenIfBreakingRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Count { $1 % 2 -eq 0 } -InputObject { 0..9; break }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Count_ShouldReturnCountByExpression_IfWithExplicitParameter {

    # Arrange
    # nop

    # Act
    $result = Get-Count { param ($val) $val % 2 -eq 0 } -InputObject { 0..9 }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Count_ShouldReturnCountByExpression_IfCalledFromOtherScope {

    # Arrange
    function Invoke-Count {
        param ($Value)
        { 0..9 } | QCount { $1 % $Value -eq 0 }.GetNewFastClosure()
    }

    # Act
    $result1 = Invoke-Count (2)
    $result2 = Invoke-Count (3)

    # Assert
    Assert-AreEqual 5 $result1
    Assert-AreEqual 4 $result2
}
