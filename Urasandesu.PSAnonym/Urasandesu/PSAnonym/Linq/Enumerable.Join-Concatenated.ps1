# 
# File: Enumerable.Join-Concatenated.ps1
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



function Join-Concatenated {
<#
    .SYNOPSIS
        Concatenates two sequences.

    .DESCRIPTION
        This command behaves like as Enumerable.Concat<TSource>.

    .PARAMETER  InputObject
        The first sequence to concatenate. You can also refer the alias 'i'.

    .PARAMETER  InputObject2
        The sequence to concatenate to the first sequence. You can also refer the alias 'i2'.

    .EXAMPLE
        { 1, 2, 3 } | Join-Concatenated { 4, 5, 6 } | ConvertTo-Array
        1
        2
        3
        4
        5
        6
        
        DESCRIPTION
        -----------
        This command will return the values concatenated from the 2 sequence.

    .INPUTS
        System.Management.Automation.ScriptBlock, 
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Join-Concatenated command by its built-in alias, "QConcat".

    .LINK
        ConvertTo-Array

    .LINK
        System.Linq.Enumerable.Concat<TSource>

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
        $InputObject2
    )
    
    JoinConcatenatedSpacer $InputObject $InputObject2

}

function JoinConcatenatedSpacer {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $InputObject2
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
        
        & $Module { JoinConcatenatedCore $args[0] $args[1] $args[2] } $InputObject $InputObject2 $Module

    }.GetNewFastClosure()
}

function JoinConcatenatedCore {

    param (
        [scriptblock]
        $InputObject,

        [scriptblock]
        $InputObject2, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )

    & $InputObject -Module $Module | 
        ForEach-Object {
            , $_
        }

    & $InputObject2 -Module $Module | 
        ForEach-Object {
            , $_
        }

}

New-Alias QConcat Join-Concatenated
