# 
# File: Enumerable.psm1.Tests.Find-While.ps1
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



function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Find-While { $1 -lt 5 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Find-While { $1 -lt 10 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..9 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassed3 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Find-While { $1 -lt 0 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-IsNull $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 0..9 } | Find-While { $1 -lt 5 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 0..9 } | Find-While { $1 -lt 5 } | Find-While { $1 -lt 4 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..3 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Find-While { param ($val) $val -lt 5 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    
    function Invoke-TakeWhile {
        param ($Value)
        { 0..9 } | QTakeWhile { $1 -lt $Value }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-TakeWhile (3)
    $resultBlock2 = Invoke-TakeWhile (7)

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = $(do {& $resultBlock1 -Module $modEnumerable} until ($true))
    Assert-AreEnumerableEqual 0..2 $result1

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = $(do {& $resultBlock2 -Module $modEnumerable} until ($true))
    Assert-AreEnumerableEqual 0..6 $result2
}





function Test.Find-While_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | Find-While { $1 -lt 5 }

    # Assert
    do {& $result} until ($true)
    Assert-Fail
}
