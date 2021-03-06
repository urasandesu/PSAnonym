# 
# File: Prototype.New-Prototype.ps1
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



New-Variable NewPrototype {
    
    param (
        [string]
        $Name
    )

    $prototype = New-Object psobject
    $members = $prototype.psobject.Members
    
    $new = New-Object Management.Automation.PSScriptMethod $ConstructorName, {
        & $AssertIsConstructible $this

        $body = {
            $clone = $this.__me__.Source.Clone()
            $clone.__inheritances__.MutableForEach({
                $Me[$1.Key] =　$Me[$1.Key].Clone()
                $Me[$1.Key].__cache__.Clear()
            })
            
            $clone.__cache__.Clear()
            
            $clone.SetMe($clone)
            
            $clone.NewCore.Invoke((,$Params))
            
            $clone
        }
        & $CacheScriptMethod $this $ConstructorName $body $false $args
    }
    $members.Add($new)
    
    $newCore = New-Object Management.Automation.PSScriptMethod $InternalConstructorName, {
    }
    $newCore.IsHidden = $true
    $members.Add($newCore)
    
    $__abstracts__ = New-Object Management.Automation.PSVariableProperty `
                         $PSVariableMixin::New($AbstractsName, @{}, [Collections.Hashtable])
    $__abstracts__.IsHidden = $true
    $members.Add($__abstracts__)
    
    $__inheritances__ = New-Object Management.Automation.PSVariableProperty `
                            $PSVariableMixin::New($InheritancesName, @{}, [Collections.Hashtable])
    $__inheritances__.IsHidden = $true
    $members.Add($__inheritances__)
    
    $__me__ = New-Object Management.Automation.PSVariableProperty `
                    $PSVariableMixin::New($MeName, (New-Object Urasandesu.PSAnonym.Prototype.CloneBarrier $prototype), 
                                            [Urasandesu.PSAnonym.Prototype.CloneBarrier])
    $__me__.IsHidden = $true
    $members.Add($__me__)
    
    $__cache__ = New-Object Management.Automation.PSVariableProperty `
                    $PSVariableMixin::New($CacheName, @{}, [Collections.Hashtable])
    $__cache__.IsHidden = $true
    $members.Add($__cache__)
    
    $setMe = New-Object Management.Automation.PSScriptMethod $SetMeName, {
        param ($Me)
        $this.__me__ = New-Object Urasandesu.PSAnonym.Prototype.CloneBarrier $Me
        
        foreach ($entry in $this.__inheritances__.GetEnumerator()) {
            $inheritance = $entry.Value
            $inheritance.SetMe($Me)
        }
    }
    $setMe.IsHidden = $true
    $members.Add($setMe)
    
    $typeNames = $prototype.psobject.TypeNames
    $typeNames.Insert(0, $PrototypeTypeName)
    $typeNames.Insert(0, $Name)
    
    $prototype

} -Option ReadOnly


New-Variable IsTargetToInherit {

    param (
        [Management.Automation.PSMemberInfo]
        $Member
    )

    if ($Member.IsReserved) {
        $false
    } else {
        (($Member.Name -ne $CloneName) -and 
         ($Member.Name -ne $ConstructorName) -and 
         ($Member.Name -ne $InternalConstructorName) -and 
         ($Member.Name -ne $SetMeName) -and 
         ($Member.MemberType -eq 'ScriptMethod')) -or 
        (($Member.Name -ne $AbstractsName) -and 
         ($Member.Name -ne $InheritancesName) -and 
         ($Member.Name -ne $MeName) -and 
         ($Member.Name -ne $CacheName) -and 
         ($Member.MemberType -eq 'NoteProperty')) -or 
        ($Member.MemberType -eq 'ScriptProperty')
    }    
    
} -Option ReadOnly


