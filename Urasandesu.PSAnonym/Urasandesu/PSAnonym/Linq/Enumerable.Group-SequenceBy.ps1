# 
# File: Enumerable.Group-SequenceBy.ps1
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


function Group-SequenceBy {
<#
    .SYNOPSIS
        Groups the elements of a sequence according to a specified key selector 
        function and compares the keys by using a specified comparer.

    .DESCRIPTION
        This command behaves like as Enumerable.GroupBy<TSource, TKey>.

    .PARAMETER  InputObject
        A sequence whose elements to group.

    .PARAMETER  KeySelector
        A function to extract the key for each element.

    .EXAMPLE
        { 0, 1, 0, 1, 0 } | Group-SequenceBy { $_ } | Select-ManySequence { $_.Group } | Invoke-Linq
        0
        0
        0
        1
        1
        
        DESCRIPTION
        -----------
        This command will return grouped elements of the sequence.

    .EXAMPLE
        { (0, 0, 1), (1, 0, 0), (0, 0, 0) } | Group-SequenceBy { $_[0] }, { $_[1] } | Invoke-Linq
        Count Name                      Group
        ----- ----                      -----
            2 0, 0                      {0 0 1, 0 0 0}
            1 1, 0                      {1 0 0}
        
        DESCRIPTION
        -----------
        This command will return grouped elements by the multiple keys of the sequence.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Management.Automation.ScriptBlock[]

    .OUTPUTS
        System.Management.Automation.ScriptBlock
    
    .NOTES
        You can also refer to the Group-SequenceBy command by its built-in alias, "QGroupBy".

    .LINK
        Select-ManySequence

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.GroupBy<TSource, TKey>

#>
    
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock[]]
        $KeySelector
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $KeySelector = $KeySelector

        & $Module { GroupSequenceByCore $args[0] $args[1] $args[2] } $InputObject $KeySelector $Module
        
    }.GetNewClosure()

}

function GroupSequenceByCore {
    
    param (
        [scriptblock]
        $InputObject,

        [scriptblock[]]
        $KeySelector ,
        
        [Management.Automation.PSModuleInfo]
        $Module
    )
    
    $list = New-Object Collections.ArrayList
    $list.AddRange(@(do { & $InputObject -Module $Module } until ($true)))
    
    $property = $(
        foreach ($keySelector_ in $KeySelector) {
            & {
                $keySelector_ = $keySelector_
                { & $keySelector_.GetNewClosure() $_ }.GetNewClosure()
            }
        }
    )

    $list | Group-Object $property
}

New-Alias QGroupBy Group-SequenceBy
