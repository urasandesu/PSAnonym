# 
# File: Enumerable.Select-Sequence.ps1
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



function Select-Sequence {
<#
    .SYNOPSIS
        Projects each element of a sequence into a new form.

    .DESCRIPTION
        This command behaves like as Enumerable.Select<TSource, TResult>.

    .PARAMETER  InputObject
        A sequence of values to invoke a transform function on.

    .PARAMETER  Selector
        A transform function to apply to each element.

    .EXAMPLE
        { 0..4 } | Select-Sequence { $1 * 2 } | Invoke-Linq
        0
        2
        4
        6
        8
        
        DESCRIPTION
        -----------
        This command will multiply each element by 2.

    .INPUTS
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Select-Sequence command by its built-in alias, "QSelect".

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.Select<TSource, TResult>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $Selector
    )
    
    SelectSequenceSpacer $InputObject $Selector

}

function SelectSequenceSpacer {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $Selector
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $Selector = $Selector
        
        & $Module { SelectSequenceCore $args[0] $args[1] $args[2] } $InputObject $Selector $Module

    }.GetNewFastClosure()
}

function SelectSequenceCore {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $Selector, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )

    $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $Selector, '1'
    & $InputObject -Module $Module | 
        ForEach-Object {
            $1 = $_
            , $__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1)
        }

}

New-Alias QSelect Select-Sequence
