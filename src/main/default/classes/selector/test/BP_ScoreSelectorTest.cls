/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_ScoreSelectorTest {

    @TestSetup
    static void testSetup() {
        final BP_CollectionItem__c item = new BP_CollectionItem__c(
                Name = 'Game',
                BP_GameCondition__c = 'New'
        );
        insert item;

        final BP_Gameplay__c gameplay = new BP_Gameplay__c(
                Name = 'Gameplay',
                BP_Game__c = item.Id
        );
        insert gameplay;

        final BP_Score__c score = new BP_Score__c(
                BP_GamePlay__c = gameplay.Id,
                BP_Value__c = 10
        );
        insert score;
    }

    @IsTest
    private static void selectByIdTest() {
        Id scoreId = [SELECT Id FROM BP_Score__c].get(0).Id;

        Test.startTest();
        final List<BP_Score__c> scores = BP_ScoreSelector.newInstance().selectById(new Set<Id>{scoreId});
        Test.stopTest();

        Assert.areEqual(1, scores.size());
    }

    @IsTest
    private static void selectByGameplayIdTest() {
        Id gameplayId = [SELECT Id FROM BP_Gameplay__c].get(0).Id;

        Test.startTest();
        final List<BP_Score__c> scores = BP_ScoreSelector.newInstance().selectByGameplayId(new Set<Id>{gameplayId});
        Test.stopTest();

        Assert.areEqual(1, scores.size());
    }
}