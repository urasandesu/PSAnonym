# 
# File: PSUnitInvoker.psm1
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



function Invoke-PSUnit {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Position = 0)]
        [string]
        $Directory,
        
        [string[]]
        $Include
    )

    $dir = $PWD.Path
    if (($null -ne $Directory) -and (Test-Path -Path $Directory)) {
        $dir = Resolve-Path -Path $Directory
    }

    $tmpFile = [IO.Path]::GetTempFileName()
    Remove-Item $tmpFile
    New-Item $tmpFile -ItemType Directory | Out-Null
    
    Get-ChildItem $dir -Include $Include -Recurse | 
        Where-Object {$_ -is [IO.FileInfo]} | 
        Where-Object {$_.Name -like '*.Tests.ps1'} | 
        ForEach-Object {ToInvocationInfo $_.FullName $dir $tmpFile} | 
        ForEach-Object {RunPSUnit $_}
}





function ToInvocationInfo {
    [OutputType([Collections.Hashtable])]
    param (
        [string]
        $testFile, 
        
        [string]
        $rootDir, 

        [string]
        $tmpDir
    )

    $testFileDir = Split-Path $testFile -Parent
    $namespaceDir = $testFileDir.Replace($rootDir, '')
    $invocationFileDir = Join-Path $tmpDir $namespaceDir
    if (!(Test-Path -Path $invocationFileDir)) {
        New-Item $invocationFileDir -ItemType Directory | Out-Null
    }
    $invocationFile = Join-Path $invocationFileDir $(Split-Path $testFile -Leaf)
    @{TestFile = $testFile; InvocationFile = $invocationFile; RootDirectory = $rootDir}
}





function RunPSUnit {
    [OutputType([void])]
    param (
        [Collections.Hashtable]
        $invocationInfo 
    )

    $psUnitEx = $(Join-Path $PSScriptRoot PSUnitEx.ps1).Replace("'", "''")
    $testFile = $invocationInfo.TestFile.Replace("'", "''")
    $rootDir = $invocationInfo.RootDirectory.Replace("'", "''")
    @"
    . '{0}'
    . '{1}' -RootDirectory '{2}'
"@ -f $psUnitEx, $testFile, $rootDir > $invocationInfo.InvocationFile
        
    PSUnit.Run.ps1 -PSUnitTestFile $invocationInfo.InvocationFile
    
    $invocationFileDir = Split-Path $invocationInfo.InvocationFile -Parent
    Remove-Item $invocationFileDir -Recurse -Force -ErrorAction SilentlyContinue
}





Export-ModuleMember -Function *-*
