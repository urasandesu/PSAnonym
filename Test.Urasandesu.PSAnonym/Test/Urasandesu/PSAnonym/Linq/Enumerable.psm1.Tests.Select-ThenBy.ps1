# 
# File: Enumerable.psm1.Tests.Select-ThenBy.ps1
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



function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey1_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { $_[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenBy { $_[1] } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              1, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey2_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { $_[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenBy { $_[1] } -InputObject $resultBlock
    $resultBlock = Select-ThenBy { $_[2] } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 0, 
                              0, 1, 1, 
                              1, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey2_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) } | 
                    QOrderBy { $_[0] } | 
                    QThenBy { $_[1] } | 
                    QThenBy { $_[2] }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 0, 
                              0, 1, 1, 
                              1, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey1_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderBy { param ($item) $item[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenBy { param ($item) $item[1] } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              1, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey1ByExpression_IfRangeIsPassed2 {

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
    $resultBlock = Select-OrderBy { $_.Key1 } `
                -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }
    $resultBlock = Select-ThenBy { $_.Key2 } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              1, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey2ByExpression_IfRangeIsPassed2 {

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
    $resultBlock = Select-OrderBy { $_.Key1 } `
                -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }
    $resultBlock = Select-ThenBy { $_.Key2 } -InputObject $resultBlock
    $resultBlock = Select-ThenBy { $_.Key3 } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 0, 
                              0, 1, 1, 
                              1, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey2ByExpression_IfChainingPipeline {

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
    $resultBlock = { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } } | 
                        QOrderBy { $_.Key1 } | 
                        QThenBy { $_.Key2 } | 
                        QThenBy { $_.Key3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 0, 
                              0, 1, 1, 
                              1, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}




function Test.Select-ThenBy_ShouldReturnOrderedRangeWithAdditionalKey1ByExpression_IfWithExplicitParameter {

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
    $resultBlock = Select-OrderBy { param ($val) $val.Key1 } `
                             -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }
    $resultBlock = Select-ThenBy { param ($val) $val.Key2 } `
                            -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 0, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              1, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })

}





function Test.Select-ThenBy_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Select-OrderBy { $_[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenBy { $_[1] } -InputObject $resultBlock

    # Assert
    & $resultBlock
    Assert-Fail
}





function Test.Select-ThenBy_ShouldThrowInvalidOperationException_IfInvalidWayToChain {
    
    param (
        [InvalidOperationException] 
        $ExpectedException = $(New-Object InvalidOperationException)
    )

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-Sequence { @($_ | % { $_ + 1 }) } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenBy { $_[1] } -InputObject $resultBlock

    # Assert
    & $resultBlock -Module $modEnumerable
    Assert-Fail
}