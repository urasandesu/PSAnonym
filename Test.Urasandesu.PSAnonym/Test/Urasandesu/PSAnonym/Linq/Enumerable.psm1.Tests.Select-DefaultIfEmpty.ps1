# 
# File: Enumerable.psm1.Tests.Select-DefaultIfEmpty.ps1
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



function Test.Select-DefaultIfEmpty_ShouldReturnDefaultValue1_IfEmptyRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-DefaultIfEmpty 0 -InputObject { @() }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEqual 0 $result
}





function Test.Select-DefaultIfEmpty_ShouldReturnDefaultValue2_IfEmptyRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-DefaultIfEmpty 10 -InputObject { @() }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEqual 10 $result
}





function Test.Select-DefaultIfEmpty_ShouldReturnSource_IfNotEmptyRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-DefaultIfEmpty 0 -InputObject { 0..4 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result
}





function Test.Select-DefaultIfEmpty_ShouldReturnDefaultValue1_IfEmptyRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { @() } | QDefaultIfEmpty 0

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEqual 0 $result
}





function Test.Select-DefaultIfEmpty_ShouldReturnDefaultValue1_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { @() } | QDefaultIfEmpty 0 | QDefaultIfEmpty 0

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEqual 0 $result
}





function Test.Select-DefaultIfEmpty_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {

    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Select-DefaultIfEmpty 0 -InputObject { @() }

    # Assert
    & $resultBlock
    Assert-Fail
}
