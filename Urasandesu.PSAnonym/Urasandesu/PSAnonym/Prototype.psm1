# 
# File: Prototype.psm1
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



$here = Split-Path $MyInvocation.MyCommand.Path





New-Variable PrototypeTypeName 'Urasandesu.PSAnonym.Prototype' -Option ReadOnly

New-Variable AlternativeThisName 'Me' -Option ReadOnly

New-Variable CloneName 'Clone' -Option ReadOnly

New-Variable ConstructorName 'New' -Option ReadOnly
New-Variable InternalConstructorName 'NewCore' -Option ReadOnly
New-Variable AbstractsName '__abstracts__' -Option ReadOnly
New-Variable InheritancesName '__inheritances__' -Option ReadOnly
New-Variable MeName '__me__' -Option ReadOnly
New-Variable CacheName '__cache__' -Option ReadOnly
New-Variable SetMeName 'SetMe' -Option ReadOnly

New-Variable AssertionMessages $(data {
    ConvertFrom-StringData @"
        Prototype = Value is not a type '{0}'.
        Nonexistence = The member '{0}' has already existed in the designated object.
        NonexistenceHelp1 = If you want to override it, you could use '{0}' instead of '{1}'.
        NonexistenceHelp2 = If you want to inherit, you could use a parameter '-Force'.
        Existence = The member '{0}' does not exist or it exists but it is other member type.
        ExistenceHelp1 = If you want to just add it, you could use '{0}' instead of '{1}'. If you still have trouble, you should remove the member explicitly.
        IsGettable = The designated member '{0}' can't be overridden because it isn't gettable."
        IsSettable = The designated member '{0}' can't be overridden because it isn't settable."
        Constructible = This object is not constructible yet because it has some abstract members '{0}'.
"@ 
}) -Option ReadOnly

New-Variable PSVariableMixin ([Urasandesu.Pontine.Mixins.System.Management.Automation.PSVariableMixin]) -Option ReadOnly

Add-Type @"
using System.Management.Automation;

namespace Urasandesu.PSAnonym.Prototype
{
    public enum AddModes
    {
        None,
        Override,
        Abstract
    }

    public class CloneBarrier
    {
        public CloneBarrier(PSObject source)
        {
            Source = source;
        }

        public PSObject Source { get; private set; }
    }
}
"@ -Language CSharpVersion3 | Out-Null




New-Variable AssertIsPrototype {

    param (
        [psobject]
        $InputObject
    )
    
    $members = $InputObject | Get-Member $ConstructorName -MemberType ScriptMethod -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    $members = $InputObject | Get-Member $InternalConstructorName -MemberType ScriptMethod -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    $members = $InputObject | Get-Member $AbstractsName -MemberType NoteProperty -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    $members = $InputObject | Get-Member $InheritancesName -MemberType NoteProperty -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    $members = $InputObject | Get-Member $MeName -MemberType NoteProperty -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    $members = $InputObject | Get-Member $CacheName -MemberType NoteProperty -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    $members = $InputObject | Get-Member $SetMeName -MemberType ScriptMethod -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
    if (0 -eq ($InputObject.psobject.TypeNames -eq $PrototypeTypeName).Length) {
        throw New-Object ArgumentException ($AssertionMessages.Prototype -f $PrototypeTypeName), '$InputObject'
    }
    
} -Option ReadOnly





New-Variable AssertMemberNonexistence {

    param (
        [psobject]
        $InputObject, 
        
        [string]
        $Name, 
        
        [AllowNull()]
        [string]
        $AdditionalMessage
    )
    
    $members = $InputObject | Get-Member $Name -Force -ErrorAction SilentlyContinue
    if ($null -ne $members) {
        $message = $AssertionMessages.Nonexistence -f $Name
        if ($null -ne $AdditionalMessage) {
            $message = $message + " " + $AdditionalMessage
        }
        throw New-Object ArgumentException $message, '$Name'
    }

} -Option ReadOnly





New-Variable AssertMemberExistence {

    param (
        [psobject]
        $InputObject, 
        
        [string]
        $Name,
        
        [Management.Automation.PSMemberTypes]
        $MemberType,
        
        [AllowNull()]
        [string]
        $AdditionalMessage
    )
    
    $members = $InputObject | Get-Member $Name -MemberType $MemberType -Force -ErrorAction SilentlyContinue
    if ($null -eq $members) {
        $message = $AssertionMessages.Existence -f $Name
        if ($null -ne $AdditionalMessage) {
            $message = $message + " " + $AdditionalMessage
        }
        throw New-Object ArgumentException $message, '$Name'
    }

} -Option ReadOnly





New-Variable AssertIsGettable {

    param (
        [psobject]
        $InputObject,
        
        [string]
        $Name
    )

    if (!$InputObject.psobject.Properties[$Name].IsGettable) {
        throw New-Object ArgumentException ($AssertionMessages.IsGettable -f $Name), '$Name'
    }

} -Option ReadOnly




New-Variable AssertIsSettable {

    param (
        [psobject]
        $InputObject,
        
        [string]
        $Name
    )
    
    if (!$InputObject.psobject.Properties[$Name].IsSettable) {
        throw New-Object ArgumentException ($AssertionMessages.IsSettable -f $Name), '$Name'
    }

} -Option ReadOnly





