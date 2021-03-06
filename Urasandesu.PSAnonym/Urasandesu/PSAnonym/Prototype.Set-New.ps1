# 
# File: Prototype.Set-New.ps1
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


function Set-New {
    
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [scriptblock]
        $Body
    )
    
    if ($null -ne $InputObject) {
        & $AssertIsPrototype $InputObject
    }

    $CacheScriptMethod = $CacheScriptMethod
    $InternalConstructorName = $InternalConstructorName
    $value = { & $CacheScriptMethod $this $InternalConstructorName $Body $true $args }.GetNewClosure()
    $scriptMethod = New-Object Management.Automation.PSScriptMethod $InternalConstructorName, $value
    $scriptMethod.IsHidden = $true
    
    if ($null -ne $InputObject) {
        $InputObject.psobject.Members.Remove($scriptMethod.Name)
        $InputObject.psobject.Members.Add($scriptMethod)
        $InputObject
    } else {
        , ($scriptMethod, ([Urasandesu.PSAnonym.Prototype.AddModes]::Override))
    }
}

New-Alias New Set-New
