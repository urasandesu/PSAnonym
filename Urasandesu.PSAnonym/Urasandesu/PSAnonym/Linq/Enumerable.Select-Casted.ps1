# 
# File: Enumerable.Select-Casted.ps1
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



function Select-Casted {
<#
    .SYNOPSIS
        Casts the elements of an sequence to the specified type.

    .DESCRIPTION
        This command behaves like as Enumerable.Cast<TResult>.

    .PARAMETER  InputObject
        The sequence that contains the elements to be cast to type Type.

    .PARAMETER  Type
        The type to cast the elements of InputObject to.

    .EXAMPLE
        { 1, 2, 3 } | Select-Casted [int] | ConvertTo-Array
        1
        2
        3
        
        DESCRIPTION
        -----------
        This command will return the values casted to int.

    .EXAMPLE
        { 1, 2, 3.1 } | Select-Casted [int] | ConvertTo-Array
        1
        2
        Cannot cast from source type to destination type.
            + CategoryInfo          :
            + FullyQualifiedErrorId : Cannot cast from source type to destination type.
        
        DESCRIPTION
        -----------
        This command will try to return the values casted to int, but the type of 
        the last value is double. So, this command throws InvalidCastException.

    .INPUTS
        System.Management.Automation.ScriptBlock, System.Object

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Select-Casted command by its built-in alias, "QCast".

    .LINK
        ConvertTo-Array

    .LINK
        System.Linq.Enumerable.Cast<TResult>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [Type]
        $Type
    )
    
    SelectCastedSpacer $InputObject $Type

}

function SelectCastedSpacer {

    param (
        [scriptblock]
        $InputObject,

        [Type]
        $Type
    )

    $MODULE_NULL_MESSAGE = $MODULE_NULL_MESSAGE
    {
        [CmdletBinding()]
        param (
            [Management.Automation.PSModuleInfo]
            $Module = $(throw New-Object ArgumentNullException $MODULE_NULL_MESSAGE)
        )
        
        $InputObject = $InputObject
        $Type = $Type
        
        & $Module { SelectCastedCore $args[0] $args[1] $args[2] } $InputObject $Type $Module

    }.GetNewFastClosure()
}

function SelectCastedCore {

    param (
        [scriptblock]
        $InputObject,

        [Type]
        $Type, 
        
        [Management.Automation.PSModuleInfo]
        $Module
    )

    & $InputObject -Module $Module | 
        ForEach-Object {
            if (!($_ -is $Type)) {
                throw New-Object InvalidCastException 'Cannot cast from source type to destination type.'
            }
            , $_
        }

}

New-Alias QCast Select-Casted
