/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_AccountSelectorTest {

    @TestSetup
    static void testSetup() {
        final Account fakeAccount = new Account(
                Name = 'Fake',
                BP_NumberOfGames__c = 1,
                BP_NumberOfExpansions__c = 1,
                Location__Latitude__s = 50,
                Location__Longitude__s = 50
        );
        insert fakeAccount;
    }

    @IsTest
    private static void selectByIdTest() {
        final Id accId = [SELECT Id FROM Account WHERE Name = 'Fake'].get(0).Id;

        Test.startTest();
        final List<Account> accounts = BP_AccountSelector.newInstance().selectById(new Set<Id>{accId});
        Test.stopTest();

        Assert.areEqual(1, accounts.size());
    }

    @IsTest
    private static void selectByIdWithAdditionalFieldsTest() {
        final Id accId = [SELECT Id FROM Account WHERE Name = 'Fake'].get(0).Id;

        Test.startTest();
        final List<Account> accounts = BP_AccountSelector.newInstance().selectByIdWithAdditionalFields(new Set<Id>{accId});
        Test.stopTest();

        Assert.areEqual(1, accounts.size());
    }
}