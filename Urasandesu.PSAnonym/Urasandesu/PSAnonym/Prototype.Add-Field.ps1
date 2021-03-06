# 
# File: Prototype.Add-Field.ps1
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


function Add-Field {
    
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject]
        $InputObject,

        [parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name,

        [parameter(Mandatory = $true, Position = 1)]
        $Value,
        
        [switch]
        $Hidden
    )
    
    if ($null -ne $InputObject) {
        & $AssertIsPrototype $InputObject    
        & $AssertMemberNonexistence $InputObject $Name
    }
    
    if ($Value -is [Management.Automation.PSVariable]) {
        $variable = New-Object Management.Automation.PSVariable $Name, $Value.Value, $Value.Options, $Value.Attributes
    } else {
        $variable = $PSVariableMixin::New($Name, $Value, $Value.GetType())
    }
    $variableProperty = New-Object Management.Automation.PSVariableProperty $variable
    $variableProperty.IsHidden = $Hidden
    
    if ($null -ne $InputObject) {
        $InputObject.psobject.Members.Add($variableProperty)
        $InputObject
    } else {
        , ($variableProperty, ([Urasandesu.PSAnonym.Prototype.AddModes]::None))
    }
}

New-Alias Field Add-Field
