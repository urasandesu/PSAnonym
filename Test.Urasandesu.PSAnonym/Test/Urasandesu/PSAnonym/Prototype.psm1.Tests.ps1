# 
# File: Prototype.psm1.Tests.ps1
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


param (
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $RootDirectory
)

Import-Module $(Join-Path $(Join-Path $RootDirectory ..) Urasandesu.PSAnonym)


New-Variable NewPrototypeMock {
    
    param (
        [string]
        $Name
    )
    
    $mock = 
        New-Object psobject | 
        Add-Member ScriptMethod New { $this.NewCore() } -PassThru | 
        Add-Member ScriptMethod NewCore { $this.psobject.Copy() } -PassThru | 
        Add-Member NoteProperty __abstracts__ @{} -PassThru | 
        Add-Member NoteProperty __inheritances__ @{} -PassThru | 
        Add-Member NoteProperty __me__ $null -PassThru | 
        Add-Member NoteProperty __cache__ @{} -PassThru | 
        Add-Member ScriptMethod SetMe { } -PassThru
    $mock.__me__ = New-Object Urasandesu.PSAnonym.Prototype.CloneBarrier $mock
    $mock.psobject.TypeNames.Insert(0, 'Urasandesu.PSAnonym.Prototype')
    $mock.psobject.TypeNames.Insert(0, $Name)
    $mock

} -Option ReadOnly