New-Variable Inherit {
    
    param (
        [psobject]
        $BaseObject,
        
        [string]
        $Name,
        
        [Hashtable]
        $State, 
        
        [bool]
        $Force
    )
    
    & $AssertIsPrototype $BaseObject
    $State.BaseObjectIndex++

    $baseNew = New-Object Management.Automation.PSScriptMethod $ConstructorName, {
        $body = {
            $this.__cache__.Clear()                
            $this.SetMe($this.__me__.Source)
            $RuntimeHelpers = [Runtime.CompilerServices.RuntimeHelpers]
            if ($RuntimeHelpers::GetHashCode($Me) -ne $RuntimeHelpers::GetHashCode($this.__me__.Source)) {
                $paramList = $this.NewCore.Script.RuntimeDefinedParameterList
                for ($i = 0; $i -lt $paramList.Count; $i++) {
                    if ($paramList[$i].Name -eq $AlternativeThisName) {
                        $paramList[$i].Value = $this.__me__.Source
                        break
                    }
                }
                
                $params_ = $this.NewCore.Script.RuntimeDefinedParameters
                $params_[$AlternativeThisName].Value = $this.__me__.Source
            }
            $this.NewCore.Invoke((,$Params))
        }
        & $CacheScriptMethod $this $ConstructorName $body $false $args
    }
    
    if ($null -eq $State.Prototype) {
        $prototype = $BaseObject.Clone()
        
        $prototype.__cache__.Clear()
        
        $base = $BaseObject.Clone()
        $base.__inheritances__.MutableForEach({
            $Me[$1.Key] =　$Me[$1.Key].Clone()
            $Me[$1.Key].__cache__.Clear()
        })
        $base.__cache__.Clear()

        $base.psobject.Members.Remove($baseNew.Name)
        $base.psobject.Members.Add($baseNew)
        
        $prototype.__inheritances__.Clear()
        $prototype.__inheritances__.Add($base.psobject.TypeNames[0], $base)
        
        $prototype.SetMe($prototype)
        
        $typeNames = $prototype.psobject.TypeNames
        $typeNames.Insert(0, $Name)
        
        $State.Prototype = $prototype
    } else {
        $prototype = $State.Prototype
        
        $prototype.__cache__.Clear()

        $base = $BaseObject.Clone()
        $base.__inheritances__.MutableForEach({
            $Me[$1.Key] =　$Me[$1.Key].Clone()
            $Me[$1.Key].__cache__.Clear()
        })
        $base.__cache__.Clear()

        $base.psobject.Members.Remove($baseNew.Name)
        $base.psobject.Members.Add($baseNew)
        
        $typeNames = $prototype.psobject.TypeNames
        $typeNames.Insert(2, $base.psobject.TypeNames[0])
        
        $base.SetMe($prototype)

        $prototype.__inheritances__.Add($base.psobject.TypeNames[0], $base)
        
        $memberTypes = [Management.Automation.PSMemberTypes]::All
        $memberTypes = $memberTypes -bxor [Management.Automation.PSMemberTypes]::Event
        $memberTypes = $memberTypes -bxor [Management.Automation.PSMemberTypes]::MemberSet
        $memberTypes = $memberTypes -bxor [Management.Automation.PSMemberTypes]::ParameterizedProperty
        $memberTypes = $memberTypes -bxor [Management.Automation.PSMemberTypes]::Method
        $memberTypes = $memberTypes -bxor [Management.Automation.PSMemberTypes]::PropertySet
        $memberTypes = $memberTypes -bxor [Management.Automation.PSMemberTypes]::Property
        $matchOptions = [Urasandesu.Pontine.Management.Automation.MshMemberMatchOptions]::IncludeHidden
        $candidateMembers = $base.psobjectex.Members.Match('*', $memberTypes, $matchOptions)
        foreach ($candidateMember in $candidateMembers) {
            if (!(& $IsTargetToInherit $candidateMember)) { continue }
            
            $member = $candidateMember
            $members = $prototype.psobject.Members
            $__abstracts__ = $prototype.__abstracts__
            
            if ($Force) {
                $members.Remove($member.Name)
                $__abstracts__.Remove($member.Name)
            } else {
                & $AssertMemberNonexistence $prototype $member.Name $AssertionMessages.NonexistenceHelp2
            }
            $members.Add($member)
            if ($BaseObject.__abstracts__.ContainsKey($member.Name)) {
                $__abstracts__.Add($member.Name, $null)
            }
        }
    }
    
} -Option ReadOnly



New-Variable AddOrOverride {

    param (
        [psobject]
        $Prototype,
        
        [Management.Automation.PSMemberInfo]
        $Member,
        
        [Urasandesu.PSAnonym.Prototype.AddModes]
        $Mode
    )

    $members = $Prototype.psobject.Members
    $__abstracts__ = $Prototype.__abstracts__
    
    switch ($Mode) {
        None {
            switch ($Member.MemberType) {
                ScriptProperty { $help = $AssertionMessages.NonexistenceHelp1 -f 'Add-OverrideProperty', 'Add-Property' }
                ScriptMethod { $help = $AssertionMessages.NonexistenceHelp1 -f 'Add-OverrideMethod', 'Add-Method' }
            }
            & $AssertMemberNonexistence $Prototype $Member.Name $help
        }
        
        Override {
            switch ($Member.MemberType) {
                ScriptProperty { $help = $AssertionMessages.ExistenceHelp1 -f 'Add-Property', 'Add-OverrideProperty' }
                ScriptMethod { $help = $AssertionMessages.ExistenceHelp1 -f 'Add-Method', 'Add-OverrideMethod' }
            }
            & $AssertMemberExistence $Prototype $Member.Name $Member.MemberType $help
            
            $members.Remove($Member.Name)
            $__abstracts__.Remove($Member.Name)
        }
        
        Abstract {
            switch ($Member.MemberType) {
                ScriptProperty { $help = $AssertionMessages.NonexistenceHelp1 -f 'Add-OverrideProperty', 'Add-AbstractProperty' }
                ScriptMethod { $help = $AssertionMessages.NonexistenceHelp1 -f 'Add-OverrideMethod', 'Add-AbstractMethod' }
            }
            & $AssertMemberNonexistence $Prototype $Member.Name $help
            
            $__abstracts__.Add($Member.Name, $null)
        }
    }

    $members.Add($Member)

} -Option ReadOnly


function New-Prototype {
    
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [psobject[]]
        $InputObject, 
        
        [parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name,

        [parameter(Position = 1)]
        [scriptblock]
        $Declaration,

        [switch]
        $Force
    )
    
    begin {
        $state = @{ Prototype = $null; BaseObjectIndex = -1 }
    } process {
        if ($null -ne $InputObject) {
            foreach ($InputObject_ in $InputObject) {
                & $Inherit $InputObject_ $Name $state $Force
            }
        }
    } end {
        if ($null -eq $state.Prototype) {
            $state.Prototype = & $NewPrototype $Name
        }
        
        if ($null -ne $Declaration) {
            $declarations = @(& $Declaration)
            foreach ($Declaration_ in $declarations) {
                ($member, $mode) = $Declaration_
                & $AddOrOverride $state.Prototype $member $mode
            }
        }
        
        $state.Prototype
    }
}

New-Alias Prototype New-Prototype
