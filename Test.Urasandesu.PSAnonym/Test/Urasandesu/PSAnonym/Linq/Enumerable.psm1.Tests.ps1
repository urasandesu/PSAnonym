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
. $(Join-Path $here Enumerable.psm1.Tests.Find-CountOf.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Find-While.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-ThenBy.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Select-ThenByDescending.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.ConvertTo-Array.ps1)
. $(Join-Path $here Enumerable.psm1.Tests.Find-Sequence.ps1)
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