$here = Split-Path $MyInvocation.MyCommand.Path
. $(Join-Path $here Prototype.psm1.Tests.New-Prototype.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-Field.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-Property.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-OverrideProperty.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-AbstractProperty.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-Method.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-OverrideMethod.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Add-AbstractMethod.ps1)
. $(Join-Path $here Prototype.psm1.Tests.Set-New.ps1)





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest1 {

    # Arrange
    $mock = 
        Prototype MyMock | 
        Field m_value 10 | 
        Property Value {
            $Me.m_value
        } {
            $Me.m_value = $Params[0]
        } | 
        Method Add {
            param ($value)
            $Me.m_value + $value
        }

    # Act
    $actualValue = $mock.Value
    $mock.Value = $actualValue + 10
    $actualResult = $mock.Add(10)
    $actualValue = $mock.Value
    $mock.Value = $actualValue + 10
    $actualResult = $mock.Add(10)

    # Assert
    Assert-AreEqual 20 $actualValue
    Assert-AreEqual 40 $actualResult
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest2 {
    
    # Arrange
    $mock = 
        Prototype MyMock {
            Field m_value 10 -Hidden
            
            Property Value {
                $Me.m_value
            } {
                $Me.m_value = $Params[0]
            }
            
            Method Add {
                param ($value)
                $Me.m_value + $value
            }
        }

    # Act
    $actualValue = $mock.Value
    $mock.Value = $actualValue + 10
    $actualResult = $mock.Add(10)

    # Assert
    Assert-AreEqual 10 $actualValue
    Assert-AreEqual 30 $actualResult
    Assert-IsNull ($mock | Get-Member m_value)
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest3 {
    
    # Arrange
    $MyMock = 
        Prototype MyMock {
            
            Field m_value ([string].Default) -Hidden
            
            New {
                param ([AllowNull()]$value)
                $Me.m_value = $value
            }
            
            Property Value {
                $Me.m_value
            }
        }

    # Act
    $mock1 = $MyMock.New('aiueo')
    $mock2 = $MyMock.New()

    # Assert
    Assert-AreEqual '' $MyMock.Value
    Assert-AreEqual 'aiueo' $mock1.Value
    Assert-AreEqual '' $mock2.Value
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest4 {
    
    # Arrange
    $BaseMock = 
        Prototype BaseMock {
            
            Field m_items ([string[]].Default) -Hidden
            
            New {
                param ([AllowNull()][String[]]$items)
                $Me.m_items = $items
            }
            
            AbstractProperty Value -Getter
            AbstractMethod Generate
        }
    
    $MyMock1 = 
        $BaseMock | 
            Prototype MyMock1 {
                
                OverrideProperty Value {
                    $Me.m_items -join '::'
                }
                
                OverrideMethod Generate {
                    'using namespace ' + $Me.Value
                }
            }
        
    $MyMock2 = 
        $BaseMock | 
            Prototype MyMock2 | 
                OverrideProperty Value {
                    ($Me.m_items | % { $_.ToUpper() }) -join '_'
                } | 
                OverrideMethod Generate {
                    '#ifndef ' + $Me.Value
                }
    
    # Act
    $mock1 = $MyMock1.New(('Urasandesu', 'Swathe', 'Hosting'))
    $mock2 = $MyMock2.New(('Urasandesu', 'Swathe', 'Hosting'))

    # Assert
    try {
        $BaseMock.New()
        Assert-Fail
    } catch [Management.Automation.MethodInvocationException] {
        $innerException = $_.Exception.InnerException
        Assert-InstanceOf ([Management.Automation.RuntimeException]) $innerException
        $innerException = $innerException.InnerException
        Assert-InstanceOf ([InvalidOperationException]) $innerException
    }
    Assert-AreEqual 'using namespace Urasandesu::Swathe::Hosting' $mock1.Generate()
    Assert-AreEqual '#ifndef URASANDESU_SWATHE_HOSTING' $mock2.Generate()
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest5 {
    
    # Arrange
    $BaseMock = 
        Prototype BaseMock {
            
            Field m_items ([string[]].Default) -Hidden
            
            New {
                param ([AllowNull()][String[]]$items)
                $Me.m_items = $items
            }
            
            AbstractProperty Value -Getter
            AbstractMethod Generate
        }
    
    $MyMock1 = 
        $BaseMock | 
            Prototype MyMock1 {
            
                New {
                    param ([AllowNull()][String[]]$items)
                    $BaseMock.New($items)
                    $Me.m_items = $Me.m_items[0..($Me.m_items.Length - 2)] + 'ClassApiAt'
                }
                
                OverrideProperty Value {
                    $Me.m_items[0..($Me.m_items.Length - 1)] -join '::'
                }
                
                OverrideMethod Generate {
                    'using namespace ' + $Me.Value
                }
            }
        
    $MyMock2 = 
        $BaseMock | 
            Prototype MyMock2 | 
                New {
                    param ([AllowNull()][String[]]$items)
                    $BaseMock.New($items)
                    $Me.m_items = $Me.m_items[0..($Me.m_items.Length - 2)] + 'ClassApiLabel' + $Me.m_items[-1]
                } |
                OverrideProperty Value {
                    (($Me.m_items[0..($Me.m_items.Length - 1)] | % { $_.ToUpper() }) -join '_') + 'APIAT_H'
                } | 
                OverrideMethod Generate {
                    '#ifndef ' + $Me.Value
                }
    
    # Act
    $mock1 = $MyMock1.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))
    $mock2 = $MyMock2.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))

    # Assert
    Assert-AreEqual 'using namespace Urasandesu::Swathe::Hosting::ClassApiAt' $mock1.Generate()
    Assert-AreEqual '#ifndef URASANDESU_SWATHE_HOSTING_CLASSAPILABEL_HOSTINFOAPIAT_H' $mock2.Generate()
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest6 {
    
    # Arrange
    $BaseMock1 = 
        Prototype BaseMock11111 {
            AbstractProperty Value -Getter
            AbstractMethod Generate
        }
    
    $BaseMock2 = 
        Prototype BaseMock22222 {            
            Field m_items ([string[]].Default) -Hidden
            New {
                param ([AllowNull()][String[]]$items)
                $Me.m_items = $items
            }
        }
    
    $MyMock1 = 
        $BaseMock1, $BaseMock2 | 
            Prototype MyMock1 {
            
                New {
                    param ([AllowNull()][String[]]$items)
                    $result = $BaseMock22222.New($items)
                    if ($null -ne $result.m_items) {
                        throw New-Object InvalidOperationException
                    }
                    $Me.m_items = $Me.m_items[0..($Me.m_items.Length - 2)] + 'ClassApiAt'
                }
                
                OverrideProperty Value {
                    $Me.m_items[0..($Me.m_items.Length - 1)] -join '::'
                }
                
                OverrideMethod Generate {
                    'using namespace ' + $Me.Value
                }
            }
        
    $MyMock2 = 
        $BaseMock1, $BaseMock2 | 
            Prototype MyMock2 | 
                New {
                    param ([AllowNull()][String[]]$items)
                    $result = $BaseMock22222.New($items)
                    if ($null -ne $result.m_items) {
                        throw New-Object InvalidOperationException
                    }
                    $Me.m_items = $Me.m_items[0..($Me.m_items.Length - 2)] + 'ClassApiLabel' + $Me.m_items[-1]
                } |
                OverrideProperty Value {
                    (($Me.m_items[0..($Me.m_items.Length - 1)] | % { $_.ToUpper() }) -join '_') + 'APIAT_H'
                } | 
                OverrideMethod Generate {
                    '#ifndef ' + $Me.Value
                }
    
    # Act
    $mock1 = $MyMock1.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))
    $mock2 = $MyMock2.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))
    $mock2 = $MyMock2.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))

    # Assert
    Assert-AreEqual 'using namespace Urasandesu::Swathe::Hosting::ClassApiAt' $mock1.Generate()
    Assert-AreEqual '#ifndef URASANDESU_SWATHE_HOSTING_CLASSAPILABEL_HOSTINFOAPIAT_H' $mock2.Generate()
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest7 {
    
    # Arrange
    $BaseMock1 = 
        Prototype BaseMock11111 {
            AbstractProperty Value -Getter
            AbstractMethod Generate
        }
    
    $BaseMock2 = 
        Prototype BaseMock22222 {            
            Field m_items ([string[]].Default) -Hidden
            New {
                param ([AllowNull()][String[]]$items)
                $Me.m_items = $items
            }
        }
    
    $BaseMock3 = 
        $BaseMock1, $BaseMock2 | 
            Prototype BaseMock33333
        
    $MyMock = 
        $BaseMock3 | 
            Prototype MyMock | 
                New {
                    param ([AllowNull()][String[]]$items)
                    $BaseMock22222.New($items)
                    $Me.m_items = $Me.m_items[0..($Me.m_items.Length - 2)] + 'ClassApiLabel' + $Me.m_items[-1]
                } |
                OverrideProperty Value {
                    (($Me.m_items[0..($Me.m_items.Length - 1)] | % { $_.ToUpper() }) -join '_') + 'APIAT_H'
                } | 
                OverrideMethod Generate {
                    '#ifndef ' + $Me.Value
                }
    
    # Act
    $mock = $MyMock.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))
    $mock = $MyMock.New(('Urasandesu', 'Swathe', 'Hosting', 'HostInfo'))

    # Assert
    Assert-AreEqual '#ifndef URASANDESU_SWATHE_HOSTING_CLASSAPILABEL_HOSTINFOAPIAT_H' $mock.Generate()
}





