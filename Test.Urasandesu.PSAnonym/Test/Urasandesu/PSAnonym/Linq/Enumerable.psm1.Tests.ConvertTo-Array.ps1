# 
# File: Enumerable.psm1.Tests.ConvertTo-Array.ps1
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



function Test.ConvertTo-Array_ShouldReturnArray_IfRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = ConvertTo-Array -InputObject { 0..9 }

    # Assert
    Assert-AreEnumerableEqual 0..9 $result
}



function Test.ConvertTo-Array_ShouldReturnEmptyArray_IfEmptyRangeIsPassed {

    # Arrange
    # nop

    # Act
    $result = ConvertTo-Array -InputObject { }

    # Assert
    Assert-AreEnumerableEqual @() $result
}





function Test.ConvertTo-Array_ShouldReturnArray_IfRangeFromPipeline {

    # Arrange
    # nop

    # Act
    $result = { 0..9 } | QToArray

    # Assert
    Assert-AreEnumerableEqual 0..9 $result
}
