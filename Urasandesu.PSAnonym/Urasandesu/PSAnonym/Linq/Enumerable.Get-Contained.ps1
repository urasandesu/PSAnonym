# 
# File: Enumerable.Get-Contained.ps1
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



function Get-Contained {
<#
    .SYNOPSIS
        Determines whether a sequence contains a specified element by using a specified Predicate.

    .DESCRIPTION
        This command behaves like as Enumerable.Contains<TSource>.

    .PARAMETER  InputObject
        A sequence in which to locate a value.

    .PARAMETER  Value
        The value to locate in the sequence.

    .PARAMETER  Predicate
        An predicate to compare values.

    .PARAMETER  $Variable
        Capture variables to use in LINQ command.

    .EXAMPLE
        { 3, 2, 6, 4, 7 } | Get-Contained 6
        True
        
        DESCRIPTION
        -----------
        This command will determine whether the sequence contains the value 6.

    .EXAMPLE
        { ('AliceBlue', 5), ('Cyan', 3), ('LightGray', 1) } | Get-Contained 'Red' { $1[0] -eq $2 }
        False
        
        DESCRIPTION
        -----------
        This command will determine whether the sequence that is constructed by 
        the pair of key and value contains the key 'Red'.

    .INPUTS
        System.Management.Automation.ScriptBlock, 
        System.Object, 
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Boolean

    .NOTES
        You can also refer to the Get-Contained command by its built-in alias, "QContains".

    .LINK
        System.Linq.Enumerable.Contains<TSource>

#>

    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        $Value, 

        [Parameter(Position = 1)]
        [scriptblock]
        $Predicate = $null, 
        
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
        if ($null -eq $Predicate) {
            $Predicate = { [Object]::Equals($1, $Value) }
        }
        
        $__cache__ = New-Object Urasandesu.Pontine.Management.Automation.FastClosureCache $Predicate, ([String[]]@('1', '2'))
        $__result__ = @($false)
        do {
            & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module | 
                ForEach-Object {
                    $1 = $_
                    $2 = $Value
                    if ($__cache__.GetNewOrUpdatedFastClosure().FastInvokeReturnAsIs($1, $2)) {
                        $__result__[0] = $true
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

New-Alias QContains Get-Contained
