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



function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey1_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderByDescending { $1[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenByDescending { $1[1] } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey2_IfRangeIsPassed2 {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderByDescending { $1[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenByDescending { $1[1] } -InputObject $resultBlock
    $resultBlock = Select-ThenByDescending { $1[2] } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey2_IfChainingPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) } | 
                    QOrderByDescending { $1[0] } | 
                    QThenByDescending { $1[1] } | 
                    QThenByDescending { $1[2] }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey1_IfWithExplicitParameter {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-OrderByDescending { param ($item) $item[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenByDescending { param ($item) $item[1] } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { $_ | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey1_IfCalledFromOtherScope {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    
    function Invoke-ThenByDescending {
        param ($Block, $Value)
        $Block | QThenByDescending { $1[$Value] }.GetNewFastClosure()
    }

    # Act
    $resultBlock1 = Invoke-ThenByDescending ({ (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) } | QOrderByDescending { $1[0] }) 1
    $resultBlock2 = Invoke-ThenByDescending ({ (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) } | QOrderByDescending { $1[0] }) 2

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock1
    $result1 = & $resultBlock1 -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result1 | % { $_ | % { $_ } })

    Assert-InstanceOf ([scriptblock]) $resultBlock2
    $result2 = & $resultBlock2 -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result2 | % { $_ | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey1ByExpression_IfRangeIsPassed2 {

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
    $resultBlock = Select-OrderByDescending { $1.Key1 } `
                -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }
    $resultBlock = Select-ThenByDescending { $1.Key2 } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey2ByExpression_IfRangeIsPassed2 {

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
    $resultBlock = Select-OrderByDescending { $1.Key1 } `
                -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }
    $resultBlock = Select-ThenByDescending { $1.Key2 } -InputObject $resultBlock
    $resultBlock = Select-ThenByDescending { $1.Key3 } -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}





function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey2ByExpression_IfChainingPipeline {

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
                    QOrderByDescending { $1.Key1 } | 
                    QThenByDescending { $1.Key2 } | 
                    QThenByDescending { $1.Key3 }

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })
}




function Test.Select-ThenByDescending_ShouldReturnOrderedRangeWithAdditionalKey1ByExpression_IfWithExplicitParameter {

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
    $resultBlock = Select-OrderByDescending { param ($val) $val.Key1 } `
                                       -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) | % { & $new123 $_ } }
    $resultBlock = Select-ThenByDescending { param ($val) $val.Key2 } `
                                      -InputObject $resultBlock

    # Assert
    Assert-InstanceOf ([scriptblock]) $resultBlock
    $result = & $resultBlock -Module $modEnumerable
    Assert-AreEnumerableEqual 1, 0, 0, 
                              0, 1, 1, 
                              0, 1, 0, 
                              0, 0, 0 `
                              ($result | % { @($_.Key1, $_.Key2, $_.Key3) | % { $_ } })

}





function Test.Select-ThenByDescending_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $resultBlock = Select-OrderByDescending { $1[0] } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenByDescending { $1[1] } -InputObject $resultBlock

    # Assert
    & $resultBlock
    Assert-Fail
}





function Test.Select-ThenByDescending_ShouldThrowInvalidOperationException_IfInvalidWayToChain {
    
    param (
        [InvalidOperationException] 
        $ExpectedException = $(New-Object InvalidOperationException)
    )

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $resultBlock = Select-Sequence { @($1 | % { $1 + 1 }) } -InputObject { (1, 0, 0), (0, 0, 0), (0, 1, 1), (0, 1, 0) }
    $resultBlock = Select-ThenByDescending { $1[1] } -InputObject $resultBlock

    # Assert
    & $resultBlock -Module $modEnumerable
    Assert-Fail
}