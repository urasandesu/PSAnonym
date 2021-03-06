# 
# File: Enumerable.psm1
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



$here = Split-Path $MyInvocation.MyCommand.Path





function ExtractScriptBlock {
    
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [AllowNull()]
        [Collections.IEnumerator]
        $InputObject
    )

    if ($null -eq $InputObject) {
        $exParamName = '$InputObject'
        $exName = 'ArgumentNullException'
        $ex = New-Object $exName -ArgumentList $exParamName
        throw $ex
    }
    

    while ($InputObject.MoveNext()) {
        $block = $InputObject.Current -as [scriptblock]
        if ($block -eq $null) {
            $exMessage = 'The pipeline source object must be a scriptblock.'
            $exParamName = '$InputObject'
            $exName = 'ArgumentException'
            $ex = New-Object $exName -ArgumentList $exMessage
            throw $ex
        }
        break
    }
    
    $block
}




New-Variable MODULE_NULL_MESSAGE "Module", "This command should be invoked from Invoke-Linq(Default Alias: QRun)." -Option ReadOnly





New-Variable ToArray {
    
    param (
        [parameter(ValueFromRemainingArguments = $true)]
        [String[]]
        $VariableName
    )
    
    $VariableName
    
} -Option ReadOnly





. $(Join-Path $here Enumerable.Get-Aggregated.ps1)
. $(Join-Path $here Enumerable.Get-AllSatisfied.ps1)
. $(Join-Path $here Enumerable.Get-AnySatisfied.ps1)
. $(Join-Path $here Enumerable.Get-Average.ps1)
. $(Join-Path $here Enumerable.Select-Casted.ps1)
. $(Join-Path $here Enumerable.Join-Concatenated.ps1)
. $(Join-Path $here Enumerable.Get-Contained.ps1)
. $(Join-Path $here Enumerable.Get-Count.ps1)
. $(Join-Path $here Enumerable.Select-DefaultIfEmpty.ps1)
. $(Join-Path $here Enumerable.ConvertTo-Distinct.ps1)

function Get-ElementAt {
    throw New-Object NotImplementedException
}
function Get-ElementAtOrDefault {
    throw New-Object NotImplementedException
}
function New-Empty {
    throw New-Object NotImplementedException
}
function Join-Except {
    throw New-Object NotImplementedException
}
function Get-First {
    throw New-Object NotImplementedException
}
function Get-FirstOrDefault {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Group-SequenceBy.ps1)

function Join-GroupedBy {
    throw New-Object NotImplementedException
}
function Join-Intersect {
    throw New-Object NotImplementedException
}
function Join-Sequence {
    throw New-Object NotImplementedException
}
function Get-Last {
    throw New-Object NotImplementedException
}
function Get-LastOrDefault {
    throw New-Object NotImplementedException
}
function Get-LongCount {
    throw New-Object NotImplementedException
}
function Get-Max {
    throw New-Object NotImplementedException
}
function Get-Min {
    throw New-Object NotImplementedException
}
function ConvertTo-OfType {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Select-OrderBy.ps1)
. $(Join-Path $here Enumerable.Select-OrderByDescending.ps1)
. $(Join-Path $here Enumerable.New-Range.ps1)
. $(Join-Path $here Enumerable.New-Repeat.ps1)

function ConvertTo-Reversed {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Select-Sequence.ps1)
. $(Join-Path $here Enumerable.Select-ManySequence.ps1)

function Get-SequenceEquality {
    throw New-Object NotImplementedException
}
function Get-Single {
    throw New-Object NotImplementedException
}
function Get-SingleOrDefault {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Skip-Sequence.ps1)
. $(Join-Path $here Enumerable.Skip-SequenceWhile.ps1)

function Get-Sum {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Find-CountOf.ps1)
. $(Join-Path $here Enumerable.Find-While.ps1)
. $(Join-Path $here Enumerable.Select-ThenBy.ps1)
. $(Join-Path $here Enumerable.Select-ThenByDescending.ps1)
. $(Join-Path $here Enumerable.ConvertTo-Array.ps1)

function ConvertTo-Dictionary {
    throw New-Object NotImplementedException
}
function ConvertTo-List {
    throw New-Object NotImplementedException
}
function ConvertTo-Lookup {
    throw New-Object NotImplementedException
}
function Join-Union {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Find-Sequence.ps1)
. $(Join-Path $here Enumerable.Join-Zipped.ps1)
. $(Join-Path $here Enumerable.Invoke-Linq.ps1)



Export-ModuleMember -Function *-* -Alias *
