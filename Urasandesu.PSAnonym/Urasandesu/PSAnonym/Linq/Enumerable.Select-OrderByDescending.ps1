# 
# File: Enumerable.Select-OrderByDescending.ps1
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


$CompareByDescending = {
    param ($1, $2)

    $_ = $1
    $1 = & $KeySelector.GetNewClosure() $_
    $_ = $2
    $2 = & $KeySelector.GetNewClosure() $_
    
    if ($null -eq $Comparer) {
        if ($1 -lt $2) { 1 } elseif ($2 -lt $1) { -1 } else { 0 }
    } else {
        (& $Comparer.GetNewClosure() $1 $2) * -1
    }
}

function Select-OrderByDescending {
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
        $Comparer = $null
    )

    $CompareByDescending = $CompareByDescending
    {
        [CmdletBinding()]
        param (
            [switch]
            $WithSpecialInvoker = $(throw New-Object Urasandesu.PSAnonym.Linq.InvalidInvocationException), 
            
            [scriptblock]
            $AdditionalComparer = $null
        )
        
        $InputObject = $InputObject
        $KeySelector = $KeySelector
        $Comparer = $Comparer

        $list = New-Object Collections.ArrayList
        $list.AddRange(@(& $InputObject -WithSpecialInvoker))
        $comparer_ = New-Object Urasandesu.PSAnonym.Linq.DelegateComparer `
                        $CompareByDescending.GetNewClosure(), $AdditionalComparer
        $list.Sort($comparer_)        
        $list

    }.GetNewClosure()

}

New-Alias QOrderByDescending Select-OrderByDescending

