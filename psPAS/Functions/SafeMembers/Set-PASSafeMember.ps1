function Set-PASSafeMember {
	<#
.SYNOPSIS
Updates a Safe Member

.DESCRIPTION
Updates an existing Safe Member's permissions on a safe.
Manage Safe Members permission is required.

.PARAMETER SafeName
The name of the safe to which the safe member belong

.PARAMETER MemberName
Vault or Domain User, or Group, safe member to update.

.PARAMETER MembershipExpirationDate
Defines when the member's Safe membership expires.

.PARAMETER UseAccounts
Boolean value defining if UseAccounts permission will be granted to
safe member on safe.

.PARAMETER RetrieveAccounts
Boolean value defining if RetrieveAccounts permission will be granted
to safe member on safe.

.PARAMETER ListAccounts
Boolean value defining if ListAccounts permission will be granted to
safe member on safe.

.PARAMETER AddAccounts
Boolean value defining if permission will be granted to safe member
on safe.
Includes UpdateAccountProperties (when adding or removing permission).

.PARAMETER UpdateAccountContent
Boolean value defining if AddAccounts permission will be granted to safe
member on safe.

.PARAMETER UpdateAccountProperties
Boolean value defining if UpdateAccountProperties permission will be granted
to safe member on safe.

.PARAMETER InitiateCPMAccountManagementOperations
Boolean value defining if InitiateCPMAccountManagementOperations permission
will be granted to safe member on safe.

.PARAMETER SpecifyNextAccountContent
Boolean value defining if SpecifyNextAccountContent permission will be granted
to safe member on safe.

.PARAMETER RenameAccounts
Boolean value defining if RenameAccounts permission will be granted to safe
member on safe.

.PARAMETER DeleteAccounts
Boolean value defining if DeleteAccounts permission will be granted to safe
member on safe.

.PARAMETER UnlockAccounts
Boolean value defining if UnlockAccounts permission will be granted to safe
member on safe.

.PARAMETER ManageSafe
Boolean value defining if ManageSafe permission will be granted to safe member
on safe.

.PARAMETER ManageSafeMembers
Boolean value defining if ManageSafeMembers permission will be granted to safe
member on safe.

.PARAMETER BackupSafe
Boolean value defining if BackupSafe permission will be granted to safe member
on safe.

.PARAMETER ViewAuditLog
Boolean value defining if ViewAuditLog permission will be granted to safe member
on safe.

.PARAMETER ViewSafeMembers
Boolean value defining if ViewSafeMembers permission will be granted to safe member
on safe.

.PARAMETER RequestsAuthorizationLevel
Integer value defining level assigned to RequestsAuthorizationLevel for safe member.
Valid Values: 0, 1 or 2

.PARAMETER AccessWithoutConfirmation
Boolean value defining if AccessWithoutConfirmation permission will be granted to
safe member on safe.

.PARAMETER CreateFolders
Boolean value defining if CreateFolders permission will be granted to safe member
on safe.

.PARAMETER DeleteFolders
Boolean value defining if DeleteFolders permission will be granted to safe member
on safe.

.PARAMETER MoveAccountsAndFolders
Boolean value defining if MoveAccountsAndFolders permission will be granted to safe
member on safe.

.EXAMPLE
Set-PASSafeMember -SafeName TargetSafe -MemberName TargetUser -AddAccounts $true

Updates TargetUser's permissions as safe member on TargetSafe to include "Add Accounts"

.LINK
https://pspas.pspete.dev/commands/Set-PASSafeMember
#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[string]$SafeName,

		[Alias("UserName")]
		[parameter(
			Mandatory = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[string]$MemberName,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[datetime]$MembershipExpirationDate,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$UseAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$RetrieveAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$ListAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$AddAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$UpdateAccountContent,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$UpdateAccountProperties,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = "CPM"
		)]
		[boolean]$InitiateCPMAccountManagementOperations,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = "CPM"
		)]
		[boolean]$SpecifyNextAccountContent,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$RenameAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$DeleteAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$UnlockAccounts,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$ManageSafe,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$ManageSafeMembers,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$BackupSafe,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$ViewAuditLog,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$ViewSafeMembers,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateRange(0, 2)]
		[int]$RequestsAuthorizationLevel,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$AccessWithoutConfirmation,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$CreateFolders,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$DeleteFolders,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[boolean]$MoveAccountsAndFolders
	)

	BEGIN {

		#array for parameter names which appear in the top-tier of the JSON object
		$keysToKeep = [Collections.Generic.List[String]]@(
			'MembershipExpirationDate', 'Permissions'
		)

	}#begin

	PROCESS {

		#Create URL for request
		$URI = "$Script:BaseURI/WebServices/PIMServices.svc/Safes/$($SafeName |

            Get-EscapedString)/Members/$($MemberName | Get-EscapedString)"

		#Get passed parameters to include in request body
		$boundParameters = $PSBoundParameters | Get-PASParameter

		If ($PSBoundParameters.ContainsKey("MembershipExpirationDate")) {

			#Convert ExpiryDate to string in Required format
			$Date = (Get-Date $MembershipExpirationDate -Format MM/dd/yyyy).ToString()

			#Include date string in request
			$boundParameters["MembershipExpirationDate"] = $Date

		}

		#Add permissions array to request in correct order
		[array]$boundParameters["Permissions"] = $boundParameters | ConvertTo-SortedPermission

		#Create JSON for body of request
		$body = @{

			"member" = $boundParameters | Get-PASParameter -ParametersToKeep $keysToKeep

			#Ensure all levels of object are output
		} | ConvertTo-Json -Depth 3

		if ($PSCmdlet.ShouldProcess($SafeName, "Update Safe Permissions for '$MemberName'")) {

			#Send request to webservice
			$result = Invoke-PASRestMethod -Uri $URI -Method PUT -Body $Body -WebSession $Script:WebSession

			If ($null -ne $result) {

				#format output
				$result.member | Select-Object MembershipExpirationDate,

				@{Name = "Permissions"; "Expression" = {

						$result.member.permissions | ConvertFrom-KeyValuePair }

				} | Add-ObjectDetail -typename psPAS.CyberArk.Vault.Safe.Member -PropertyToAdd @{

					"UserName" = $MemberName
					"SafeName" = $SafeName

				}

			}

		}

	}#process

	END { }#end

}