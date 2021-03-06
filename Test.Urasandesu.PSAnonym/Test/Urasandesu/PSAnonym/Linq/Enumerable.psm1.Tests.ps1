# 
# File: Enumerable.psm1.Tests.ps1
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


param (
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $RootDirectory
)

Import-Module $(Join-Path $(Join-Path $RootDirectory ..) Urasandesu.PSAnonym)

$here = Split-Path $MyInvocation.MyCommand.Path
. $(Join-Path $here Enumerable.psm1.Tests.Get-Average.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-Casted.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Join-Concatenated.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Get-Contained.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Get-Count.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-DefaultIfEmpty.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.ConvertTo-Distinct.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Get-Aggregated.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Get-AllSatisfied.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Get-AnySatisfied.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Group-SequenceBy.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-OrderBy.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-OrderByDescending.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.New-Range.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.New-Repeat.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-Sequence.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-ManySequence.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Skip-Sequence.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Skip-SequenceWhile.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Find-CountOf.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Find-While.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-ThenBy.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-ThenByDescending.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.ConvertTo-Array.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Find-Sequence.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Join-Zipped.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Invoke-Linq.ps1)





function Test.ExtractScriptBlock_ShouldReturnScriptBlock_IfScriptBlockIsPassedFromPipeline {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = { 1..10 } | HookPipeline { & $modEnumerable { ExtractScriptBlock $args[0] } $args[0] }

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
}





function Test.ExtractScriptBlock_ShouldThrowArgumentNullException_IfNullIsPassed {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = & $modEnumerable { ExtractScriptBlock $args[0] } $null

    # Assert
    Assert-Fail
}





function Test.ExtractScriptBlock_ShouldThrowArgumentException_IfNonScriptBlockIsPassed {
    
    param (
        [ArgumentException] 
        $ExpectedException = $(New-Object ArgumentException)
    )

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*

    # Act
    $result = 1..10 | HookPipeline { & $modEnumerable { ExtractScriptBlock $args[0] } $args[0] }

    # Assert
    Assert-Fail
}





function HookPipeline {
    param (
        [scriptblock]
        $func
    )
    & $func $input
}





function Test.Linq_ShouldReturnZippedObject_AdHocIntegrationTest1 {

    # Arrange
    # nop

    # Act
    $result = 
        { 0, 1, 2, 3 } | 
            QZip { 4, 5, 6, 7 } { , ($1, $2) } | 
            QToArray

    # Assert
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Linq_ShouldReturnZippedObject_AdHocIntegrationTest2 {

    # Arrange
    $Range2 = 4, 5, 6, 7 # The variable to be passed from another scope must be global scope or be captured by scalar expression.
    
    function Invoke-Zip {
        param ($Value1, $Value2)
        { 0, 1, 2, 3 } | 
            QZip { $Range2 } { , (($1 + $Value1), ($2 + $Value2)) } | 
            QToArray -Variable { $Range2, $Value1, $Value2 }
    }

    # Act
    $result1 = Invoke-Zip 1 2
    $result2 = Invoke-Zip 3 4

    # Assert
    Assert-AreEnumerableEqual 1, 6, 
                              2, 7, 
                              3, 8, 
                              4, 9 `
                              ($result1 | % { $_ } | % { $_ })

    Assert-AreEnumerableEqual 3, 8, 
                              4, 9, 
                              5, 10, 
                              6, 11 `
                              ($result2 | % { $_ } | % { $_ })
}





function Test.Linq_ShouldReturnZippedObject_AdHocIntegrationTest3 {

    # Arrange
    # nop
    
    # Act
    $result = 
        QRange 0 4 | 
            QZip (QRange 4 4) { , ($1, $2) } | 
            QRun

    # Assert
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Linq_ShouldReturnZippedObject_AdHocIntegrationTest4 {

    # Arrange
    # nop

    # Act
    $result = 
        QRange 0 10 | 
            QZip (QRange 4 10 | QTake 4) { , ($1, $2) } | 
            QRun

    # Assert
    Assert-AreEnumerableEqual 0, 4, 
                              1, 5, 
                              2, 6, 
                              3, 7 `
                              ($result | % { $_ } | % { $_ })
}





function Test.Linq_ShouldReturnZippedObject_AdHocIntegrationTest5 {

    # Arrange
    # nop

    # Act
    $result = 
        QRange | 
            QZip { 'a', 'b', 'c', 'd', 'e' } | 
            QWhere { $1[0] % 2 -eq 0 } | 
            QSelect { $1[1] } | 
            QRun

    # Assert
    Assert-AreEnumerableEqual 'a', 'c', 'e' $result
}





function Test.Linq_ShouldReturnAggregatedObject_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-Aggregated {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 1..10 } | 
            QAggregate { if ($2 % $Value -eq 0) { $1 + $2 } else { $1 } } -Variable { $Value }
    }

    # Act
    $result1 = Invoke-Aggregated 2
    $result2 = Invoke-Aggregated 3

    # Assert
    Assert-AreEqual 30 $result1
    Assert-AreEqual 18 $result2
}





function Test.Linq_ShouldCheckAllSatisfied_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-AllSatisfied {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 0, 2, 4, 6, 8 } | 
            QAll { $1 % $Value -eq 0 } -Variable { $Value }
    }

    # Act
    $result1 = Invoke-AllSatisfied 2
    $result2 = Invoke-AllSatisfied 3

    # Assert
    Assert-IsTrue $result1
    Assert-IsFalse $result2
}





function Test.Linq_ShouldCheckAnySatisfied_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-AnySatisfied {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 1, 3, 4, 7, 8 } | 
            QAny { $1 % $Value -eq 0 } -Variable { $Value }
    }

    # Act
    $result1 = Invoke-AnySatisfied 2
    $result2 = Invoke-AnySatisfied 5

    # Assert
    Assert-IsTrue $result1
    Assert-IsFalse $result2
}





function Test.Linq_ShouldReturnAverage_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-Average {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 1..10 } | 
            QAverage { if ($1 % $Value -eq 0) { $1 } } -Variable { $Value }
    }

    # Act
    $result = Invoke-Average 2

    # Assert
    Assert-AreEqual 3 $result
}





function Test.Linq_ShouldCheckWhetherValueIsContained_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-Contained {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 1..10 } | 
            QContains 2 { $1 -eq $Value } -Variable { $Value }
    }

    # Act
    $result1 = Invoke-Contained 2
    $result2 = Invoke-Contained 11

    # Assert
    Assert-IsTrue $result1
    Assert-IsFalse $result2
}





function Test.Linq_ShouldReturnCount_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-Count {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 0..9 } | 
            QCount { $1 % $Value -eq 0 } -Variable { $Value }
    }

    # Act
    $result1 = Invoke-Count 2
    $result2 = Invoke-Count 3

    # Assert
    Assert-AreEqual 5 $result1
    Assert-AreEqual 4 $result2
}





function Test.Linq_ShouldInvokeLinq_AdHocIntegrationTest1 {

    # Arrange
    function Invoke-Select {
        param ($Value) # The variable to be passed from another scope must be global scope or be captured by scalar expression.
        { 0, 1, 2, 3 } | 
            QSelect { $1 + $Value } | 
            QRun -Variable { $Value }
    }

    # Act
    $result1 = Invoke-Select 1
    $result2 = Invoke-Select 2

    # Assert
    Assert-AreEnumerableEqual 1..4 $result1
    Assert-AreEnumerableEqual 2..5 $result2
}
