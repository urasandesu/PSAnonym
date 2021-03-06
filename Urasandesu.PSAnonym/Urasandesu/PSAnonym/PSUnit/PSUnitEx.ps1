# 
# File: PSUnitEx.ps1
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


. PSUnit.ps1

$here = Split-Path $MyInvocation.MyCommand.Path -Parent
. $(Join-Path $here PSUnitEx.Assert-AreEnumerableEqual.ps1)
. $(Join-Path $here PSUnitEx.Assert-AreEqual.ps1)
. $(Join-Path $here PSUnitEx.Assert-Fail.ps1)
. $(Join-Path $here PSUnitEx.Assert-InstanceOf.ps1)
. $(Join-Path $here PSUnitEx.Assert-IsNull.ps1)
. $(Join-Path $here PSUnitEx.Assert-IsNotNull.ps1)
. $(Join-Path $here PSUnitEx.Assert-IsFalse.ps1)
. $(Join-Path $here PSUnitEx.Assert-IsTrue.ps1)
. $(Join-Path $here PSUnitEx.Assert-Greater.ps1)
. $(Join-Path $here PSUnitEx.Assert-GreaterOrEqual.ps1)
. $(Join-Path $here PSUnitEx.Assert-Less.ps1)
. $(Join-Path $here PSUnitEx.Assert-LessOrEqual.ps1)

