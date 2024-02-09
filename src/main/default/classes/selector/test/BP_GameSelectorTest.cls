/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_GameSelectorTest {

    @TestSetup
    static void testSetup() {
        final Account publisher = new Account(
                Name = 'Publisher'
        );
        insert publisher;

        final BP_Game__c game = new BP_Game__c(
                Name = 'Gra',
                BP_MaximumPlayersNumber__c = 4,
                BP_MinimumPlayersNumber__c = 1,
                BP_bggId__c = 1000,
                BP_HasExpansion__c = true,
                BP_IsExpansion__c = true,
                BP_Publisher__c = publisher.Id
        );
        insert game;
    }

    @IsTest
    private static void selectByIdTest() {
        Id gameId = [SELECT Id FROM BP_Game__c WHERE Name = 'Gra'].get(0).Id;

        Test.startTest();
        final List<BP_Game__c> games = BP_GameSelector.newInstance().selectById(new Set<Id>{gameId});
        Test.stopTest();

        Assert.areEqual(1, games.size());
    }

    @IsTest
    private static void selectByIdAndHasExpansionTest() {
        Id gameId = [SELECT Id FROM BP_Game__c WHERE Name = 'Gra'].get(0).Id;

        Test.startTest();
        final List<BP_Game__c> games = BP_GameSelector.newInstance().selectByIdAndHasExpansion(new Set<Id>{gameId}, true);
        Test.stopTest();

        Assert.areEqual(1, games.size());
    }

    @IsTest
    private static void selectByPublisherIdTest() {
        Id publisherId = [SELECT Id FROM Account WHERE Name = 'Publisher'].get(0).Id;

        Test.startTest();
        final List<BP_Game__c> games = BP_GameSelector.newInstance().selectByPublisherId(new Set<Id>{publisherId});
        Test.stopTest();

        Assert.areEqual(1, games.size());
    }
}