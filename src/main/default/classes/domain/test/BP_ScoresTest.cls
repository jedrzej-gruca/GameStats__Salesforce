/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_ScoresTest {

    @IsTest
    private static void setNewWinnerOnRelatedGameplayTest() {
        final BP_Player__c fakeWinner = new BP_Player__c(
                Id = fflib_IDGenerator.generate(BP_Player__c.SObjectType)
        );
        final BP_Gameplay__c fakeGameplay = new BP_Gameplay__c(
                Id = fflib_IDGenerator.generate(BP_Gameplay__c.SObjectType)
        );
        final BP_Score__c fakeHigherScore = new BP_Score__c(
                Id = fflib_IDGenerator.generate(BP_Score__c.SObjectType),
                BP_Value__c = 20,
                BP_GamePlay__c = fakeGameplay.Id,
                BP_Player__c = fakeWinner.Id
        );

        final fflib_ApexMocks mocks = new fflib_ApexMocks();
        final BP_ScoreSelector selectorMock = (BP_ScoreSelector)mocks.mock(BP_ScoreSelector.class);
        final BP_GameplaySelector gameplaySelectorMock = (BP_GameplaySelector)mocks.mock(BP_GameplaySelector.class);
        final fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork)mocks.mock(fflib_ISObjectUnitOfWork.class);
        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(BP_Score__c.SObjectType);
        mocks.when(selectorMock.selectByGameplayId(new Set<Id>{fakeGameplay.Id}))
                .thenReturn(new List<BP_Score__c>{fakeHigherScore});
        mocks.when(gameplaySelectorMock.sObjectType()).thenReturn(BP_Gameplay__c.SObjectType);
        mocks.when(gameplaySelectorMock.selectById(new Set<Id>{fakeGameplay.Id}))
                .thenReturn(new List<BP_Gameplay__c>{fakeGameplay});
        mocks.stopStubbing();
        BP_Application.selector.setMock(selectorMock);
        BP_Application.selector.setMock(gameplaySelectorMock);
        BP_Application.unitOfWork.setMock(uowMock);

        fflib_ApexMocks.ApexMocksException mocksException;
        try {
            fflib_SObjectDomain.Test.Database.onInsert(
                    new List<BP_Score__c>{fakeHigherScore}
            );
            fflib_SObjectDomain.triggerHandler(BP_Scores.Constructor.class);

            ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1))
                    .registerDirty(fflib_Match.sObjectWith(new Map<SObjectField, Object>{
                            BP_Gameplay__c.BP_Winner__c => fakeWinner.Id
                    }));
        } catch (fflib_ApexMocks.ApexMocksException ex) {
            mocksException = ex;
        }

        Assert.isNull(mocksException);
    }
}