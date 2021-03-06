# 
# File: Enumerable.New-Repeat.ps1
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



function New-Repeat {
<#
    .SYNOPSIS
        Generates a sequence that contains one repeated value.

    .DESCRIPTION
        This command behaves like as Enumerable.Repeat<TResult>.

    .PARAMETER  Initializer
        The value to be repeated.

    .EXAMPLE
        New-Repeat { New-Object Random } | Select-Sequence { $1.Next(0, 9) } | Find-CountOf 5 | Invoke-Linq
        7
        4
        3
        2
        6
        
        DESCRIPTION
        -----------
        This command will return the random numbers between 0 and 9.

    .INPUTS
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the New-Repeat command by its built-in alias, "QRepeat".

    .LINK
        New-Object

    .LINK
        System.Random

    .LINK
        Select-Sequence

    .LINK
        Find-CountOf

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.Repeat<TResult>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $Initializer
    )
    
    NewRepeatSpacer $Initializer

}

function NewRepeatSpacer {

    param (
        [scriptblock]
        $Initializer
    )
    
    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        & $Module { NewRepeatCore $args[0] $args[1] } $Initializer $Module

    }.GetNewFastClosure()
}

function NewRepeatCore {

    param (
        [scriptblock]
        $Initializer, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )
    
    $item = & $Initializer
    try {
        while ($true) {
            , $item
        }
    } finally {
        if ($item -is [IDisposable]) {
            $item.Dispose()
        }
    }

}

New-Alias QRepeat New-Repeat
