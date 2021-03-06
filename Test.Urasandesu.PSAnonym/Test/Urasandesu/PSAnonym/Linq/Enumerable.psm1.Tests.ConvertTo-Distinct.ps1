# 
# File: Enumerable.psm1.Tests.ConvertTo-Distinct.ps1
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



function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_IfRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = ConvertTo-Distinct -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1 $result
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = ConvertTo-Distinct -InputObject { (1, 0, 0), (0, 0, 0), (0, 0, 0), (1, 0, 0) }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 0, 0 `
                              ($result | % { $_ })
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_IfRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 0, 1, 0 } | QDistinct

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1 $result
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 0, 1, 0 } | QDistinct | QDistinct

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1 $result
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_EvenIfBreakingRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = ConvertTo-Distinct -InputObject { 0, 1, 0, 1, 0; break }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1 $result
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = ConvertTo-Distinct { param ($key) $key } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1 $result
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRange_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    
    function Invoke-Distinct {
        param ($Value)
        { 0, 2, 2, 3, 3, 3 } | QDistinct { if ($1 % $Value -eq 0) { $1 } else { 0 } }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-Distinct (2)
    $resultBlock2 = Invoke-Distinct (3)

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = & $resultBlock1 -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 2 $result1

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = & $resultBlock2 -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 3 $result2
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRangeWithMultipleKey_IfRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new123 = {
        param ($Key123)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key123[0] -PassThru | 
            Add-Member NoteProperty Key2 $Key123[1] -PassThru | 
            Add-Member NoteProperty Key3 $Key123[2] -PassThru
    }

    # Act
    $resultBlock = ConvertTo-Distinct { $1.Key1 }, { $1.Key2 } `
                        -InputObject { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRangeWithMultipleKey_IfRangeIsPassedPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new123 = {
        param ($Key123)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key123[0] -PassThru | 
            Add-Member NoteProperty Key2 $Key123[1] -PassThru | 
            Add-Member NoteProperty Key3 $Key123[2] -PassThru
    }

    # Act
    $resultBlock = { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } } | QDistinct { $1.Key1 }, { $1.Key2 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRangeWithMultipleKey_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new123 = {
        param ($Key123)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key123[0] -PassThru | 
            Add-Member NoteProperty Key2 $Key123[1] -PassThru | 
            Add-Member NoteProperty Key3 $Key123[2] -PassThru
    }

    # Act
    $resultBlock = { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } } | 
                        QDistinct { $1.Key1 }, { $1.Key2 } | 
                        QDistinct { $1.Key1 }, { $1.Key2 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRangeWithMultipleKey_EvenIfBreakingRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new123 = {
        param ($Key123)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key123[0] -PassThru | 
            Add-Member NoteProperty Key2 $Key123[1] -PassThru | 
            Add-Member NoteProperty Key3 $Key123[2] -PassThru
    }

    # Act
    $resultBlock = ConvertTo-Distinct { $1.Key1 }, { $1.Key2 } `
                        -InputObject { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ }; break }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.ConvertTo-Distinct_ShouldReturnDistinctRangeWithMultipleKey_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new123 = {
        param ($Key123)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key123[0] -PassThru | 
            Add-Member NoteProperty Key2 $Key123[1] -PassThru | 
            Add-Member NoteProperty Key3 $Key123[2] -PassThru
    }

    # Act
    $resultBlock = ConvertTo-Distinct { param ($val) $val.Key1 }, { param ($val) $val.Key2 } `
                        -InputObject { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.ConvertTo-Distinct_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {

    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = ConvertTo-Distinct -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    & $resultBlock
    Assert-Fail
}
