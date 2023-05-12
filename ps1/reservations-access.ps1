#set azure role assignement of "Reservations Adminisrator" to the A2b-Resource-reservations group. the object id is the id of the Azure ad group "A2B-Resource-Reservations"
# Ref: https://docs.microsoft.com/en-us/azure/cost-management-billing/reservations/view-reservations#grant-access-with-powershell
Connect-AzAccount -Tenant 0e38730c-f9b8-4d07-9f70-46b518bde035
New-AzRoleAssignment -Scope "/providers/Microsoft.Capacity" -PrincipalId "4306978c-0f96-4926-956d-bfa151223776" -RoleDefinitionName "Reservations Administrator"