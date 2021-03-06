# 
# File: Enumerable.psm1.Tests.Skip-SequenceWhile.ps1
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



function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Skip-SequenceWhile { $1 -lt 5 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 5..9 (& $result -Module $modEnumerable)
}





function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Skip-SequenceWhile { $1 -lt 10 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-IsNull (& $result -Module $modEnumerable)
}





function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfRangeIsPassed3 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Skip-SequenceWhile { $1 -lt 5 } -InputObject { 0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 5..0 (& $result -Module $modEnumerable)
}





function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 0..9 } | QSkipWhile { $1 -lt 5 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 5..9 (& $result -Module $modEnumerable)
}





function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 0..9 } | QSkipWhile { $1 -lt 5 } | QSkipWhile { $1 -lt 8 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 8..9 (& $result -Module $modEnumerable)
}





function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Skip-SequenceWhile { param ($val) $val -lt 5 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 5..9 (& $result -Module $modEnumerable)
}





function Test.Skip-SequenceWhile_ShouldSkipWhileSatisfyingCondition_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    
    function Invoke-SkipWhile {
        param ($Value)
        { 0..9 } | QSkipWhile { $1 -lt $Value }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-SkipWhile (3)
    $resultBlock2 = Invoke-SkipWhile (7)

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = $(do {& $resultBlock1 -Module $modEnumerable} until ($true))
    Assert-AreEnumerableEqual 3..9 $result1

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = $(do {& $resultBlock2 -Module $modEnumerable} until ($true))
    Assert-AreEnumerableEqual 7..9 $result2
}





function Test.Skip-SequenceWhile_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | Skip-SequenceWhile { $1 -lt 5 }

    # Assert
    & $result
    Assert-Fail
}
