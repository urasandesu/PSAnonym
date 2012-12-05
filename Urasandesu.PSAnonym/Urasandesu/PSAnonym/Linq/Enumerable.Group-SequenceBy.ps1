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


$Equals = {
    param ($1, $2)

    if ($null -eq $Equal) {
        [Object]::Equals($1, $2)
    } else {
        & $Equal.GetNewClosure() $1 $2
    }
}

$GetHashCode = {
    param ($obj)

    if ($null -eq $Hash) {
        if ($null -eq $obj) { 0 } else { $obj.GetHashCode() }
    } else {
        $_ = $obj
        & $Hash.GetNewClosure() $_
    }
}

function Group-SequenceBy {
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $KeySelector,

        [Parameter(Position = 1)]
        [scriptblock]
        $Equal,

        [Parameter(Position = 2)]
        [scriptblock]
        $Hash
    )
    
    $Equals = $Equals
    $GetHashCode = $GetHashCode
    {
        [CmdletBinding()]
        param (
            [switch]
            $WithSpecialInvoker = $(throw New-Object Urasandesu.PSAnonym.Linq.InvalidInvocationException)
        )
        
        $InputObject = $InputObject
        $KeySelector = $KeySelector
        $Equal = $Equal
        $Hash = $Hash
        
        $comparer_ = New-Object Urasandesu.PSAnonym.Linq.DelegateEqualityComparer `
                        $Equals.GetNewClosure(), $GetHashCode.GetNewClosure()
        $hashtable = New-Object Collections.Hashtable $comparer_
        
        & $InputObject -WithSpecialInvoker | 
            ForEach-Object {
                $key = & $KeySelector.GetNewClosure() $_
                if (!$hashtable.ContainsKey($key)) {
                    $hashtable.Add($key, (New-Object Collections.ArrayList))
                }
                [Void]$hashtable[$key].Add($_)
            }
        
        $hashtable.GetEnumerator() | 
            ForEach-Object { 
                New-Object Urasandesu.PSAnonym.Linq.Grouping $_.Key, $_.Value
            }
        
    }.GetNewClosure()

}

New-Alias QGroupBy Group-SequenceBy
