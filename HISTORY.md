## 0.4.0.0 (2013/03/31)

* Extended the LINQ features(corresponding to LINQ): 
  - Join-Zipped(Zip)
  - Skip-SequenceWhile(SkipWhile)
  - Skip-Sequence(Skip)

>

* In the LINQ, change the process used default closure to the process used Fast Closure and its cache to improve performance. 
* Reserved name for closure is changed $_ to $1, because $_ can not be overridden in some conditions. 
* Fix some typo of help documents.
* In all commands that return a scalar value, add the parameter to capture the variables in current scope.
* In New-Range command, the parameter -Start/-Count became abbreviatable.
* Until now, ConvertTo-Array command returned $null if an empty array is passed, but now it will return an empty array in that case. Because the previous behaviour was equivalent as Invoke-Linq command.

>

* In the Prototype, fix the bug that the type of super class is not able to get if it is multiple inheritance.
* Fix the bug that a property expands the array that has one element to one value if it is at the first time.


## 0.3.0.0 (2013/02/17)

* Added the following EXPERIMENTAL features(called Prototype): 
  - Add-AbstractMethod
  - Add-AbstractProperty
  - Add-Field
  - Add-Method
  - Add-OverrideMethod
  - Add-OverrideProperty
  - Add-Property
  - New-Prototype
  - Set-New
  
  About the usage, please see some integrated test cases that are defined in Prototype.psm1.Tests.ps1.

>

* In the feature PSUnitEx that improves the PSUnit usability, changed the interfaces. Because I understood wrongly about how to evaluate function parameters in PowerShell.


## 0.2.0.0 (2012/12/24)

* Added the following features(corresponding to LINQ): 
  - Get-Average(Average)
  - Select-Casted(Cast)
  - Join-Concatenated(Concat)
  - Get-Contained(Contains)
  - Get-Count(Count)
  - Select-DefaultIfEmpty(DefaultIfEmpty)
  - ConvertTo-Distinct(Distinct)
  - Select-ThenBy(ThenBy)
  - Select-ThenByDescending(ThenByDescending)

>

* Fix the issue: No values are returned if Find-CountOf is inserted in between the following commands: 
  - Get-AllSatisfied(All)
  - Get-AnySatisfied(Any)
  - Group-SequenceBy(GroupBy)
  - Select-OrderBy(OrderBy)
  - Select-OrderByDescending(OrderByDescending)

>

* Add the internal feature to emulate the function overloading as C#.
* Change all exception classes to standard classes and remove Add-Type call because PowerShell can't handle AppDomain easily.


## 0.1.0.0 (2012/12/05)

* Added the following features(corresponding to LINQ): 
  - Get-Aggregated(Aggregate)
  - Get-AllSatisfied(All)
  - Get-AnySatisfied(Any)
  - Group-SequenceBy(GroupBy)
  - Select-OrderBy(OrderBy)
  - Select-OrderByDescending(OrderByDescending)
  - ConvertTo-Array(ToArray)


## 0.0.0.0 (2012/11/27)

* First release