function Test.Prototype_ShouldReturnIntendedObject_AdHocIntegrationTest8 {
    
    # Arrange
    $InterfaceMock = 
        Prototype InterfaceMock | 
            AbstractProperty Value1 -Getter | 
            AbstractProperty Value2 -Getter | 
            AbstractProperty Value3 -Getter
    
    $ConcreteMock = 
        $InterfaceMock | 
            Prototype ConcreteMock | 
                OverrideProperty Value1 { 1 } | 
                OverrideProperty Value2 { ,@(1) } | 
                OverrideProperty Value3 { ,@(1, 2) }
    
    $DecorateMock = 
        $InterfaceMock | 
            Prototype DecorateMock | 
                Field m_concreteMock ([Object].Default) -Hidden | 
                New { param ($ConcreteMock) $Me.m_concreteMock = $($ConcreteMock) } | 
                OverrideProperty Value1 { $Me.m_concreteMock.Value1 } | 
                OverrideProperty Value2 { ,@($Me.m_concreteMock.Value2) } | 
                OverrideProperty Value3 { ,@($Me.m_concreteMock.Value3 + 3) }
    
    # Act
    $mock = $ConcreteMock.New()
    $mock = $DecorateMock.New($mock)
    $mock = $ConcreteMock.New()
    $mock = $DecorateMock.New($mock)

    # Assert
    Assert-AreEqual 1 $mock.Value1
    Assert-AreEqual 1 $mock.Value1
    Assert-AreEnumerableEqual @(1) $mock.Value2
    Assert-AreEnumerableEqual @(1) $mock.Value2
    Assert-AreEnumerableEqual (1, 2, 3) $mock.Value3
    Assert-AreEnumerableEqual (1, 2, 3) $mock.Value3
}





