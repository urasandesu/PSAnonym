# 
# File: Enumerable.Skip-SequenceWhile.ps1
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



function Skip-SequenceWhile {
<#
	.SYNOPSIS
		Bypasses elements in a sequence as long as a specified condition is true and then returns the remaining elements.

	.DESCRIPTION
        This command behaves like as Enumerable.SkipWhile<TSource>.

	.PARAMETER  InputObject
		An sequence to return elements from.

	.PARAMETER  Predicate
		A function to test each element for a condition.

	.EXAMPLE
		{ 0..9 } | Skip-SequenceWhile { $1 -lt 4 } | Invoke-Linq
        4
        5
        6
        7
        8
        9
        
        DESCRIPTION
        -----------
        This command will return the remaining values except less than 4.

	.INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock

	.OUTPUTS
        System.Management.Automation.ScriptBlock

	.NOTES
        You can also refer to the Skip-SequenceWhile command by its built-in alias, "QSkipWhile".

	.LINK
        Invoke-Linq

	.LINK
        System.Linq.Enumerable.SkipWhile<TSource>

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
    
    SkipSequenceWhileSpacer $InputObject $Predicate

}

function SkipSequenceWhileSpacer {

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

        & $Module { SkipSequenceWhileCore $args[0] $args[1] $args[2] } $InputObject $Predicate $Module

    }.GetNewFastClosure()
}

function SkipSequenceWhileCore {
    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $Predicate, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )

    $__isSatisfied__ = @($true)
    $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $Predicate, '1'
    & $InputObject -Module $Module | 
        ForEach-Object {
            $1 = $_
            if (!$__isSatisfied__[0]) {
                , $_
            } else {
                if (!$__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1)) {
                    , $_
                    $__isSatisfied__[0] = $false
                }
            }
        }

}

New-Alias QSkipWhile Skip-SequenceWhile
