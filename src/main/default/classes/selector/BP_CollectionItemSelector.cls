/**
 * Created by Jedrzej Gruca on 19/11/2023.
 */

public with sharing class BP_CollectionItemSelector extends fflib_SObjectSelector implements BP_ICollectionItemSelector {

    public BP_CollectionItemSelector() {
        super();
    }

    public static BP_CollectionItemSelector newInstance() {
        return (BP_CollectionItemSelector) BP_Application.selector.newInstance(BP_CollectionItem__c.SObjectType);
    }

    public SObjectType getSObjectType() {
        return BP_CollectionItem__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                BP_CollectionItem__c.Id,
                BP_CollectionItem__c.Name,
                BP_CollectionItem__c.BP_Game__c,
                BP_CollectionItem__c.BP_GameCondition__c,
                BP_CollectionItem__c.BP_ConditionDetails__c,
                BP_CollectionItem__c.BP_Owner__c,
                BP_CollectionItem__c.BP_PurchaseDate__c
        };
    }

    public List<BP_CollectionItem__c> selectById(Set<Id> ids) {
        return (List<BP_CollectionItem__c>)selectSObjectsById(ids);
    }

    public interface BP_ICollectionItemSelector {
        SObjectType getSObjectType();
        List<SObjectField> getSObjectFieldList();
        List<BP_CollectionItem__c> selectById(Set<Id> ids);
    }
}