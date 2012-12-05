# 
# File: Enumerable.New-Range.ps1
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



function New-Range {
<#
    .SYNOPSIS
        Generates a sequence of integral numbers within a specified range.

    .DESCRIPTION
        This command behaves like as Enumerable.Range.

    .PARAMETER  Start
        The value of the first integer in the sequence.

    .PARAMETER  Count
        The number of sequential integers to generate.

    .EXAMPLE
        New-Range 0 10 | Invoke-Linq
        0
        1
        2
        3
        4
        5
        6
        7
        8
        9
        
        DESCRIPTION
        -----------
        This command will return the range between 0 and 9.

    .INPUTS
        System.Int32, System.Int32

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the New-Range command by its built-in alias, "QRange".

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.Range

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [int]
        $Start,

        [Parameter(Position = 1, Mandatory = $true)]
        [int]
        $Count
    )
    
    if (($Count -lt 0) -or ([int]::MaxValue -lt ($Start + $Count - 1))) {
        $exParamName = '$Count'
        $exName = 'ArgumentOutOfRangeException'
        $ex = New-Object $exName -ArgumentList $exParamName
        throw $ex
    }

    {
        [CmdletBinding()]
        param (
            [switch]
            $WithSpecialInvoker = $(throw New-Object Urasandesu.PSAnonym.Linq.InvalidInvocationException)
        )
        
        $Start = $Start
        $Count = $Count
        
        for ($index = $Start; $index -lt $Start + $Count; $index++) {
            ,$index
        }
        
    }.GetNewClosure()
}

New-Alias QRange New-Range
