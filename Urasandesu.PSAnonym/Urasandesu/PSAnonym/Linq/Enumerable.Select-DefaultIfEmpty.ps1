# 
# File: Enumerable.Select-DefaultIfEmpty.ps1
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



function Select-DefaultIfEmpty {
<#
    .SYNOPSIS
        Returns the elements of the specified sequence or the specified value in 
        a singleton collection if the sequence is empty.

    .DESCRIPTION
        This command behaves like as Enumerable.DefaultIfEmpty<TSource>.

    .PARAMETER  InputObject
        The sequence to return the specified value for if it is empty.

    .PARAMETER  DefaultValue
        The value to return if the sequence is empty.

    .EXAMPLE
        { 1..5 } | Select-DefaultIfEmpty 0 | ConvertTo-Array
        1
        2
        3
        4
        5
        
        DESCRIPTION
        -----------
        This command will return the original sequence because it isn't empty.

    .EXAMPLE
        { } | Select-DefaultIfEmpty 0 | ConvertTo-Array
        0
        
        DESCRIPTION
        -----------
        This command will return the specified value in a singleton collection 
        because the original sequence is empty.

    .INPUTS
        System.Management.Automation.ScriptBlock, 
        System.Object

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Select-DefaultIfEmpty command by its built-in alias, "QDefaultIfEmpty".

    .LINK
        ConvertTo-Array

    .LINK
        System.Linq.Enumerable.DefaultIfEmpty<TSource>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        $DefaultValue
    )
    
    SelectDefaultIfEmptySpacer $InputObject $DefaultValue

}

function SelectDefaultIfEmptySpacer {

    param (
        [scriptblock]
        $InputObject,

        $DefaultValue
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $DefaultValue = $DefaultValue
        
        & $Module { SelectDefaultIfEmptyCore $args[0] $args[1] $args[2] } $InputObject $DefaultValue $Module

    }.GetNewFastClosure()
}

function SelectDefaultIfEmptyCore {

    param (
        [scriptblock]
        $InputObject,

        $DefaultValue, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )

    $hasElements = @($false)
    & $InputObject -Module $Module | 
        ForEach-Object {
            if (!$hasElements[0]) {
                $hasElements[0] = $true
            }
            , $_
        }
    
    if (!$hasElements[0]) {
        , $DefaultValue
    }

}

New-Alias QDefaultIfEmpty Select-DefaultIfEmpty
