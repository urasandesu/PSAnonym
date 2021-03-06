# 
# File: Prototype.Add-AbstractProperty.ps1
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


function Add-AbstractProperty {
    
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name, 

        [Parameter(Position = 1)]
        [switch]
        $Getter, 

        [Parameter(Position = 2)]
        [switch]
        $Setter, 
        
        [switch]
        $Hidden
    )
    
    if ($null -ne $InputObject) {
        & $AssertIsPrototype $InputObject    
        & $AssertMemberNonexistence $InputObject $Name ($AssertionMessages.NonexistenceHelp1 -f 'Add-OverrideProperty', 'Add-AbstractProperty')
    }
    
    if ($Getter) {
        $value = { throw New-Object NotImplementedException }
    }
    
    if ($Setter) {
        $secondValue = { throw New-Object NotImplementedException }
    }
    
    $scriptProperty = New-Object Management.Automation.PSScriptProperty $Name, $value, $secondValue
    $scriptProperty.IsHidden = $Hidden
    
    if ($null -ne $InputObject) {
        $InputObject.__abstracts__.Add($scriptProperty.Name, $null)
        $InputObject.psobject.Members.Add($scriptProperty)
        $InputObject
    } else {
        , ($scriptProperty, ([Urasandesu.PSAnonym.Prototype.AddModes]::Abstract))
    }
}

New-Alias AbstractProperty Add-AbstractProperty
