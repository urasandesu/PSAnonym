# 
# File: Enumerable.Find-While.ps1
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



function Find-While {
<#
	.SYNOPSIS
		Returns elements from a sequence as long as a specified condition is true.

	.DESCRIPTION
        This command behaves like as Enumerable.TakeWhile<TSource>.

	.PARAMETER  InputObject
		A sequence to return elements from.

	.PARAMETER  Predicate
		A function to test each element for a condition.

	.EXAMPLE
		{ 0..9 } | Find-While { $_ -lt 4 } | Invoke-Linq
        0
        1
        2
        3
        
        DESCRIPTION
        -----------
        This command will return the values that are less than 4.

	.INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock

	.OUTPUTS
        System.Management.Automation.ScriptBlock

	.NOTES
        You can also refer to the Find-While command by its built-in alias, "QTakeWhile".

	.LINK
        Invoke-Linq

	.LINK
        System.Linq.Enumerable.TakeWhile<TSource>

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
    
    $ValidateInvoker = $ValidateInvoker
    {
        param ([bool]$runsFromSpecifiedInvoker = $false)
        
        & $ValidateInvoker $runsFromSpecifiedInvoker
        
        $InputObject = $InputObject
        $Predicate = $Predicate

        & $InputObject $runsFromSpecifiedInvoker | 
            ForEach-Object {
                if (& $Predicate.GetNewClosure()) {
                    , $_
                } else {
                    break
                }
            }

    }.GetNewClosure()

}

New-Alias QTakeWhile Find-While