New-Variable AssertIsConstructible {
    
    param (
        [psobject]
        $InputObject
    )
    
    if (0 -lt $InputObject.__abstracts__.Count) {
        throw New-Object InvalidOperationException ($AssertionMessages.Constructible -f ($InputObject.__abstracts__.Keys -join ', '))
    }
    
} -Option ReadOnly





New-Variable GetAllInheritances {

    param (
        [hashtable]
        $Inheritances
    )
    
    $stack = New-Object Collections.Generic.Stack[[Collections.DictionaryEntry]]
    & $GetAllInheritancesCore $Inheritances $stack
    ,$stack.ToArray()

} -Option ReadOnly





New-Variable GetAllInheritancesCore {

    param (
        [hashtable]
        $Inheritances, 
        
        [Collections.Generic.Stack[[Collections.DictionaryEntry]]]
        $Stack
    )
    
    foreach ($entry in $Inheritances.GetEnumerator()) {
        $Stack.Push($entry)
    }
    
    foreach ($entry in $Inheritances.GetEnumerator()) {
        & $GetAllInheritancesCore $entry.Value.__inheritances__ $Stack
    }    

} -Option ReadOnly





New-Variable CacheScriptMethod {
    
    param (
        [psobject]
        $InputObject,

        [string]
        $Name, 

        [scriptblock]
        $Body,
        
        [bool]
        $IsHidden, 
        
        [Object[]]
        $Params
    )

    $members = $InputObject.psobject.Members
    $cache = $InputObject.__cache__
    if (!$cache.ContainsKey($Name)) {
        $inheritances = & $GetAllInheritances $InputObject.__inheritances__
        foreach ($entry in $inheritances) {
            Invoke-Expression ('${0} = $entry.Value' -f $entry.Key)
        }
        $Me = $InputObject.__me__.Source
        $newBody = $Body.GetNewFastClosure()
        $scriptMethod = New-Object Management.Automation.PSScriptMethod $Name, $newBody
        $scriptMethod.IsHidden = $IsHidden
        $members.Remove($Name)
        $members.Add($scriptMethod)
        $cache.Add($Name, $null)
        Invoke-Expression ('$InputObject.{0}.Invoke($Params)' -f $Name)
    }
    
} -Option ReadOnly




New-Variable CacheScriptPropertyGetter {
    
    param (
        [psobject]
        $InputObject,

        [string]
        $Name, 

        [scriptblock]
        $Getter,
        
        [bool]
        $IsHidden, 
        
        [Object[]]
        $Params
    )

    $members = $InputObject.psobject.Members
    $cache = $InputObject.__cache__
    $getterName = 'get_' + $Name
    if (!$cache.ContainsKey($getterName)) {
        $inheritances = & $GetAllInheritances $InputObject.__inheritances__
        foreach ($entry in $inheritances) {
            Invoke-Expression ('${0} = $entry.Value' -f $entry.Key)
        }
        $Me = $InputObject.__me__.Source
        $value = $Getter.GetNewFastClosure() 
        $scriptProperty = New-Object Management.Automation.PSScriptProperty $Name, $value, $members[$Name].SetterScript
        $scriptProperty.IsHidden = $IsHidden
        $members.Remove($Name)
        $members.Add($scriptProperty)
        $cache.Add($getterName, $null)
        Invoke-Expression (',$InputObject.{0}' -f $Name)
    }
    
} -Option ReadOnly




New-Variable CacheScriptPropertySetter {
    
    param (
        [psobject]
        $InputObject,

        [string]
        $Name, 

        [scriptblock]
        $Setter,
        
        [bool]
        $IsHidden, 
        
        [Object[]]
        $Params
    )

    $members = $InputObject.psobject.Members
    $cache = $InputObject.__cache__
    $setterName = 'set_' + $Name
    if (!$cache.ContainsKey($setterName)) {
        $inheritances = & $GetAllInheritances $InputObject.__inheritances__
        foreach ($entry in $inheritances) {
            Invoke-Expression ('${0} = $entry.Value' -f $entry.Key)
        }
        $Me = $InputObject.__me__.Source
        $secondValue = $Setter.GetNewFastClosure() 
        $scriptProperty = New-Object Management.Automation.PSScriptProperty $Name, $members[$Name].GetterScript, $secondValue
        $scriptProperty.IsHidden = $IsHidden
        $members.Remove($Name)
        $members.Add($scriptProperty)
        $cache.Add($setterName, $null)
        Invoke-Expression ('$InputObject.{0} = $Params[0]' -f $Name)
    }
    
} -Option ReadOnly




. $(Join-Path $here Prototype.New-Prototype.ps1)
. $(Join-Path $here Prototype.Add-Field.ps1)
. $(Join-Path $here Prototype.Add-Property.ps1)
. $(Join-Path $here Prototype.Add-OverrideProperty.ps1)
. $(Join-Path $here Prototype.Add-AbstractProperty.ps1)
. $(Join-Path $here Prototype.Add-Method.ps1)
. $(Join-Path $here Prototype.Add-OverrideMethod.ps1)
. $(Join-Path $here Prototype.Add-AbstractMethod.ps1)
. $(Join-Path $here Prototype.Set-New.ps1)





Export-ModuleMember -Function *-* -Alias *
