# 
# File: Enumerable.Find-Sequence.ps1
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



function Find-Sequence {
<#
    .SYNOPSIS
        Filters a sequence of values based on a predicate.

    .DESCRIPTION
        This command behaves like as Enumerable.Where<TSource>.

    .PARAMETER  InputObject
        An collection to filter.

    .PARAMETER  Predicate
        A function to test each element for a condition.

    .EXAMPLE
        { 0..9 } | Find-Sequence { $1 % 2 -eq 0 } | Invoke-Linq
        0
        2
        4
        6
        8
        
        DESCRIPTION
        -----------
        This command will return only even numbers from the source.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Find-Sequence command by its built-in alias, "QWhere".

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.Where<TSource>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $Predicate
    )
    
    FindSequenceSpacer $InputObject $Predicate

}

function FindSequenceSpacer {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $Predicate
    )
    
    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $Predicate = $Predicate
        
        & $Module { FindSequenceCore $args[0] $args[1] $args[2] } $InputObject $Predicate $Module
        
    }.GetNewFastClosure()
}

function FindSequenceCore {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $Predicate, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )
    
    $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $Predicate, '1'
    & $InputObject -Module $Module | 
        ForEach-Object {
            $1 = $_
            if ($__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1)) {
                , $_
            }
        }
}


New-Alias QWhere Find-Sequence
