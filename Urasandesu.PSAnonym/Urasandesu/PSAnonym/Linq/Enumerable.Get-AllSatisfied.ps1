# 
# File: Enumerable.Get-AllSatisfied.ps1
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



function Get-AllSatisfied {
<#
    .SYNOPSIS
        Determines whether all elements of a sequence satisfy a condition.

    .DESCRIPTION
        This command behaves like as Enumerable.All<TSource>.

    .PARAMETER  InputObject
        A sequence that contains the elements to apply the predicate to.

    .PARAMETER  Predicate
        A function to test each element for a condition.

    .PARAMETER  $Variable
        Capture variables to use in LINQ command.

    .EXAMPLE
        { 2, 4, 6, 8 } | Get-AllSatisfied { $1 % 2 -eq 0 }
        True
        
        DESCRIPTION
        -----------
        This command will determine whether the all elements of the sequence are even number.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Boolean
    
    .NOTES
        You can also refer to the Get-AllSatisfied command by its built-in alias, "QAll".

    .LINK
        System.Linq.Enumerable.All<TSource>

#>
    
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $Predicate, 
        
        [scriptblock]
        $Variable
    )
    
    try {
        if ($null -ne $Variable) {
            $names = @(Invoke-Expression ('& $ToArray {0}' -f ($Variable.ToString() -replace '[$,]', ' ')))
            $values = @(& $Variable | % { , $_ })
            for ($i = 0; $i -lt $names.Length; $i++) {
                Invoke-Expression ('${0} = $values[{1}]' -f $names[$i], $i)
            }
        }
        $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $Predicate, '1'
        $__result__ = @($true)
        do {
            & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module | 
                ForEach-Object {
                    $1 = $_
                    if (!($__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1))) {
                        $__result__[0] = $false
                        break
                    }
                }
        } until ($true)
        
        $__result__[0]
    } finally {
        if ($null -ne $Variable) {
            for ($i = 0; $i -lt $names.Length; $i++) {
                Remove-Variable $names[$i]
            }
        }
    }

}

New-Alias QAll Get-AllSatisfied
