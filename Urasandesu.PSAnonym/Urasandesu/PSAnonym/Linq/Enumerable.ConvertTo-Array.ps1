# 
# File: Enumerable.ConvertTo-Array.ps1
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



function ConvertTo-Array {
<#
    .SYNOPSIS
        Creates an array from a sequence.

    .DESCRIPTION
        This command behaves like as Enumerable.ToArray<TSource>.

    .PARAMETER  InputObject
        A sequence to create an array from.

    .PARAMETER  $Variable
        Capture variables to use in LINQ command.

    .EXAMPLE
        New-Range 1 5 | Select-Sequence { $1 * $1 } | ConvertTo-Array
        1
        4
        9
        16
        25
        
        DESCRIPTION
        -----------
        This command will create the array from the squared elements of the range from 1 to 5.

    .INPUTS
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Object
    
    .NOTES
        You can also refer to the ConvertTo-Array command by its built-in alias, "QToArray".

    .LINK
        New-Range

    .LINK
        Select-Sequence

    .LINK
        System.Linq.Enumerable.ToArray<TSource>

#>
    
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject, 
        
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
        ,@(do { & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module } until ($true))
    } finally {
        if ($null -ne $Variable) {
            for ($i = 0; $i -lt $names.Length; $i++) {
                Remove-Variable $names[$i]
            }
        }
    }

}

New-Alias QToArray ConvertTo-Array