function Test.Prototype_ShouldReturnIntendedObject_PerformanceIntegrationTest1 {

    # Arrange
    $Base1 = 
        New-Object psobject | 
            Add-Member NoteProperty Value 10 -PassThru | 
            Add-Member NoteProperty m_data '' -PassThru | 
            Add-Member ScriptMethod Generate { $this.Value.ToString() + ' from First Base.' } -PassThru | 
            Add-Member ScriptProperty Data { $this.m_data; } { $this.m_data = $args[0] } -PassThru
    
    $Base2 = 
        New-Object psobject | 
            Add-Member NoteProperty Base1 $Base1 -PassThru | 
            Add-Member ScriptMethod Generate { $this.Base1.Generate(); $this.Base1.Value.ToString() + ' from Second Base.' } -PassThru | 
            Add-Member ScriptProperty Data { $this.Base1.Data } { $this.Base1.Data = $args[0] } -PassThru
    
    $Base3 = 
        New-Object psobject | 
            Add-Member NoteProperty Base2 $Base2 -PassThru | 
            Add-Member ScriptMethod Generate { $this.Base2.Generate(); $this.Base2.Base1.Value.ToString() + ' from Third Base.' } -PassThru | 
            Add-Member ScriptProperty Data { $this.Base2.Data } { $this.Base2.Data = $args[0] } -PassThru
    
    $Mine1 = 
        Prototype Mine1 |
            Field Value 10 | 
            Field m_data ([string].Default) -Hidden | 
            Method Generate { $Me.Value.ToString() + ' from First Mine.' } | 
            Property Data { $Me.m_data } { $Me.m_data = $Params[0] }
        
    $Mine2 = 
        $Mine1 | 
            Prototype Mine2 | 
                OverrideMethod Generate { $Mine1.Generate(); $Me.Value.ToString() + ' from Second Mine.' } | 
                OverrideProperty Data { $Mine1.Data } { $Mine1.Data = $Params[0] }

    $Mine3 = 
        $Mine2 | 
            Prototype Mine3 | 
                OverrideMethod Generate { $Mine2.Generate(); $Me.Value.ToString() + ' from Third Mine.' } | 
                OverrideProperty Data { $Mine2.Data } { $Mine2.Data = $Params[0] }
    
    # Act
    $ticksBase3Generate = (Measure-Command { for ($index = 0; $index -lt 1000; $index++) { $Base3.Generate() } }).Ticks
    $ticksBase3DataGetter = (Measure-Command { for ($index = 0; $index -lt 1000; $index++) { $Base3.Data } }).Ticks
    $ticksBase3DataSetter = (Measure-Command { for ($index = 0; $index -lt 1000; $index++) { $Base3.Data = 'aiueo' } }).Ticks
    $ticksMine3Generate = (Measure-Command { for ($index = 0; $index -lt 1000; $index++) { $Mine3.Generate() } }).Ticks
    $ticksMine3DataGetter = (Measure-Command { for ($index = 0; $index -lt 1000; $index++) { $Mine3.Data } }).Ticks
    $ticksMine3DataSetter = (Measure-Command { for ($index = 0; $index -lt 1000; $index++) { $Mine3.Data = 'aiueo' } }).Ticks

    # Assert
    Assert-GreaterOrEqual ([double]$ticksMine3Generate) ([double]$ticksBase3Generate * 2.6)
    Assert-GreaterOrEqual ([double]$ticksMine3DataGetter) ([double]$ticksBase3DataGetter * 2.6)
    Assert-GreaterOrEqual ([double]$ticksMine3DataSetter) ([double]$ticksBase3DataSetter * 2.6)
}





