# 
# File: Enumerable.Invoke-Linq.ps1
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



function Invoke-Linq {
<#
    .SYNOPSIS
        Invokes specified LINQ command.

    .DESCRIPTION
        This command invokes the LINQ command that defined in PSAnonym. Also this 
        command can safely invoke the script that stops the whole script even if 
        it have just been used commonly.

    .PARAMETER  InputObject
        LINQ command to invoke.

    .PARAMETER  $Variable
        Capture variables to use in LINQ command.

    .EXAMPLE
        { 0..9 } | Find-CountOf 5 | Invoke-Linq
        0
        1
        2
        3
        4
        
        DESCRIPTION
        -----------
        This command will return 5 elements from the head of the source.

    .EXAMPLE
        { break } | Invoke-Linq; "You can't reach here by only having invoked it commonly."
        You can't reach here by only having invoked it commonly.
        
        DESCRIPTION
        -----------
        When the command { break } is invoked commonly(e.g. & { break }), the 
        whole script will be stopped. it works as intended if using the command Invoke-Linq.

    .INPUTS
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Object

    .NOTES
        You can also refer to the Invoke-Linq command by its built-in alias, "QRun".

    .LINK
        Find-CountOf

    .LINK
        about_Break

#>

    [CmdletBinding()]
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
        do {
            & $InputObject -Module $MyInvocation.MyCommand.ScriptBlock.Module
        } until ($true)
    } finally {
        if ($null -ne $Variable) {
            for ($i = 0; $i -lt $names.Length; $i++) {
                Remove-Variable $names[$i]
            }
        }
    }

}

New-Alias QRun Invoke-Linq
