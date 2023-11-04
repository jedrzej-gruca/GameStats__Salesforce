/**
 * Created by Jedrzej Gruca on 04/11/2023.
 */

public with sharing class BP_GameSelector extends fflib_SObjectSelector implements BP_IGameSelector {

    public BP_GameSelector() {
        super();
    }

    public static BP_GameSelector newInstance() {
        return (BP_GameSelector) BP_Application.selector.newInstance(BP_Game__c.SObjectType);
    }

    public SObjectType getSObjectType() {
        return BP_Game__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                BP_Game__c.Id,
                BP_Game__c.Name,
                BP_Game__c.BP_Type__c,
                BP_Game__c.BP_Category__c,
                BP_Game__c.BP_Mechanic__c,
                BP_Game__c.BP_RecommendedAge__c
        };
    }

    public List<BP_Game__c> selectById(Set<Id> ids) {
        return (List<BP_Game__c>)selectSObjectsById(ids);
    }

    public List<BP_Game__c> selectByIdAndHasExpansion(Set<Id> ids, Boolean hasExpansion) {
        final fflib_QueryFactory queryFactory = newQueryFactory()
                .selectField(BP_Game__c.BP_HasExpansion__c)
                .selectField(BP_Game__c.BP_IsExpansion__c)
                .setCondition('Id IN :ids AND BP_HasExpansion__c = :hasExpansion');
        return Database.query(String.escapeSingleQuotes(queryFactory.toSOQL()));
    }

    public interface BP_IGameSelector {
        SObjectType getSObjectType();
        List<SObjectField> getSObjectFieldList();
        List<BP_Game__c> selectById(Set<Id> ids);
        List<BP_Game__c> selectByIdAndHasExpansion(Set<Id> ids, Boolean hasExpansion);
    }
}