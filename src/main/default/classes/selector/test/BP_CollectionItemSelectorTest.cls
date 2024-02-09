/**
 * Created by Jedrzej Gruca on 08/02/2024.
 */

@IsTest
public with sharing class BP_CollectionItemSelectorTest {

    @IsTest
    private static void selectById() {
        final BP_CollectionItem__c item = new BP_CollectionItem__c(
                Name = 'Gra',
                BP_GameCondition__c = 'New'
        );
        insert item;

        Test.startTest();
        final List<BP_CollectionItem__c> items = BP_CollectionItemSelector.newInstance().selectById(new Set<Id>{item.Id});
        Test.stopTest();

        Assert.areEqual(1, items.size());
    }
}