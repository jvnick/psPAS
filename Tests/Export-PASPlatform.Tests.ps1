#Get Current Directory
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path

#Get Function Name
$FunctionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -Replace ".Tests.ps1"

#Assume ModuleName from Repository Root folder
$ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

#Resolve Path to Module Directory
$ModulePath = Resolve-Path "$Here\..\$ModuleName"

#Define Path to Module Manifest
$ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

if ( -not (Get-Module -Name $ModuleName -All)) {

	Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

}

BeforeAll {

	$Script:RequestBody = $null
	$Script:BaseURI = "https://SomeURL/SomeApp"
	$Script:ExternalVersion = "0.0"
	$Script:WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

}

AfterAll {

	$Script:RequestBody = $null

}

Describe $FunctionName {

	InModuleScope $ModuleName {

		Mock Invoke-PASRestMethod -MockWith {

			New-Object Byte[] 512

		}

		Context "Mandatory Parameters" {

			$Parameters = @{Parameter = 'PlatformID' },
			@{Parameter = 'path' }

			It "specifies parameter <Parameter> as mandatory" -TestCases $Parameters {

				param($Parameter)

				(Get-Command Export-PASPlatform).Parameters["$Parameter"].Attributes.Mandatory | Should Be $true

			}

		}

		$response = Export-PASPlatform -PlatformID SomePlatform -path "$env:Temp\testExport.zip"

		Context "Input" {

			It "throws if path is invalid" {
				{ Export-PASPlatform -PlatformID SomePlatform -path A:\test.txt } | Should throw
			}

			It "throws if InputFile resolves to a folder" {
				{ Export-PASPlatform -PlatformID SomePlatform -path $pwd } | Should throw
			}

			It "throws if InputFile does not have a zip extention" {
				{ Export-PASPlatform -PlatformID SomePlatform -path README.MD } | Should throw
			}

			It "sends request" {

				Assert-MockCalled Invoke-PASRestMethod -Scope Describe -Times 1 -Exactly

			}

			It "sends request to expected endpoint" {

				Assert-MockCalled Invoke-PASRestMethod -ParameterFilter {

					$URI -eq "$($Script:BaseURI)/API/Platforms/SomePlatform/Export?platformID=SomePlatform"

				} -Times 1 -Exactly -Scope Describe

			}

			It "uses expected method" {

				Assert-MockCalled Invoke-PASRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope Describe

			}

			It "throws error if version requirement not met" {
$Script:ExternalVersion = "1.0"
				{ Export-PASPlatform -PlatformID SomePlatform -path "$env:Temp\testExport.zip"  } | Should Throw
$Script:ExternalVersion = "0.0"
			}


		}

		Context "Output" {

			it "saves output file" {

				Test-Path "$env:Temp\testExport.zip" | should Be $true

			}

			it "reports error saving outputfile" {
				Mock Set-Content -MockWith { throw something }
				{ Export-PASPlatform -PlatformID SomePlatform -path "$env:Temp\testExport.zip" } | should throw "Error Saving $env:Temp\testExport.zip"
			}



		}

	}

}