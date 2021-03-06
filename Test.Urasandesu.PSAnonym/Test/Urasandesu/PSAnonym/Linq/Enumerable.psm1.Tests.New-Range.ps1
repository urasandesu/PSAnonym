# 
# File: Enumerable.psm1.Tests.New-Range.ps1
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



function Test.New-Range_ShouldReturnRange_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $start = 0
    $count = 10

    # Act
    $result = New-Range $start $count

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 0..9 $(& $result -Module $modEnumerable)
}





function Test.New-Range_ShouldReturnRange_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $start = 1
    $count = 10

    # Act
    $result = New-Range $start $count

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    Assert-AreEnumerableEqual 1..10 $(& $result -Module $modEnumerable)
}





function Test.New-Range_ShouldThrowArgumentOutOfRangeException_IfNegativeValueIsPassed {
    
    param (
        [ArgumentOutOfRangeException] 
        $ExpectedException = $(New-Object ArgumentOutOfRangeException)
    )

    # Arrange
    $start = 0
    $count = -1

    # Act
    $result = New-Range $start $count

    # Assert
    Assert-Fail
}





function Test.New-Range_ShouldThrowArgumentOutOfRangeException_IfOverValueIsPassed {
    
    param (
        [ArgumentOutOfRangeException] 
        $ExpectedException = $(New-Object ArgumentOutOfRangeException)
    )

    # Arrange
    $start = [int]::MaxValue
    $count = 2

    # Act
    $result = New-Range $start $count

    # Assert
    Assert-Fail
}





function Test.New-Range_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    $start = 0
    $count = 10

    # Act
    $result = New-Range $start $count

    # Assert
    & $result
    Assert-Fail
}
