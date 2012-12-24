# 
# File: Enumerable.Get-Count.ps1
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



function Get-Count {
<#
    .SYNOPSIS
        Returns a number that represents how many elements in the specified sequence satisfy a condition.

    .DESCRIPTION
        This command behaves like as Enumerable.Count<TSource>.

    .PARAMETER  InputObject
        A sequence that contains elements to be tested and counted.

    .PARAMETER  Predicate
        A function to test each element for a condition.

    .EXAMPLE
        { 1..10 } | Get-Count
        10
        
        DESCRIPTION
        -----------
        This command will return the count of the elements of the designated array.

    .EXAMPLE
        { ('Cyan', 1), ('LightGray', 1), ('Cyan', 2), ('AliceBlue', 1), ('AliceBlue', 4) } | Get-Count { $_[0] -eq 'AliceBlue' }
        2
        
        DESCRIPTION
        -----------
        This command will return the count of the element that satisfies the designated condition.

    .INPUTS
        System.Management.Automation.ScriptBlock, 
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Object(integral number)

    .NOTES
        You can also refer to the Get-Count command by its built-in alias, "QCount".

    .LINK
        System.Linq.Enumerable.Count<TSource>

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0)]
        [scriptblock]
        $Predicate = $null
    )
    
    if ($null -eq $Predicate) {
        $Predicate = { $true }
    }
    
    $result = @(0)
    do {
        & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module | 
            ForEach-Object {
                if (& $Predicate.GetNewClosure() $_) {
                    $result[0]++
                }
            }
    } until ($true)
    
    $result[0]

}

New-Alias QCount Get-Count
