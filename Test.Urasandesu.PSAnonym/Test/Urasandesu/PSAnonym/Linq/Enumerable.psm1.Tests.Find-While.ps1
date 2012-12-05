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
    # nop

    # Act
    $result = Find-While { $_ -lt 5 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -WithSpecialInvoker} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassed2 {

    # Arrange
    # nop

    # Act
    $result = Find-While { $_ -lt 10 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 0..9 $(do {& $result -WithSpecialInvoker} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassed3 {

    # Arrange
    # nop

    # Act
    $result = Find-While { $_ -lt 0 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-IsNull $(do {& $result -WithSpecialInvoker} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | Find-While { $_ -lt 5 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -WithSpecialInvoker} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfChainingPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | Find-While { $_ -lt 5 } | Find-While { $_ -lt 4 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 0..3 $(do {& $result -WithSpecialInvoker} until ($true))
}





function Test.Find-While_ShouldReturnWhileSatisfyingCondition_IfWithExplicitParameter {

    # Arrange
    # nop

    # Act
    $result = Find-While { param ($val) $val -lt 5 } -InputObject { 0..9 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 0..4 $(do {& $result -WithSpecialInvoker} until ($true))
}





function Test.Find-While_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [Urasandesu.PSAnonym.Linq.InvalidInvocationException] 
        $ExpectedException = $(New-Object Urasandesu.PSAnonym.Linq.InvalidInvocationException)
    )

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | Find-While { $_ -lt 5 }

    # Assert
    do {& $result} until ($true)
    Assert-Fail
}
