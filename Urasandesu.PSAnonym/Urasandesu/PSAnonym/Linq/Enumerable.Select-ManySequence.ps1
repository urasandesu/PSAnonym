# 
# File: Enumerable.Select-ManySequence.ps1
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



function Select-ManySequence {
<#
    .SYNOPSIS
        Projects each element of a sequence to an collection and flattens the 
        resulting sequences into one sequence.

    .DESCRIPTION
        This command behaves like as Enumerable.SelectMany<TSource, TResult>.

    .PARAMETER  InputObject
        A sequence of values to project.

    .PARAMETER  Selector
        A transform function to apply to each element.

    .EXAMPLE
        { [AppDomain]::CurrentDomain.GetAssemblies() } | Select-ManySequence { $_.GetTypes() } | Find-Sequence { $_.BaseType -eq [Linq.Expressions.Expression] } | Invoke-Linq
        IsPublic IsSerial Name                                     BaseType
        -------- -------- ----                                     --------
        True     False    BinaryExpression                         System.Linq.Expressions.Expression
        True     False    ConditionalExpression                    System.Linq.Expressions.Expression
        True     False    ConstantExpression                       System.Linq.Expressions.Expression
        True     False    InvocationExpression                     System.Linq.Expressions.Expression
        True     False    LambdaExpression                         System.Linq.Expressions.Expression
        True     False    MemberExpression                         System.Linq.Expressions.Expression
        True     False    MethodCallExpression                     System.Linq.Expressions.Expression
        True     False    NewExpression                            System.Linq.Expressions.Expression
        True     False    NewArrayExpression                       System.Linq.Expressions.Expression
        True     False    MemberInitExpression                     System.Linq.Expressions.Expression
        True     False    ListInitExpression                       System.Linq.Expressions.Expression
        True     False    ParameterExpression                      System.Linq.Expressions.Expression
        True     False    TypeBinaryExpression                     System.Linq.Expressions.Expression
        True     False    UnaryExpression                          System.Linq.Expressions.Expression
        
        DESCRIPTION
        -----------
        This command will return all types that inherit System.Linq.Expressions.Expression.

    .INPUTS
        System.Management.Automation.ScriptBlock

    .OUTPUTS
        System.Management.Automation.ScriptBlock

    .NOTES
        You can also refer to the Select-ManySequence command by its built-in alias, "QSelectMany".

    .LINK
        System.AppDomain

    .LINK
        Find-Sequence

    .LINK
        System.Linq.Expressions.Expression

    .LINK
        Invoke-Linq

    .LINK
        System.Linq.Enumerable.SelectMany<TSource, TResult>

#>

    [CmdletBinding()]
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [scriptblock]
        $InputObject,

        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]
        $Selector
    )

    {
        [CmdletBinding()]
        param (
            [switch]
            $WithSpecialInvoker = $(throw New-Object Urasandesu.PSAnonym.Linq.InvalidInvocationException)
        )
        
        $InputObject = $InputObject
        $Selector = $Selector
        
        & $InputObject -WithSpecialInvoker | 
            ForEach-Object {
                & $Selector.GetNewClosure() $_ |
                    ForEach-Object {
                        , $_
                    }
            }

    }.GetNewClosure()

}

New-Alias QSelectMany Select-ManySequence
