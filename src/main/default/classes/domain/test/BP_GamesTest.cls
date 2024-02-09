/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_GamesTest {

    @IsTest
    private static void setProperDescriptionTest() {
        final BP_Game__c fakeGame = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType),
                BP_Description__c = 'board  game'
        );

        fflib_SObjectDomain.Test.Database.onInsert(new List<BP_Game__c>{fakeGame});
        fflib_SObjectDomain.triggerHandler(BP_Games.Constructor.class);

        Assert.areEqual('board game', fakeGame.BP_Description__c);
    }

    @IsTest
    private static void setHasExpansionOnParentGameTest() {
        final BP_Game__c fakeGame = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType)
        );

        final BP_Game__c fakeExpansion = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType)
        );

        final BP_Game__c fakeExpansionAfterUpdate = new BP_Game__c(
                Id = fakeExpansion.Id,
                BP_IsExpansion__c = true,
                BP_ExpansionFor__c = fakeGame.Id
        );

        final fflib_ApexMocks mocks = new fflib_ApexMocks();
        final BP_GameSelector selectorMock = (BP_GameSelector)mocks.mock(BP_GameSelector.class);
        final fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);
        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(BP_Game__c.SObjectType);
        mocks.when(selectorMock.selectByIdAndHasExpansion(new Set<Id>{fakeGame.Id}, false))
                .thenReturn(new List<BP_Game__c>{fakeGame});
        mocks.stopStubbing();
        BP_Application.selector.setMock(selectorMock);
        BP_Application.unitOfWork.setMock(uowMock);

        fflib_ApexMocks.ApexMocksException mocksException;
        try {
            fflib_SObjectDomain.Test.Database.onUpdate(
                    new List<BP_Game__c>{fakeExpansionAfterUpdate},
                    new Map<Id, BP_Game__c>{fakeExpansion.Id => fakeExpansion}
            );
            fflib_SObjectDomain.triggerHandler(BP_Games.Constructor.class);

            ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1))
                    .registerDirty(fflib_Match.sObjectWith(new Map<SObjectField, Object>{
                            BP_Game__c.BP_HasExpansion__c => true
                    }));
        } catch (fflib_ApexMocks.ApexMocksException ex) {
            mocksException = ex;
        }

        Assert.isNull(mocksException);
    }

    @IsTest
    private static void setNumberOfGamesOnPublisher() {
        final Account fakePublisher = new Account(
                Id = fflib_IDGenerator.generate(Account.SObjectType),
                BP_NumberOfGames__c = 0,
                BP_NumberOfExpansions__c = 0
        );

        final BP_Game__c fakeGame = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType)
        );

        final BP_Game__c fakeGameAfter = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType),
                BP_Publisher__c = fakePublisher.Id
        );

        final BP_Game__c fakeExpansion = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType),
                BP_IsExpansion__c = true
        );

        final BP_Game__c fakeExpansionAfter = new BP_Game__c(
                Id = fflib_IDGenerator.generate(BP_Game__c.SObjectType),
                BP_Publisher__c = fakePublisher.Id,
                BP_IsExpansion__c = true
        );

        final fflib_ApexMocks mocks = new fflib_ApexMocks();
        final BP_AccountSelector selectorMock = (BP_AccountSelector)mocks.mock(BP_AccountSelector.class);
        final BP_GameSelector gameSelectorMock = (BP_GameSelector)mocks.mock(BP_GameSelector.class);
        final fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);
        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.selectById(new Set<Id>{fakePublisher.Id}))
                .thenReturn(new List<Account>{fakePublisher});
        mocks.when(gameSelectorMock.sObjectType()).thenReturn(BP_Game__c.SObjectType);
        mocks.when(gameSelectorMock.selectByPublisherId(new Set<Id>{fakePublisher.Id}))
                .thenReturn(new List<BP_Game__c>{fakeGameAfter, fakeExpansionAfter});
        mocks.stopStubbing();
        BP_Application.selector.setMock(selectorMock);
        BP_Application.selector.setMock(gameSelectorMock);
        BP_Application.unitOfWork.setMock(uowMock);

        fflib_ApexMocks.ApexMocksException mocksException;
        try {
            fflib_SObjectDomain.Test.Database.onUpdate(
                    new List<BP_Game__c>{fakeGameAfter, fakeExpansionAfter},
                    new Map<Id, BP_Game__c>{
                            fakeGame.Id => fakeGame,
                            fakeExpansion.Id => fakeExpansion
                    }
            );
            fflib_SObjectDomain.triggerHandler(BP_Games.Constructor.class);

            ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 2))
                    .registerDirty(fflib_Match.sObjectWith(new Map<SObjectField, Object>{
                            Account.BP_NumberOfGames__c => 1,
                            Account.BP_NumberOfExpansions__c => 1
                    }));
        } catch (fflib_ApexMocks.ApexMocksException ex) {
            mocksException = ex;
        }

        Assert.isNull(mocksException);
    }
}