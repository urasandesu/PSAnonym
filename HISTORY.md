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

* Fis the issue: No values are returned if Find-CountOf is inserted in between the following commands: 
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
