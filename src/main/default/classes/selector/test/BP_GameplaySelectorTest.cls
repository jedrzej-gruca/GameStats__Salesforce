/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_GameplaySelectorTest {

    @IsTest
    private static void selectByIdTest() {
        final BP_CollectionItem__c item = new BP_CollectionItem__c(
                Name = 'Gra',
                BP_GameCondition__c = 'New'
        );
        insert item;

        final BP_Gameplay__c gameplay = new BP_Gameplay__c(
                Name = 'Rozgrywka',
                BP_Game__c = item.Id
        );
        insert gameplay;

        Test.startTest();
        final List<BP_Gameplay__c> gameplays = BP_GameplaySelector.newInstance().selectById(new Set<Id>{gameplay.Id});
        Test.stopTest();

        Assert.areEqual(1, gameplays.size());
    }
}