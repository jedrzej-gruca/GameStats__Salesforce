/**
 * Created by drzeju on 04/02/2024.
 */

@IsTest
public with sharing class BP_AccountTest {

    @IsTest
    static void setProperDescriptionTest() {
        Account fakeAccount = new Account(
                Id = fflib_IDGenerator.generate(Account.SObjectType),
                BillingCountry = 'Poland',
                BillingLatitude = 1000,
                BillingLongitude = 1000
        );

        Account afterUpdateAccount = new Account(
                Id = fakeAccount.Id,
                BillingCountry = 'Slovakia',
                BillingLatitude = fakeAccount.BillingLatitude,
                BillingLongitude = fakeAccount.BillingLongitude
        );

        fflib_ApexMocks.ApexMocksException mocksException;
        try {
            fflib_SObjectDomain.Test.Database.onUpdate(
                    new List<Account> {afterUpdateAccount},
                    new Map<Id, Account>{fakeAccount.Id => fakeAccount}
            );
            fflib_SObjectDomain.triggerHandler(BP_Accounts.Constructor.class);
        } catch (fflib_ApexMocks.ApexMocksException ex) {
            mocksException = ex;
        }
        Assert.isNull(mocksException);
        Assert.areEqual(1000, afterUpdateAccount.Location__Latitude__s);
    }
}