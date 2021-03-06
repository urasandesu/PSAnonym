# 
# File: Enumerable.Get-Aggregated.ps1
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



function Get-Aggregated {
<#
    .SYNOPSIS
        Applies an accumulator function over a sequence. The specified seed value 
        is used as the initial accumulator value.

    .DESCRIPTION
        This command behaves like as Enumerable.Aggregate<TSource, TAccumulate>.

    .PARAMETER  InputObject
        An sequence to aggregate over.

    .PARAMETER  Func
        An accumulator function to be invoked on each element.

    .PARAMETER  Seed
        The initial accumulator value.

    .PARAMETER  $Variable
        Capture variables to use in LINQ command.

    .EXAMPLE
        { 0..9 } | Get-Aggregated { $1 + $2 }
        45
        
        DESCRIPTION
        -----------
        This command will sum up the values from 0 to 9.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock, System.Object

    .OUTPUTS
        System.Object
    
    .NOTES
        You can also refer to the Get-Aggregated command by its built-in alias, "QAggregate".

    .LINK
        System.Linq.Enumerable.Aggregate<TSource, TAccumulate>

#>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $Func,

        [Parameter(Position = 1)]
        $Seed, 
        
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
        $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $Func, ([String[]]@('1', '2'))
        $__result__ = @($Seed)    
        do {
            & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module | 
                ForEach-Object {
                    $1 = $__result__[0]
                    $2 = $_
                    $__result__[0] = $__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1, $2)
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

New-Alias QAggregate Get-Aggregated
