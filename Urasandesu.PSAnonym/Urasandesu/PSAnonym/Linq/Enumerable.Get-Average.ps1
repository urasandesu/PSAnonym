# 
# File: Enumerable.Get-Average.ps1
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



function Get-Average {
<#
    .SYNOPSIS
        Computes the average of a sequence that are obtained by invoking a transform 
        function on each element of the input sequence.

    .DESCRIPTION
        This command behaves like as Enumerable.Average<TSource>.

    .PARAMETER  InputObject
        A sequence of values to calculate the average of.

    .PARAMETER  Selector
        A transform function to apply to each element.

    .EXAMPLE
        { 1..9 } | Get-Average
        5
        
        DESCRIPTION
        -----------
        This command will get the average from 1 to 9.

    .EXAMPLE
        { (2, 5), (1, 4), (5, 1) } | Get-Average { ($_[0] + $_[1]) / 2 }
        3
        
        DESCRIPTION
        -----------
        This command will get the average from 3 pairs each have 2 values.

    .INPUTS
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Get-Average command by its built-in alias, "QAverage".

    .LINK
        System.Linq.Enumerable.Average<TSource>

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0)]
        [AllowNull()]
        [scriptblock]
        $Selector = $null
    )

    if ($null -eq $Selector) {
        $Selector = { $_ }
    }

    $result = @(0, 0)
    do {
        & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module | 
            ForEach-Object {
                $result[0] += & $Selector.GetNewClosure() $_
                $result[1] += 1
            }
    } until ($true)
    
    if (0 -eq $result[1]) {
        throw New-Object InvalidOperationException 'Sequence contains no elements.'
    }
    
    $result[0] / $result[1]

}

New-Alias QAverage Get-Average
