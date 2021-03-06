# 
# File: Enumerable.psm1.Tests.Get-Aggregated.ps1
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



function Test.Get-Aggregated_ShouldReturnAggregatedValue_IfRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Aggregated { $1 + $2 } -InputObject { 1..10 }

    # Assert
    Assert-AreEqual 55 $result
}





function Test.Get-Aggregated_ShouldReturnAggregatedValue_IfRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 1..10 } | QAggregate { $1 + $2 }

    # Assert
    Assert-AreEqual 55 $result
}





function Test.Get-Aggregated_ShouldReturnAggregatedValue_IfRangeWithSeedIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Aggregated { $1 + $2 } 10 -InputObject { 1..10 }

    # Assert
    Assert-AreEqual 65 $result
}





function Test.Get-Aggregated_ShouldReturnAggregatedValue_IfRangeWithSeedIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 1..10 } | Get-Aggregated { $1 + $2 } 10

    # Assert
    Assert-AreEqual 65 $result
}





function Test.Get-Aggregated_ShouldReturnAggregatedValue_IfWithExplicitParameter {

    # Arrange
    # nop

    # Act
    $result = Get-Aggregated { param ($sum, $next) $sum + $next } -InputObject { 1..10 }

    # Assert
    Assert-AreEqual 55 $result
}





function Test.Get-Aggregated_ShouldReturnAggregatedValue_IfCalledFromOtherScope {

    # Arrange
    function Invoke-Aggregated {
        param ($Value)
        { 1..10 } | QAggregate { if ($2 % $Value -eq 0) { $1 + $2 } else { $1 } }.GetNewFastClosure()
    }

    # Act
    $result1 = Invoke-Aggregated (2)
    $result2 = Invoke-Aggregated (3)

    # Assert
    Assert-AreEqual 30 $result1
    Assert-AreEqual 18 $result2
}
