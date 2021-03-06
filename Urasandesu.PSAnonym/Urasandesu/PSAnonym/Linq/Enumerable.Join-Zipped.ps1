# 
# File: Enumerable.Join-Zipped.ps1
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



function Join-Zipped {
<#
    .SYNOPSIS
        Merges two sequences by using the specified predicate function.

    .DESCRIPTION
        This command behaves like as Enumerable.Zip<TFirst, TSecond, TResult>.

    .PARAMETER  InputObject
        The first sequence to merge. You can also refer the alias 'i'.

    .PARAMETER  InputObject2
        The second sequence to merge. You can also refer the alias 'i2'.
        NOTE: This parameter will be performed EAGER EVALUATION. Therefore, it can not be passed an infinite sequence.

    .PARAMETER  $ResultSelector
        A function that specifies how to merge the elements from the two sequences.
        The default values is { , ($1, $2) }.

    .EXAMPLE
        { 0..4 } | Join-Zipped { 5..9 } | Invoke-Linq | ForEach-Object { $_ -join ', ' }
        0, 5
        1, 6
        2, 7
        3, 8
        4, 9
        
        DESCRIPTION
        -----------
        This command will return the values that are merged the two sequence.

    .INPUTS
        System.Management.Automation.ScriptBlock, 
        System.Management.Automation.ScriptBlock, 
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Join-Zipped command by its built-in alias, "QZip".

    .LINK
        Invoke-Linq

    .LINK
        ForEach-Object

    .LINK
        System.Linq.Enumerable.Zip<TFirst, TSecond, TResult>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('i')]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [Alias('i2')]
        [scriptblock]
        $InputObject2,

        [Parameter(Position = 1)]
        [scriptblock]
        $ResultSelector = { , ($1, $2) }
    )
    
    JoinZippedSpacer $InputObject $InputObject2 $ResultSelector

}

function JoinZippedSpacer {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $InputObject2,

        [scriptblock]
        $ResultSelector
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $InputObject2 = $InputObject2
        $ResultSelector = $ResultSelector
        
        & $Module { JoinZippedCore $args[0] $args[1] $args[2] $args[3] } $InputObject $InputObject2 $ResultSelector $Module

    }.GetNewFastClosure()
}

function JoinZippedCore {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $InputObject2,

        [scriptblock]
        $ResultSelector,
        
        [Management.Automation.PSModuleInfo]
        $Module
    )
    
    $__list__ = New-Object Collections.ArrayList
    $__list__.AddRange(@(do { & $InputObject2 -Module $Module } until ($true)))
    
    $__index__ = @(0)
    $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $ResultSelector, ([String[]]@('1', '2'))
    do {
        & $InputObject -Module $Module | 
            ForEach-Object {
                if ($__list__.Count -le $__index__[0]) {
                    break
                }
                $1 = $_
                $2 = $__list__[$__index__[0]++]
                , $__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1, $2)
            }
    } until ($true)
}

New-Alias QZip Join-Zipped
