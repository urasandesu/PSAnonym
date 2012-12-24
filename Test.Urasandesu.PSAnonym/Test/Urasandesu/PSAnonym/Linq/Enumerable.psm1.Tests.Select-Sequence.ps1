# 
# File: Enumerable.psm1.Tests.Select-Sequence.ps1
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



function Test.Select-Sequence_ShouldReturnMappedRange_IfRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Select-Sequence { $_ + 1 } -InputObject { 0, 1, 2, 3 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1..4 $(& $result -Module $modEnumerable)
}





function Test.Select-Sequence_ShouldReturnMappedRange_IfRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 0, 1, 2, 3 } | Select-Sequence { $_ + 1 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1..4 $(& $result -Module $modEnumerable)
}





function Test.Select-Sequence_ShouldReturnMappedNull_IfNullIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { $null } | Select-Sequence { $_ + 1 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEqual 1 $(& $result -Module $modEnumerable)
}





function Test.Select-Sequence_ShouldReturnMappedRange_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 0, 1, 2, 3 } | Select-Sequence { $_ + 1 } | Select-Sequence { $_ + 1 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 2..5 $(& $result -Module $modEnumerable)
}





function Test.Select-Sequence_ShouldReturnMappedRange_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = Select-Sequence { param ($val) $val + 1 } -InputObject { 0, 1, 2, 3 }

    # Assert
    Assert-InstanceOf [scriptblock] $result
    Assert-AreEnumerableEqual 1..4 $(& $result -Module $modEnumerable)
}





function Test.Select-Sequence_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $result = Select-Sequence { $_ + 1 } -InputObject { 0, 1, 2, 3 }

    # Assert
    & $result
    Assert-Fail
}
