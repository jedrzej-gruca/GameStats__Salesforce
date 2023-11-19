/**
 * Created by Jedrzej Gruca on 19/11/2023.
 */

public with sharing class BP_CollectionItemController {

    /**
    * @description Method auto fills Collection Item record data
    * @param  collectionItemId new collection item id
    * @return Collection Item record
    */
    @AuraEnabled
    public static BP_CollectionItem__c upsertCollectionItem(Id collectionItemId) {
        if (collectionItemId == null) {
            return null;
        }
        BP_CollectionItem__c newItem = BP_CollectionItemSelector.newInstance().selectById(new Set<Id>{collectionItemId}).get(0);
        upsert newItem;
        return newItem;
    }
}