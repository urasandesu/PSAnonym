# 
# File: PSUnitEx.Assert-AreEnumerableEqual.Exception.ps1
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



function AssertAreEnumerableEqualException {
    [CmdletBinding()]
    [OutputType([System.Exception])]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [AllowNull()]
        $Expected,

        [Parameter(Position = 1, Mandatory = $true)]
        [AllowNull()]
        $Actual, 

        [Parameter(Position = 2, ParameterSetName = "OneSidedNullSet")]
        [Switch]
        $OneSidedNull, 
        
        [Parameter(Position = 2, ParameterSetName = "TypeMismatchSet")]
        [Switch]
        $TypeMismatch,

        [Parameter(Position = 2, ParameterSetName = "ValueMismatchSet")]
        [Switch]
        $ValueMismatch
    )
        
    $exName = 'PSUnit.Assert.PSUnitAssertFailedException'
    switch ($PsCmdlet.ParameterSetName) {
        "OneSidedNullSet" {
            if ($null -eq $Expected) {
                $exMessage = "Expected: null, But was: < $($Actual -join ', ') >"
            } elseif ($null -eq $Actual) {
                $exMessage = "Expected: < $($Expected -join ', ') >, But was: null"
            } else {
                throw New-Object InvalidOperationException
            }
            break
        }

        "TypeMismatchSet" {
            if ($null -eq $Expected) {
                $exMessage = "Actual type can not enumerate: < $($Actual.GetType()) >"
            } elseif ($null -eq $Actual) {
                $exMessage = "Expected type can not enumerate: < $($Expected.GetType()) >"
            } else {
                throw New-Object InvalidOperationException
            }
            break
        }

        "ValueMismatchSet" {
            $exMessage = ''
            if ($Expected.Length -ne $Actual.Length) {
                if ($Expected.Length -lt $Actual.Length) {
                    $exMessage += "Expected length: < $($Expected.Length) >, But was greater or equal than: < $($Actual.Length) >"
                } else {
                    $exMessage += "Expected length is greater or equal than: < $($Expected.Length) >, But was: < $($Actual.Length) >"
                }
            } else {
                if (5 -le $Expected.Length) {
                    $expected_ = $Expected[-5..-1]
                    $exMessage += "Expected: < ... $($expected_ -join ', ') ... >"
                } else {
                    $exMessage += "Expected: < $($Expected -join ', ') ... >"
                }
                
                if (5 -le $Actual.Length) {
                    $actual_ = $Actual[-5..-1]
                    $exMessage += ", But was: < ..., $($actual_ -join ', '), ... >"
                } else {
                    $exMessage += ", But was: < $($Actual -join ', ') ... >"
                }
            }
            break
        }
    }

    New-Object -TypeName $exName -ArgumentList $exMessage
}
