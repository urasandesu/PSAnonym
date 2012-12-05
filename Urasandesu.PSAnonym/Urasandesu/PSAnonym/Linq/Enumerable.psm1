# 
# File: Enumerable.psm1
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





function ExtractScriptBlock {
    
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [AllowNull()]
        [Collections.IEnumerator]
        $InputObject
    )

    if ($null -eq $InputObject) {
        $exParamName = '$InputObject'
        $exName = 'ArgumentNullException'
        $ex = New-Object $exName -ArgumentList $exParamName
        throw $ex
    }
    

    while ($InputObject.MoveNext()) {
        $block = $InputObject.Current -as [scriptblock]
        if ($block -eq $null) {
            $exMessage = 'The pipeline source object must be a scriptblock.'
            $exParamName = '$InputObject'
            $exName = 'ArgumentException'
            $ex = New-Object $exName -ArgumentList $exMessage
            throw $ex
        }
        break
    }
    
    $block
}









$invalidInvocationExceptionSource = @"
using System;
using System.Runtime.Serialization;

namespace Urasandesu.PSAnonym.Linq
{
    [Serializable]
    public class InvalidInvocationException : Exception
    {
        public InvalidInvocationException()
            : this("This command should be invoked from Invoke-Linq(Default Alias: QRun).")
        {
        }

        public InvalidInvocationException(string message)
            : base(message)
        {
        }

        public InvalidInvocationException(string message, Exception inner)
            : base(message, inner)
        {
        }

        protected InvalidInvocationException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
        }
    }
}
"@

Add-Type $invalidInvocationExceptionSource -WarningAction SilentlyContinue | Out-Null





$delegateComparerSource = @"
using System;
using System.Collections;

namespace Urasandesu.PSAnonym.Linq
{
    public delegate int DelegateComparerCompareHandler(object x, object y);

    public sealed class DelegateComparer : IComparer
    {
        DelegateComparerCompareHandler m_compareHandler;
        IComparer m_previousComparer;

        public DelegateComparer(DelegateComparerCompareHandler compareHandler)
        {
            if (compareHandler == null)
                throw new ArgumentNullException("comparerHandler");
            m_compareHandler = compareHandler;
        }

        public DelegateComparer(DelegateComparerCompareHandler compareHandler, IComparer previousComparer)
            : this(compareHandler)
        {
            m_previousComparer = previousComparer;
        }

        public int Compare(object x, object y)
        {
            int result = 0;
            if (m_previousComparer != null)
                result = m_previousComparer.Compare(x, y);

            return result != 0 ? result : m_compareHandler(x, y);
        }
    }
}
"@

Add-Type $delegateComparerSource -WarningAction SilentlyContinue | Out-Null





$delegateEqualityComparerSource = @"
using System.Collections;
using System.Collections.Generic;

namespace Urasandesu.PSAnonym.Linq
{
    public delegate bool DelegateEqualityComparerEqualsHandler(object x, object y);
    public delegate int DelegateEqualityComparerGetHashCodeHandler(object obj);

    public class DelegateEqualityComparer : IEqualityComparer
    {
        DelegateEqualityComparerEqualsHandler m_equalsHandler;
        DelegateEqualityComparerGetHashCodeHandler m_getHashCodeHandler;

        public DelegateEqualityComparer()
            : this(null, null)
        {
        }

        public DelegateEqualityComparer(
            DelegateEqualityComparerEqualsHandler equalsHandler, 
            DelegateEqualityComparerGetHashCodeHandler getHashCodeHandler)
        {
            m_equalsHandler = equalsHandler;
            m_getHashCodeHandler = getHashCodeHandler;
        }

        public new bool Equals(object x, object y)
        {
            return m_equalsHandler == null ? 
                        EqualityComparer<object>.Default.Equals(x, y) : 
                        m_equalsHandler(x, y);
        }

        public int GetHashCode(object obj)
        {
            return m_getHashCodeHandler == null ? 
                        EqualityComparer<object>.Default.GetHashCode(obj) : 
                        m_getHashCodeHandler(obj);
        }
    }
}
"@

Add-Type $delegateEqualityComparerSource -WarningAction SilentlyContinue | Out-Null





