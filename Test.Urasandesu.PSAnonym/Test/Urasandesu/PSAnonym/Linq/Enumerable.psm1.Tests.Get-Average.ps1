# 
# File: Enumerable.psm1.Tests.Get-Average.ps1
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



function Test.Get-Average_ShouldReturnAverage_IfRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = Get-Average -InputObject { 1..9 }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Average_ShouldReturnAverage_IfRangeIsPassedFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 1..9 } | QAverage

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Average_ShouldReturnAverageByExpression_IfRangeIsPassed {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Average { $1.Key1 } -InputObject { 1..9 | % { & $new1 $_ } }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Average_ShouldReturnAverageByExpression_IfRangeIsPassedFromPipeline {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = { 1..9 | % { & $new1 $_ } } | QAverage { $1.Key1 }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Average_ShouldReturnAverageByExpression_IfWithExplicitParameter {

    # Arrange
    $new1 = {
        param ($Key1)
        
        New-Object PSObject | 
            Add-Member NoteProperty Key1 $Key1 -PassThru
    }

    # Act
    $result = Get-Average { param ($val) $val.Key1 } -InputObject { 1..9 | % { & $new1 $_ } }

    # Assert
    Assert-AreEqual 5 $result
}





function Test.Get-Average_ShouldReturnAverageByExpression_IfCalledFromOtherScope {

    # Arrange
    function Invoke-Average {
        param ($Value)
        { 1..10 } | QAverage { if ($1 % $Value -eq 0) { $1 } }.GetNewFastClosure()
    }

    # Act
    $result = Invoke-Average (2)

    # Assert
    Assert-AreEqual 3 $result
}





function Test.Get-Average_ShouldThrowInvalidOperationException_IfEmptyRangeIsPassed {
    
    param (
        [InvalidOperationException] 
        $ExpectedException = $(New-Object InvalidOperationException)
    )

    # Arrange
    # nop

    # Act
    $result = Get-Average -InputObject { @() }

    # Assert
    & $result
    Assert-Fail
}