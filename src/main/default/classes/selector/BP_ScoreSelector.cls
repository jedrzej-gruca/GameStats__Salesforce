/**
 * Created by Jedrzej Gruca on 02/12/2023.
 */

public with sharing class BP_ScoreSelector extends fflib_SObjectSelector implements BP_IScoreSelector {

    public BP_ScoreSelector() {
        super();
    }

    public static BP_ScoreSelector newInstance() {
        return (BP_ScoreSelector) BP_Application.selector.newInstance(BP_Score__c.SObjectType);
    }

    public SObjectType getSObjectType() {
        return BP_Score__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                BP_Score__c.Id,
                BP_Score__c.Name,
                BP_Score__c.BP_GamePlay__c,
                BP_Score__c.BP_Player__c,
                BP_Score__c.BP_Value__c
        };
    }

    public List<BP_Score__c> selectById(Set<Id> ids) {
        return (List<BP_Score__c>)selectSObjectsById(ids);
    }

    public List<BP_Score__c> selectByGameplayId(Set<Id> ids) {
        final fflib_QueryFactory queryFactory = newQueryFactory()
                .setCondition('BP_GamePlay__c IN :ids')
                .setOrdering(BP_Score__c.BP_Value__c, fflib_QueryFactory.SortOrder.DESCENDING);
        return Database.query(String.escapeSingleQuotes(queryFactory.toSOQL()));
    }

    public interface BP_IScoreSelector {
        SObjectType getSObjectType();
        List<SObjectField> getSObjectFieldList();
        List<BP_Score__c> selectById(Set<Id> ids);
        List<BP_Score__c> selectByGameplayId(Set<Id> ids);
    }
}