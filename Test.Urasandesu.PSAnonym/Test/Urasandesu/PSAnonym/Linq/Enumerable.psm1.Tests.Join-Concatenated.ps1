# 
# File: Enumerable.psm1.Tests.Join-Concatenated.ps1
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



function Test.Join-Concatenated_ShouldReturnCombinedRange_If2RangesIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Concatenated { 4, 5, 6, 7 } -InputObject { 0, 1, 2, 3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..7 $result
}





function Test.Join-Concatenated_ShouldReturnCombinedRange_If2RangesIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 2, 3 } | QConcat { 4, 5, 6, 7 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..7 $result
}





function Test.Join-Concatenated_ShouldReturnNull_IfNullIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Concatenated { $null } -InputObject { $null }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual $null, $null $result
}





function Test.Join-Concatenated_ShouldReturnCombinedRange_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 2, 3 } | QConcat { 4, 5, 6, 7 } | QConcat { 8, 9, 10, 11 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..11 $result
}





function Test.Join-Concatenated_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Join-Concatenated { 4, 5, 6, 7 } -InputObject { 0, 1, 2, 3 }

    # Assert
    & $resultBlock
    Assert-Fail
}
