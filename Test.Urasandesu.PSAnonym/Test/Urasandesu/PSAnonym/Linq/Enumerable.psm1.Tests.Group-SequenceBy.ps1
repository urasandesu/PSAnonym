# 
# File: Enumerable.psm1.Tests.Group-SequenceBy.ps1
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



function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Group-SequenceBy { $1 } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 1, 1 ($result | % { $_.Group })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Group-SequenceBy { $1[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0 `
                              ($result | % { $_.Group | % { $_ } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 0, 1, 0 } | QGroupBy { $1 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 1, 1 ($result | % { $_.Group })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 1, 0, 1, 0 } | QGroupBy { $1 } | QGroupBy { $1.Name }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 1, 1 ($result | % { $_.Group | % { $_.Group } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_EvenIfBreakingRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Group-SequenceBy { $1 } -InputObject { 0; 1; 0; 1; 0; break; }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 1, 1 ($result | % { $_.Group })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Group-SequenceBy { param ($key) $key } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 1, 1 ($result | % { $_.Group })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRange_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    
    function Invoke-GroupBy {
        param ($Value)
        { 0..9 } | QGroupBy { $1 % $Value }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-GroupBy (2)
    $resultBlock2 = Invoke-GroupBy (3)

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = & $resultBlock1 -Module $modEnumerable
    Assert-AreEqual 2 $result1.Length
    Assert-AreEqual 5 $result1[0].Count
    Assert-AreEqual 5 $result1[1].Count
    Assert-AreEqual '0' $result1[0].Name
    Assert-AreEqual '1' $result1[1].Name

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = & $resultBlock2 -Module $modEnumerable
    Assert-AreEqual 3 $result2.Length
    Assert-AreEqual 4 $result2[0].Count
    Assert-AreEqual 3 $result2[1].Count
    Assert-AreEqual 3 $result2[2].Count
    Assert-AreEqual '0' $result2[0].Name
    Assert-AreEqual '1' $result2[1].Name
    Assert-AreEqual '2' $result2[2].Name
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeWithMultipleKey_IfRangeIsPassed {

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
    $resultBlock = Group-SequenceBy { $1.Key1 }, { $1.Key2 } `
                        -InputObject { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual '1, 0', '0, 1', '0, 0' ($result | % { $_.Name })
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_.Group | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeWithMultipleKey_IfRangeIsPassedPipeline {

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
    $resultBlock = { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } } | QGroupBy { $1.Key1 }, { $1.Key2 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual '1, 0', '0, 1', '0, 0' ($result | % { $_.Name })
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_.Group | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeWithMultipleKey_IfChainingPipeline {

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
                        QGroupBy { $1.Key1 }, { $1.Key2 } | 
                        QGroupBy { $1.Name }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual '1, 0', '0, 1', '0, 0' ($result | % { $_.Name })
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_.Group | % { $_.Group | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeWithMultipleKey_EvenIfBreakingRangeIsPassed {

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
    $resultBlock = Group-SequenceBy { $1.Key1 }, { $1.Key2 } `
                        -InputObject { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ }; break }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual '1, 0', '0, 1', '0, 0' ($result | % { $_.Name })
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_.Group | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } } })
}





function Test.Group-SequenceBy_ShouldReturnGroupedRangeWithMultipleKey_IfWithExplicitParameter {

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
    $resultBlock = Group-SequenceBy { param ($val) $val.Key1 }, { param ($val) $val.Key2 } `
                        -InputObject { (1, 0, 0), (0, 1, 1), (0, 0, 0), (0, 1, 0) | % { & $new123 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual '1, 0', '0, 1', '0, 0' ($result | % { $_.Name })
    Assert-AreEnumerableEqual 1, 0, 0,
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_.Group | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } } })
}





function Test.Group-SequenceBy_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Group-SequenceBy { $1 } -InputObject { 0, 1, 0, 1, 0 }

    # Assert
    & $resultBlock
    Assert-Fail
}