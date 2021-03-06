# 
# File: Enumerable.psm1.Tests.Select-OrderBy.ps1
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



function Test.Select-OrderBy_ShouldReturnOrderedRange_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { $1 } -InputObject { 0, 2, 3, 1, 4 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result
}





function Test.Select-OrderBy_ShouldReturnOrderedRange_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { $1[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0, 
                              1, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-OrderBy_ShouldReturnOrderedRange_IfRangeIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 2, 3, 1, 4 } | QOrderBy { $1 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result
}





function Test.Select-OrderBy_ShouldReturnOrderedRange_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { 0, 2, 3, 1, 4 } | QOrderBy { $1 } | QOrderBy { $1 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result
}





function Test.Select-OrderBy_ShouldReturnOrderedRange_EvenIfBreakingRangeIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { $1 } -InputObject { 0, 2, 3, 1, 4; break }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result
}





function Test.Select-OrderBy_ShouldReturnOrderedRange_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { param ($key) $key } -InputObject { 0, 2, 3, 1, 4 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result
}





function Test.Select-OrderBy_ShouldReturnOrderedRange_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    
    function Invoke-OrderBy {
        param ($Value)
        { 0, 2, 3, 1, 4 } | QOrderBy { $1 * $Value }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-OrderBy (1)
    $resultBlock2 = Invoke-OrderBy (-1)

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = & $resultBlock1 -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 $result1

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = & $resultBlock2 -Module $modEnumerable
    Assert-AreEnumerableEqual 4..0 $result2
}





function Test.Select-OrderBy_ShouldReturnOrderedRangeByExpression_IfRangeIsPassed1 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $resultBlock = Select-OrderBy { $1.Key1 } -InputObject { 0, 2, 3, 1, 4 | % { & $new1 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 ($result | % { $_.Key1 })
}





function Test.Select-OrderBy_ShouldReturnOrderedRangeByExpression_IfRangeIsPassed2 {

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
    $resultBlock = Select-OrderBy { $1.Key1 } `
                -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0, 
                              1, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.Select-OrderBy_ShouldReturnOrderedRangeByExpression_IfRangeIsPassedPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $resultBlock = { 0, 2, 3, 1, 4 | % { & $new1 $_ } } | QOrderBy { $1.Key1 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 ($result | % { $_.Key1 })
}





function Test.Select-OrderBy_ShouldReturnOrderedRangeByExpression_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $resultBlock = { 0, 2, 3, 1, 4 | % { & $new1 $_ } } | 
                    QOrderBy { $1.Key1 } | 
                    QOrderBy { $1.Key1 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 ($result | % { $_.Key1 })
}





function Test.Select-OrderBy_ShouldReturnOrderedRangeByExpression_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $resultBlock = Select-OrderBy { param ($val) $val.Key1 } `
                             -InputObject { 0, 2, 3, 1, 4 | % { & $new1 $_ } }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0..4 ($result | % { $_.Key1 })
}





function Test.Select-OrderBy_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Select-OrderBy { $1 } -InputObject { 0, 2, 3, 1, 4 }

    # Assert
    & $resultBlock
    Assert-Fail
}