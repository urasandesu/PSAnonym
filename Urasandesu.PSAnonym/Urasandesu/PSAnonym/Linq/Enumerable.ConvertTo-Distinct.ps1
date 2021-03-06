# 
# File: Enumerable.ConvertTo-Distinct.ps1
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


function ConvertTo-Distinct {
<#
    .SYNOPSIS
        Returns distinct elements from a sequence by using a specified KeySelector to compare values.

    .DESCRIPTION
        This command behaves like as Enumerable.Distinct<TSource>.

    .PARAMETER  InputObject
        The sequence to remove duplicate elements from.

    .PARAMETER  KeySelector
        An key selectors to compare values.

    .EXAMPLE
        { 1, 2, 1, 3, 2, 1, 3 } | ConvertTo-Distinct | ConvertTo-Array
        1
        2
        3
        
        DESCRIPTION
        -----------
        This command will return the distinct elements.

    .EXAMPLE
        { ('Dog', 10), ('Cat', 2), ('Dog', 10), ('Parakeets', 2), ('Cat', 3) } | QDistinct { $1[0] }, { $1[1] } | QSelect { $1 -join ': ' } | QRun
        Dog: 10
        Cat: 2
        Parakeets: 2
        Cat: 3
        
        DESCRIPTION
        -----------
        This command will return the distinct elements by the specified key.

    .INPUTS
        System.Management.Automation.ScriptBlock, 
        System.Management.Automation.ScriptBlock[]

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the ConvertTo-Distinct command by its built-in alias, "QDistinct".

    .LINK
        ConvertTo-Array

    .LINK
        Select-Sequence

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.Distinct<TSource>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0)]
        [scriptblock[]]
        $KeySelector = $null
    )
    
    ConvertToDistinctSpacer $InputObject $KeySelector

}

function ConvertToDistinctSpacer {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock[]]
        $KeySelector
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $KeySelector = $KeySelector

        & $Module { ConvertToDistinctCore $args[0] $args[1] $args[2] } $InputObject $KeySelector $Module
        
    }.GetNewFastClosure()
}

function ConvertToDistinctCore {
    
    param (
        [scriptblock]
        $InputObject,

        [scriptblock[]]
        $KeySelector,
        
        [Management.Automation.PSModuleInfo]
        $Module
    )
    
    $__list__ = New-Object Collections.ArrayList
    $__list__.AddRange(@(do { & $InputObject -Module $Module } until ($true)))
    
    if ($null -eq $KeySelector) {
        $__property__ = $null
    } else {
        $__property__ = $(
            foreach ($__keySelector__ in $KeySelector) {
                & {
                    $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $__keySelector__, '1'
                    {
                        $1 = $_
                        $__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1)
                    }.GetNewClosure()
                }
            }
        )
    }

    $__list__ | 
        Group-Object $__property__ | 
        ForEach-Object {
            , $_.Group[0]
        }
}

New-Alias QDistinct ConvertTo-Distinct
