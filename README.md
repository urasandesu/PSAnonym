PSAnonym
=============

SYNOPSIS
-------
PSAnonym is supplemental library for PowerShell.

DESCRIPTION
-------
PSAnonym provides supplemental features that PowerShell doesn't have though other programing languages often have.

For example, LINQ support for pipeline breaking, PSUnit wrapper with some convenience assertion and so on.

Installation
-------
1. Download the PSAnonym repository to your local machine(or run `git clone`).

2. Run PowerShell as Administrator and call `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm` if it is necessary.

3. Copy the directory `Urasandesu.PSAnonym` from the downloaded repository to `$env:PSModulePath`.

4. Import the commands using `Import-Module 'Urasandesu.PSAnonym'`.

5. Have a good time!

LINK
-------
More information about this library can be found in `help about_PSAnonym`.