$groupingSource = @"
using System;
using System.Collections;

namespace Urasandesu.PSAnonym.Linq
{
    public interface IGrouping : IEnumerable
    {
        object Key { get; }
    }

    public class Grouping : IGrouping
    {
        object m_key;
        IEnumerable m_value;
        public Grouping(object key, IEnumerable value)
        {
            if (key == null)
                throw new ArgumentNullException("key");

            if (value == null)
                throw new ArgumentNullException("value");

            m_key = key;
            m_value = value;
        }

        public object Key
        {
            get { return m_key; }
        }

        public IEnumerator GetEnumerator()
        {
            return m_value.GetEnumerator();
        }
    }
}
"@

Add-Type $groupingSource -WarningAction SilentlyContinue | Out-Null





. $(Join-Path $here Enumerable.Get-Aggregated.ps1)
. $(Join-Path $here Enumerable.Get-AllSatisfied.ps1)
. $(Join-Path $here Enumerable.Get-AnySatisfied.ps1)

function ConvertTo-Enumerable {
    throw New-Object NotImplementedException
}
function Get-Average {
    throw New-Object NotImplementedException
}
function ConvertTo-Casted {
    throw New-Object NotImplementedException
}
function Join-Concatenated {
    throw New-Object NotImplementedException
}
function Get-Contained {
    throw New-Object NotImplementedException
}
function Get-Count {
    throw New-Object NotImplementedException
}
function Get-DefaultIfEmpty {
    throw New-Object NotImplementedException
}
function ConvertTo-Distinct {
    throw New-Object NotImplementedException
}
function Get-ElementAt {
    throw New-Object NotImplementedException
}
function Get-ElementAtOrDefault {
    throw New-Object NotImplementedException
}
function New-Empty {
    throw New-Object NotImplementedException
}
function Join-Except {
    throw New-Object NotImplementedException
}
function Get-First {
    throw New-Object NotImplementedException
}
function Get-FirstOrDefault {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Group-SequenceBy.ps1)

function Join-GroupedBy {
    throw New-Object NotImplementedException
}
function Join-Intersect {
    throw New-Object NotImplementedException
}
function Join-Sequence {
    throw New-Object NotImplementedException
}
function Get-Last {
    throw New-Object NotImplementedException
}
function Get-LastOrDefault {
    throw New-Object NotImplementedException
}
function Get-LongCount {
    throw New-Object NotImplementedException
}
function Get-Max {
    throw New-Object NotImplementedException
}
function Get-Min {
    throw New-Object NotImplementedException
}
function ConvertTo-OfType {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Select-OrderBy.ps1)
. $(Join-Path $here Enumerable.Select-OrderByDescending.ps1)
. $(Join-Path $here Enumerable.New-Range.ps1)
. $(Join-Path $here Enumerable.New-Repeat.ps1)

function ConvertTo-Reversed {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Select-Sequence.ps1)
. $(Join-Path $here Enumerable.Select-ManySequence.ps1)

function Get-SequenceEquality {
    throw New-Object NotImplementedException
}
function Get-Single {
    throw New-Object NotImplementedException
}
function Get-SingleOrDefault {
    throw New-Object NotImplementedException
}
function Skip-Sequence {
    throw New-Object NotImplementedException
}
function Skip-SequenceWhile {
    throw New-Object NotImplementedException
}
function Get-Sum {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Find-CountOf.ps1)
. $(Join-Path $here Enumerable.Find-While.ps1)

function Select-ThenBy {
    throw New-Object NotImplementedException
}
function Select-ThenByDescending {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.ConvertTo-Array.ps1)

function ConvertTo-Dictionary {
    throw New-Object NotImplementedException
}
function ConvertTo-List {
    throw New-Object NotImplementedException
}
function ConvertTo-Lookup {
    throw New-Object NotImplementedException
}
function Join-Union {
    throw New-Object NotImplementedException
}

. $(Join-Path $here Enumerable.Find-Sequence.ps1)
. $(Join-Path $here Enumerable.Invoke-Linq.ps1)



Export-ModuleMember -Function *-* -Alias *
