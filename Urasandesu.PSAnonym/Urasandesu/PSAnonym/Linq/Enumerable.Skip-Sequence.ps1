# 
# File: Enumerable.Skip-Sequence.ps1
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



function Skip-Sequence {
<#
    .SYNOPSIS
        Bypasses a specified number of elements in a sequence and then returns the remaining elements.

    .DESCRIPTION
        This command behaves like as Enumerable.Skip<TSource>.

    .PARAMETER  InputObject
        An sequence to return elements from.

    .PARAMETER  Count
        The number of elements to skip before returning the remaining elements.

    .EXAMPLE
        { 0..9 } | Skip-Sequence 5 | Invoke-Linq
        5
        6
        7
        8
        9
        
        DESCRIPTION
        -----------
        This command will return the remaining elements except the top 5 of the source.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Int32

    .OUTPUTS
        System.Management.Automation.ScriptBlock
    
    .NOTES
        You can also refer to the Skip-Sequence command by its built-in alias, "QSkip".
    
    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.Skip<TSource>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [int]
        $Count
    )
    
    SkipSequenceSpacer $InputObject $Count

}

function SkipSequenceSpacer {

    param (
        [scriptblock]
        $InputObject,

        [int]
        $Count
    )
    
    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $Count = $Count
        
        & $Module { SkipSequenceCore $args[0] $args[1] $args[2] } $InputObject $Count $Module
    
    }.GetNewFastClosure()
}

function SkipSequenceCore {

    param (
        [scriptblock]
        $InputObject,

        [int]
        $Count, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )
    
    & $InputObject -Module $Module | 
        ForEach-Object {
            if ($Count -le $i++) {
                , $_
            }
        }

}

New-Alias QSkip Skip-Sequence
