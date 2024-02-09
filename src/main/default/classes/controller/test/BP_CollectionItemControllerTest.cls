/**
 * Created by Jedrzej Gruca on 04/02/2024.
 */

@IsTest
public with sharing class BP_CollectionItemControllerTest {

    @IsTest
    static void upsertCollectionItemTest() {

        final BP_CollectionItem__c item = new BP_CollectionItem__c(
                BP_GameCondition__c = 'new',
                Name = 'Fake Item'
        );
        insert item;

        final BP_CollectionItem__c retrievedItem = new BP_CollectionItem__c(
                Id = item.Id,
                BP_GameCondition__c = 'Used',
                Name = item.Name
        );

        final fflib_ApexMocks mocks = new fflib_ApexMocks();
        final BP_CollectionItemSelector selectorMock = (BP_CollectionItemSelector) mocks.mock(BP_CollectionItemSelector.class);
        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(BP_CollectionItem__c.SObjectType);
        mocks.when(selectorMock.selectById(new Set<Id>{item.Id})).thenReturn(new List<BP_CollectionItem__c>{retrievedItem});
        mocks.stopStubbing();
        BP_Application.selector.setMock(selectorMock);

        Test.startTest();
        BP_CollectionItem__c newItem = BP_CollectionItemController.upsertCollectionItem(item.Id);
        Test.stopTest();

        Assert.areEqual(item.Id, newItem.Id);
    }
}