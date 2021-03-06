# 
# File: PSUnitEx.Assert-Greater.ps1
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
. $(Join-Path $here PSUnitEx.Assert-Greater.Exception.ps1)

function Assert-Greater {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [AllowNull()]
        [Alias("a1")]
        $Arg1,

        [Parameter(Position = 1, Mandatory = $true)]
        [AllowNull()]
        [Alias("a2")]
        $Arg2
    )

    if (([Collections.Comparer]::Default.Compare($Arg1, $Arg2) -eq 0) -or 
        ([Collections.Comparer]::Default.Compare($Arg1, $Arg2) -eq 1)) {
        throw AssertGreaterException $(Invoke-ExpressionIfNecessary $Arg1) $(Invoke-ExpressionIfNecessary $Arg2)
    }
}
