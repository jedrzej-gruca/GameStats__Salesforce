/**
 * Created by Jedrzej Gruca on 09/02/2024.
 */

@IsTest
public with sharing class BP_GamesWithoutFflibMocksTest {

    @IsTest
    private static void setProperDescriptionTest() {
        final BP_Game__c fakeGame = new BP_Game__c(
                BP_Description__c = 'board  game',
                BP_bggId__c = 1,
                BP_MinimumPlayersNumber__c = 1,
                BP_MaximumPlayersNumber__c = 4
        );
        insert fakeGame;

        final BP_Game__c gameAfterInsert = [SELECT Id, BP_Description__c FROM BP_Game__c WHERE Id = :fakeGame.Id].get(0);

        Assert.areEqual('board game', gameAfterInsert.BP_Description__c);
    }

    @IsTest
    private static void setHasExpansionOnParentGameTest() {
        final BP_Game__c fakeGame = new BP_Game__c(
                BP_Description__c = 'Game',
                BP_bggId__c = 1,
                BP_MinimumPlayersNumber__c = 1,
                BP_MaximumPlayersNumber__c = 4
        );
        insert fakeGame;

        final BP_Game__c fakeExpansion = new BP_Game__c(
                BP_Description__c = 'Expansion',
                BP_bggId__c = 2,
                BP_MinimumPlayersNumber__c = 1,
                BP_MaximumPlayersNumber__c = 4
        );
        insert fakeExpansion;

        Test.startTest();
        fakeExpansion.BP_IsExpansion__c = true;
        fakeExpansion.BP_ExpansionFor__c = fakeGame.Id;
        update fakeExpansion;
        Test.stopTest();

        final BP_Game__c game = [SELECT BP_ExpansionFor__c FROM BP_Game__c WHERE Id = :fakeExpansion.Id].get(0);
        Assert.areEqual(fakeGame.Id, game.BP_ExpansionFor__c);
    }

    @IsTest
    private static void setNumberOfGamesOnPublisher() {
        final Account fakePublisher = new Account(
                Name = 'Publisher',
                BP_NumberOfGames__c = 0,
                BP_NumberOfExpansions__c = 0
        );
        insert fakePublisher;

        final BP_Game__c fakeGame = new BP_Game__c(
                BP_Description__c = 'Game',
                BP_bggId__c = 1,
                BP_MinimumPlayersNumber__c = 1,
                BP_MaximumPlayersNumber__c = 4
        );
        insert fakeGame;

        final BP_Game__c fakeExpansion = new BP_Game__c(
                BP_Description__c = 'Expansion',
                BP_bggId__c = 2,
                BP_MinimumPlayersNumber__c = 1,
                BP_MaximumPlayersNumber__c = 4
        );
        insert fakeExpansion;

        Test.startTest();
        List<BP_Game__c> toUpdate = new List<BP_Game__c>();
        fakeGame.BP_Publisher__c = fakePublisher.Id;
        toUpdate.add(fakeGame);
        fakeExpansion.BP_Publisher__c = fakePublisher.Id;
        fakeExpansion.BP_IsExpansion__c = true;
        fakeExpansion.BP_ExpansionFor__c = fakeGame.Id;
        toUpdate.add(fakeExpansion);
        update toUpdate;
        Test.stopTest();

        final Account publisher = [SELECT BP_NumberOfGames__c, BP_NumberOfExpansions__c FROM Account WHERE Id = :fakePublisher.Id].get(0);
        Assert.areEqual(1, publisher.BP_NumberOfGames__c);
        Assert.areEqual(1, publisher.BP_NumberOfExpansions__c);
    }
}