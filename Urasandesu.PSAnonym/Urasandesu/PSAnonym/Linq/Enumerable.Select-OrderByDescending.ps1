# 
# File: Enumerable.Select-OrderByDescending.ps1
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


function Select-OrderByDescending {
<#
    .SYNOPSIS
        Sorts the elements of a sequence in descending order by using a specified comparer.

    .DESCRIPTION
        This command behaves like as Enumerable.OrderByDescending<TSource, TKey>.

    .PARAMETER  InputObject
        A sequence of values to order.

    .PARAMETER  KeySelector
        A function to extract a key from an element.

    .PARAMETER  Comparer
        A sequence to compare keys.

    .EXAMPLE
        { 2, 1, 3, 4, 0 } | Select-OrderByDescending { $_ } | Invoke-Linq
        4
        3
        2
        1
        0
        
        DESCRIPTION
        -----------
        This command will return descending ordered sequence from 0 to 4.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock 

    .OUTPUTS
        System.Management.Automation.ScriptBlock
    
    .NOTES
        You can also refer to the Select-OrderByDescending command by its built-in alias, "QOrderByDescending".

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.OrderByDescending<TSource, TKey>

#>
    
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $KeySelector
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE), 
            
            [Collections.Stack]
            $AdditionalComparer = $null
        )
        
        $InputObject = $InputObject
        $KeySelector = $KeySelector
        if ($null -eq $AdditionalComparer) {
            $Comparer = New-Object Collections.Stack
        } else {
            $Comparer = $AdditionalComparer
        }
        $Comparer.push(@{ Expression = $KeySelector; Descending = $true })

        & $Module { SelectOrderByDescendingCore $args[0] $args[1] $args[2] } $InputObject $Comparer $Module

    }.GetNewClosure()

}

function SelectOrderByDescendingCore {
    
    param (
        [scriptblock]
        $InputObject,

        [Collections.Stack]
        $Comparer,
        
        [Management.Automation.PSModuleInfo]
        $Module
    )

    $list = New-Object Collections.ArrayList
    $list.AddRange(@(do { & $InputObject -Module $Module } until ($true)))

    $property = $(
        foreach ($comparer_ in $Comparer) {
            & {
                $keySelector_ = $comparer_.Expression
                $descending_ = $comparer_.Descending
                @{ Expression = { & $keySelector_.GetNewClosure() $_ }.GetNewClosure(); Descending = $descending_ }
            }
        }
    )

    $list | Sort-Object $property
}

New-Alias QOrderByDescending Select-OrderByDescending

