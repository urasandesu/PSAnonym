# 
# File: Get-NestedModule.psm1
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



function Get-NestedModule {
<#
    .SYNOPSIS
        Returns a nested module having the specified criteria.

    .DESCRIPTION
        The command returns a nested module defined on the specified module 
        having the specified name or path.

    .PARAMETER  Module
        The module defines the nested module.

    .PARAMETER  Name
        The name of a nested module. This parameter supports the designation by 
        wild card.

    .PARAMETER  Path
        The path of a nested module. This parameter supports the designation by 
        wild card.

    .EXAMPLE
        Get-Module | Get-NestedModule -Name 'PS*'
        Description
        -----------
        aaaaaaaaaaa
        aaaaaaaaaaa

    .LINK
        Get-Module

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Management.Automation.PSModuleInfo]
        $Module,
        
        [Parameter(ParameterSetName = "NameSet")]
        [string]
        $Name,
        
        [Parameter(ParameterSetName = "PathSet")]
        [string]
        $Path
    )
    
    switch ($PsCmdlet.ParameterSetName) {
        "NameSet" {
            $Module.NestedModules | Where-Object {$_.Name -like $Name}
            break
        }
        
        "PathSet" {
            $Module.NestedModules | Where-Object {$_.Path -like $Path}
            break
        }
    }

}

New-Alias gnmo Get-NestedModule

Export-ModuleMember -Function *-* -Alias *
