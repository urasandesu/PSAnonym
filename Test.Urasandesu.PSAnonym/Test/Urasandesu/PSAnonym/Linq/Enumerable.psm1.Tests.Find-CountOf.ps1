# 
# File: Enumerable.psm1.Tests.Find-CountOf.ps1
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



function Test.Find-CountOf_ShouldReturnCountOfItems_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $count = 5

    # Act
    $result = Find-CountOf $count -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-CountOf_ShouldReturnCountOfItems_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $count = 5

    # Act
    $result = Find-CountOf $count -InputObject { 0..4 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-CountOf_ShouldReturnCountOfItems_IfRangeIsPassed3 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $count = 5

    # Act
    $result = Find-CountOf $count -InputObject { 0..3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..3 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-CountOf_ShouldReturnCountOfItems_IfRangeIsPassed1FromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $count = 5

    # Act
    $result = { 0..9 } | Find-CountOf $count

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-CountOf_ShouldReturnCountOfItems_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $count1 = 5
    $count2 = 3

    # Act
    $result = { 0..9 } | Find-CountOf $count1 | Find-CountOf $count2

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..2 $(do {& $result -Module $modEnumerable} until ($true))
}





function Test.Find-CountOf_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    $count = 5

    # Act
    $result = Find-CountOf $count -InputObject { 0..9 }

    # Assert
    do {& $result} until ($true)
    Assert-Fail
}
