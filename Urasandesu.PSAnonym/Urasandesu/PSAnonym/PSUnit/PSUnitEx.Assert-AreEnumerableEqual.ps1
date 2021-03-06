# 
# File: PSUnitEx.Assert-AreEnumerableEqual.ps1
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
. $(Join-Path $here PSUnitEx.Assert-AreEnumerableEqual.Exception.ps1)

function Assert-AreEnumerableEqual {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [AllowNull()]
        [Alias("e")]
        $Expected,

        [Parameter(Position = 1, Mandatory = $true)]
        [AllowNull()]
        [Alias("a")]
        $Actual
    )

    if (($null -eq $Expected) -and ($null -eq $Actual)) {
        return
    }

    if ($null -eq $Expected) {
        throw AssertAreEnumerableEqualException $null $(Invoke-ExpressionIfNecessary $Actual) -OneSidedNull
    }

    if ($null -eq $Actual) {
        throw AssertAreEnumerableEqualException $(Invoke-ExpressionIfNecessary $Expected) $null -OneSidedNull
    }

    $expected_ = Invoke-ExpressionIfNecessary $Expected
    $actual_ = Invoke-ExpressionIfNecessary $Actual
    if ($expected_ -is [Collections.IEnumerable]) {
        $expectedEnumerator = $expected_.GetEnumerator()
    } else {
        if ($expected_ -isnot [Collections.IEnumerator]) {
            throw AssertAreEnumerableEqualException $expected_ $null -TypeMismatch
        }
    }

    if ($actual_ -is [Collections.IEnumerable]) {
        $actualEnumerator = $actual_.GetEnumerator()
    } else {
        if ($actual_ -isnot [Collections.IEnumerator]) {
            throw AssertAreEnumerableEqualException $null $actual_ -TypeMismatch
        }
    }
    
    $expectedList = New-Object Collections.ArrayList
    $actualList = New-Object Collections.ArrayList
    $expectedHasNext = $expectedEnumerator.MoveNext()
    $actualHasNext = $actualEnumerator.MoveNext()
    while ($expectedHasNext -and $actualHasNext) {
        $expectedVal = $expectedEnumerator.Current
        $actualVal = $actualEnumerator.Current
        $expectedList.Add($expectedVal)
        $actualList.Add($actualVal)
        if (![Object]::Equals($expectedVal, $actualVal)) {
            throw AssertAreEnumerableEqualException $expectedList.ToArray() $actualList.ToArray() -ValueMismatch
        }
        $expectedHasNext = $expectedEnumerator.MoveNext()
        $actualHasNext = $actualEnumerator.MoveNext()
    }
    
    if ($expectedHasNext) {
        $expectedVal = $expectedEnumerator.Current
        $expectedList.Add($expectedVal)
        throw AssertAreEnumerableEqualException $expectedList.ToArray() $actualList.ToArray() -ValueMismatch
    }
    
    if ($actualHasNext) {
        $actualVal = $actualEnumerator.Current
        $actualList.Add($actualVal)
        throw AssertAreEnumerableEqualException $expectedList.ToArray() $actualList.ToArray() -ValueMismatch
    }
}
