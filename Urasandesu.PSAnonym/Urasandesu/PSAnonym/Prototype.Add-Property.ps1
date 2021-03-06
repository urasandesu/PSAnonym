# 
# File: Prototype.Add-Property.ps1
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



function Add-Property {
    
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject]
        $InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name, 

        [Parameter(Position = 1)]
        [scriptblock]
        $Getter, 

        [Parameter(Position = 2)]
        [scriptblock]
        $Setter, 
        
        [switch]
        $Hidden
    )

    if ($null -ne $InputObject) {
        & $AssertIsPrototype $InputObject    
        & $AssertMemberNonexistence $InputObject $Name ($AssertionMessages.NonexistenceHelp1 -f 'Add-Property', 'Add-OverrideProperty')
    }

    $CacheScriptPropertyGetter = $CacheScriptPropertyGetter
    if ($null -ne $Getter) {
        $value = { & $CacheScriptPropertyGetter $this $Name $Getter $Hidden $args }.GetNewClosure()
    }
    
    $CacheScriptPropertySetter = $CacheScriptPropertySetter
    if ($null -ne $Setter) {
        $secondValue = { & $CacheScriptPropertySetter $this $Name $Setter $Hidden $args }.GetNewClosure()
    }
    
    $scriptProperty = New-Object Management.Automation.PSScriptProperty $Name, $value, $secondValue
    $scriptProperty.IsHidden = $Hidden
    
    if ($null -ne $InputObject) {
        $InputObject.psobject.Members.Add($scriptProperty)
        $InputObject
    } else {
        , ($scriptProperty, ([Urasandesu.PSAnonym.Prototype.AddModes]::None))
    }
}

New-Alias Property Add-Property
