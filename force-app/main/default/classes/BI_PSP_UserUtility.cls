/**
 * @description This BI_PSP_UserUtility class used to update the Username.
 * History:
 * Version  Author          Date            Detail              Description
 * 1.0      Ashif           20-8-2024       Created             Initial development
 */
public without sharing class BI_PSP_UserUtility {

    /**
    * @description Asynchronously updates the `Username` field of `User` records to match the new email addresses 
    * from the provided map. This method is intended to be used in scenarios where account email addresses 
    * have been updated, and corresponding `User` records need their `Username` field synchronized.
    * @param accountEmailMap A map where the key is the Account ID and the value is the new email address.
    *                        The method uses this map to update the `Username` of `User` records 
    *                        associated with the given Account IDs.
    */
    @future
    public static void updateUserEmailsAndUsernames(Map<Id, String> accountEmailMap) {
        // Define the fields to query
        String fields = 'Id, Email, Username, AccountId, IsActive,BI_PSPB_UserNameModified__c';

        // Prepare a list of Account IDs to filter
        List<String> accountIdsList = new List<String>();
        for (Id accountId : accountEmailMap.keySet()) {
            accountIdsList.add(accountId);
        }
        String accountIdsString = '\'' + String.join(accountIdsList, '\',\'') + '\'';

        // Build the query conditions for User records
        String conditions = 'AccountId IN (' + accountIdsString + ')';
        Boolean withSharingKeyword = Boolean.valueOf(BI_PSPB_EnrollmentConstant.getLabel('USER_MODE_TRUE')); 

        // Execute the query using the common utility method
        List<SObject> userSObjects = BI_PSP_CommonQueryUtility.executeQuery('User', fields, conditions, withSharingKeyword);

        // Separate lists for different operations
        List<User> usersToDeactivate = new List<User>();
        List<User> usersToUpdate = new List<User>();
        List<User> usersToActivate = new List<User>();
        
        for (SObject sObj : userSObjects) {
            User user = (User) sObj;
            String newEmail = accountEmailMap.get(user.AccountId);
            
            if (newEmail != null) { // Check for null to avoid setting Username to null
                
                userDeactivate(usersToDeactivate,user.IsActive);

                // Prepare user to update the Username
                User userToUpdate = new User(Id = user.Id, Username = newEmail);
                usersToUpdate.add(userToUpdate);
                
                // Reactivate user after updating Username
                User userToActivate = new User(Id = user.Id,IsActive = true,BI_PSPB_UserNameModified__c = true);
                usersToActivate.add(userToActivate);
            }
        }
        
        try {
            // Perform the deactivation
            if (!usersToDeactivate.isEmpty()) {
                BI_PSP_DatabaseOperationsUtility.updateOperation(usersToDeactivate, BI_PSP_UserUtility.class.getName(), Boolean.valueOf(BI_PSPB_EnrollmentConstant.getLabel('USER_MODE_FALSE')) );
            }
            
            // Perform the Username update
            if (!usersToUpdate.isEmpty()) {
                BI_PSP_DatabaseOperationsUtility.updateOperation(
                    usersToUpdate, 
                    BI_PSP_UserUtility.class.getName(), 
                    Boolean.valueOf(BI_PSPB_EnrollmentConstant.getLabel('USER_MODE_FALSE'))
                );
            }

            // Perform the activation
            if (!usersToActivate.isEmpty()) {
                BI_PSP_DatabaseOperationsUtility.updateOperation(
                    usersToActivate, 
                    BI_PSP_UserUtility.class.getName(), 
                    Boolean.valueOf(BI_PSPB_EnrollmentConstant.getLabel('USER_MODE_FALSE'))
                );
            }

        } catch (DmlException ex) {
            // Log the exception message
            BI_PSP_LogMessagesUtility.exceptionLogMessage(ex.getMessage(),BI_PSP_UserUtility.class.getName(),ex); 
        }
    }
/**
 * @description
 * This private helper method checks if a user is currently active and prepares a User instance 
 * with the `IsActive` field set to false. The updated user instance is added to the `usersToDeactivate` list
 * for deactivation in a bulk DML operation.
 * @param usersToDeactivate List<User> - A list to store users that need to be deactivated.
 * @param isActive Boolean - A flag indicating whether the user is currently active.
 */
private static void userDeactivate(List<User> usersToDeactivate, Boolean isActive)
{
    for (User user : usersToDeactivate) {
        if (user.IsActive == isActive) {
            // Deactivate the user
            User userToDeactivate = new User(Id = user.Id, IsActive = false);
            usersToDeactivate.add(userToDeactivate);
        }
    }
}

}