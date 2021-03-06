# 
# File: Enumerable.psm1.Tests.New-Repeat.ps1
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



function Test.New-Repeat_ShouldRepeatSameObject_IfInitializerIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $initializer = { 
        New-Object PSObject | 
            Add-Member NoteProperty m_count 0 -PassThru | 
            Add-Member ScriptProperty Count `
            {
                $this.m_count
            } `
            {
                param ([int]$value)
                $this.m_count = $value
            } -PassThru 
    }

    # Act
    $result = New-Repeat $initializer

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    $start = [datetime]::Now
    do {
        & $result -Module $modEnumerable | 
            ForEach-Object {
                if ($_.Count++ -gt 1) {
                    break
                }
                if ([datetime]::Now - $start -gt [TimeSpan]::FromSeconds(1)) {
                    Assert-Fail
                }
            }
    } until ($true)
}





function Test.New-Repeat_ShouldRepeatSameObjectAndDispose_IfDisposableIsPassed {

    # Arrange
    $modPSAnonym = Get-Module Urasandesu.PSAnonym
    $modEnumerable = $modPSAnonym | Get-NestedModule -Path *Urasandesu\PSAnonym\Linq\Enumerable*
    $source = @"
public class Disposable : System.IDisposable
{
    bool m_disposed = false;
    public bool Disposed
    {
        get { return m_disposed; }
        set { m_disposed = value; }
    }
    public void Dispose()
    {
        m_disposed = true;
    }
}
"@
    Add-Type $source -ErrorAction SilentlyContinue | Out-Null
    
    $initializer = { New-Object Disposable }

    # Act
    $result = New-Repeat $initializer

    # Assert
    Assert-InstanceOf ([scriptblock]) $result
    $obj = $null
    do {
        & $result -Module $modEnumerable | 
            ForEach-Object {
                $obj = $_
                break
            }
    } until ($true)
    Assert-IsTrue $obj.Disposed
}





function Test.New-Repeat_ShouldThrowInvalidInvocationException_IfInvalidWayToCall {
    
    param (
        [ArgumentNullException] 
        $ExpectedException = $(New-Object ArgumentNullException)
    )

    # Arrange
    # nop

    # Act
    $result = New-Repeat { New-Object Random }

    # Assert
    do {
        & $result | 
            ForEach-Object {
                break
            }
    } until ($true)
    Assert-Fail
}
