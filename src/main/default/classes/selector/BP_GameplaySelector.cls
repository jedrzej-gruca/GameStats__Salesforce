/**
 * Created by Jedrzej Gruca on 02/12/2023.
 */

public with sharing class BP_GameplaySelector extends fflib_SObjectSelector implements BP_IGameplaySelector {

    public BP_GameplaySelector() {
        super();
    }

    public static BP_GameplaySelector newInstance() {
        return (BP_GameplaySelector) BP_Application.selector.newInstance(BP_Gameplay__c.SObjectType);
    }

    public SObjectType getSObjectType() {
        return BP_Gameplay__c.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                BP_Gameplay__c.Id,
                BP_Gameplay__c.Name,
                BP_Gameplay__c.BP_Game__c,
                BP_Gameplay__c.BP_PlayDate__c,
                BP_Gameplay__c.BP_Winner__c
        };
    }

    public List<BP_Gameplay__c> selectById(Set<Id> ids) {
        return (List<BP_Gameplay__c>)selectSObjectsById(ids);
    }

    public interface BP_IGameplaySelector {
        SObjectType getSObjectType();
        List<SObjectField> getSObjectFieldList();
        List<BP_Gameplay__c> selectById(Set<Id> ids);
    }
}