function Test.Prototype_ShouldReturnIntendedObject_IsolatedEnvironmentTest1 {

    # Arrange
    $Mine1 = 
        Prototype Mine1 |
            Field Value 10 | 
            Method Generate { $Me.Value.ToString() + ' from First Mine.' }
        
    $Mine2 = 
        $Mine1 | 
            Prototype Mine2 | 
                OverrideMethod Generate { $Mine1.Generate(); $Me.Value.ToString() + ' from Second Mine.' }

    $Mine3 = 
        $Mine2 | 
            Prototype Mine3 | 
                OverrideMethod Generate { $Mine2.Generate(); $Me.Value.ToString() + ' from Third Mine.' }
    
    # Act
    $Mine1.Value = 20
    $Mine2.Value = 30
    $Mine3.Value = 40

    # Assert
    Assert-AreEnumerableEqual @('20 from First Mine.') @($Mine1.Generate())
    Assert-AreEnumerableEqual @('30 from First Mine.', '30 from Second Mine.') @($Mine2.Generate())
    Assert-AreEnumerableEqual @('40 from First Mine.', '40 from Second Mine.', '40 from Third Mine.') @($Mine3.Generate())
}





function Test.Prototype_ShouldReturnIntendedObject_TemplateEngineTrial1 {

    # Arrange
    $Prototype = 
        Prototype Prototype

    $ProtoFile = 
        $Prototype | 
            Prototype ProtoFile {
                Field Items ([String[]].Default)
                Field DependentHeaders ([Object[]].Default)
                
                Property RootDirectory { $Me.Items[0] }
                AbstractProperty Extension -Getter
                AbstractProperty Template -Getter
                Property Namespaces { $Me.Items[1..($Me.Items.Length - 2)] }
                Property Namespace { $Me.Namespaces -join '::' }
                Property Function { $Me.Items[-3] }
                Property FunctionDetail { $Me.Items[-2] }
                Property Name { $Me.Items[-1] }
                Property FullName { $Me.Items[1..($Me.Items.Length - 1)] -join '::' }
                Property FullNameAsPath { ($Me.Items[1..($Me.Items.Length - 1)] -join '/') + $Me.Extension }
                
            }

    $ProtoHeader = 
        $ProtoFile | 
            Prototype ProtoHeader {
                AbstractProperty Suffix -Getter
                Property IncludeGuard { 
                    (($Me.Items[1..($Me.Items.Length - 1)] -join '_') + $Me.Extension.Replace('.', '_')).ToUpper() 
                }
                
            }

    $ProtoHeaderH = 
        $ProtoHeader | 
            Prototype ProtoHeaderH {
                OverrideProperty Suffix { '' }
                OverrideProperty Extension { '.h' }
            }

    $ProtoFunction = 
        $Prototype | 
            Prototype ProtoFunction

    $ProtoApiAt = 
        $ProtoFunction | 
            Prototype ProtoApiAt {
                Property ApiLabel { $Me.DependentHeaders[0] }
            }

    $ProtoApiLabel = 
        $ProtoFunction | 
            Prototype ProtoApiLabel

    $ProtoApiAtH = 
        $ProtoHeaderH, $ProtoApiAt | 
            Prototype ProtoApiAtH {
                OverrideProperty Template {
@"
#pragma once
#ifndef $($Me.IncludeGuard)
#define $($Me.IncludeGuard)

"@ + $(
$Me.DependentHeaders | % { @"

#ifndef $($_.IncludeGuard)
#include <$($_.FullNameAsPath)>
#endif

"@ }) + @"

namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Function) { namespace $($Me.FunctionDetail) { 
  
  namespace $($Me.Name)Detail {
      
      using namespace Urasandesu::CppAnonym::Traits;
      using $($Me.DependentHeaders[0].FullName)
      
      template<class ApiCartridgesHolder, class ApiLabel>
      struct $($Me.Name)Impl : 
          ApiAt<ApiCartridgesHolder, $($Me.DependentHeaders[0].Name), ApiLabel>
      {
      };
  
  }   // namespace $($Me.Name)Detail {
  
  template<class ApiCartridgesHolder, class ApiLabel>
  struct $($Me.Name) : 
      $($Me.Name)Detail::$($Me.Name)Impl<ApiCartridgesHolder, ApiLabel>
  {
  };
  
}}}}   // namespace $($Me.Namespaces[0]) { namespace $($Me.Namespaces[1]) { namespace $($Me.Function) { namespace $($Me.FunctionDetail) { 

#endif  // $($Me.IncludeGuard)

"@
                }
            }

    $ProtoApiLabelH = 
        $ProtoHeaderH, $ProtoApiLabel | 
            Prototype ProtoApiLabelH {
                OverrideProperty Template {
                }
            }

    # Act
    $hostInfoApiLabelH = $ProtoApiLabelH.New()
    $hostInfoApiLabelH.Items = 'C:\Users\Akira\Prig\Swathe\Urasandesu.Swathe', 'Urasandesu', 'Swathe', 'Hosting', 'ApiLabel', 'HostInfoApiLabel'

    $hostInfoApiAtH = $ProtoApiAtH.New()
    $hostInfoApiAtH.Items = 'C:\Users\Akira\Prig\Swathe\Urasandesu.Swathe', 'Urasandesu', 'Swathe', 'Hosting', 'ApiAt', 'HostInfoApiAt'
    $hostInfoApiAtH.DependentHeaders = @($hostInfoApiLabelH)

    # Assert
    Assert-AreEqual @"
