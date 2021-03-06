# 
# File: Enumerable.psm1.Tests.Join-Zipped.ps1
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



function Test.Join-Zipped_ShouldZipRange_If2RangesIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Zipped { 4, 5, 6, 7 } { , ($1, $2) } -InputObject { 0, 1, 2, 3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}



function Test.Join-Zipped_ShouldZipRangeAccordingToShorter_If2RangesIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Zipped { 4, 5, 6, 7 } { , ($1, $2) } -InputObject { 0, 1, 2, 3, 4 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}



function Test.Join-Zipped_ShouldZipRangeAccordingToShorter_If2RangesIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Zipped { 4, 5, 6, 7, 8 } { , ($1, $2) } -InputObject { 0, 1, 2, 3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Join-Zipped_ShouldZipRange_If2RangesIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 2, 3 } | QZip { 4, 5, 6, 7 } { , ($1, $2) }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Join-Zipped_ShouldReturnNull_IfNullIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Zipped { $null } { , ($1, $2) } -InputObject { $null }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual $null, $null ($result | % { $_ } | % { $_ })
}





function Test.Join-Zipped_ShouldZipRange_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 2 } | QZip { 3, 4, 5 } { , ($1, $2) } | QZip { 6, 7, 8 } { , ($1[0], $1[1], $2) }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 3, 6,
                              1, 4, 7, 
                              2, 5, 8 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Join-Zipped_ShouldZipRange_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Join-Zipped { 4, 5, 6, 7 } { param ($first, $second) , ($first, $second) } -InputObject { 0, 1, 2, 3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Join-Zipped_ShouldZipRange_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    Remove-Variable Range2 -ErrorAction SilentlyContinue
    $global:Range2 = 4, 5, 6, 7 # The variable to be passed to InputObject2 from another scope must be global scope.
    
    function Invoke-Zip {
        param ($Value1, $Value2)
        { 0, 1, 2, 3 } | QZip { $Range2 } { , (($1 + $Value1), ($2 + $Value2)) }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-Zip 1 2
    $resultBlock2 = Invoke-Zip 3 4

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = & $resultBlock1 -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 6, 
                              2, 7, 
                              3, 8, 
                              4, 9 `
                              ($result1 | % { $_ } | % { $_ })

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = & $resultBlock2 -Module $modEnumerable
    Assert-AreEnumerableEqual 3, 8, 
                              4, 9, 
                              5, 10, 
                              6, 11 `
                              ($result2 | % { $_ } | % { $_ })
}





function Test.Join-Zipped_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {

    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Join-Zipped { 4, 5, 6, 7 } { , ($1, $2) } -InputObject { 0, 1, 2, 3 }

    # Assert
    & $resultBlock
    Assert-Fail
}