#pragma once
#ifndef URASANDESU_SWATHE_HOSTING_APIAT_HOSTINFOAPIAT_H
#define URASANDESU_SWATHE_HOSTING_APIAT_HOSTINFOAPIAT_H

#ifndef URASANDESU_SWATHE_HOSTING_APILABEL_HOSTINFOAPILABEL_H
#include <Urasandesu/Swathe/Hosting/ApiLabel/HostInfoApiLabel.h>
#endif

namespace Urasandesu { namespace Swathe { namespace Hosting { namespace ApiAt { 
  
  namespace HostInfoApiAtDetail {
      
      using namespace Urasandesu::CppAnonym::Traits;
      using Urasandesu::Swathe::Hosting::ApiLabel::HostInfoApiLabel
      
      template<class ApiCartridgesHolder, class ApiLabel>
      struct HostInfoApiAtImpl : 
          ApiAt<ApiCartridgesHolder, HostInfoApiLabel, ApiLabel>
      {
      };
  
  }   // namespace HostInfoApiAtDetail {
  
  template<class ApiCartridgesHolder, class ApiLabel>
  struct HostInfoApiAt : 
      HostInfoApiAtDetail::HostInfoApiAtImpl<ApiCartridgesHolder, ApiLabel>
  {
  };
  
}}}}   // namespace Urasandesu { namespace Swathe { namespace Hosting { namespace ApiAt { 

#endif  // URASANDESU_SWATHE_HOSTING_APIAT_HOSTINFOAPIAT_H

"@ $hostInfoApiAtH.Template

}

