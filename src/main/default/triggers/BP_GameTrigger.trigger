/**
 * Created by Jedrzej Gruca on 02/11/2023.
 */

trigger BP_GameTrigger on BP_Game__c (before insert, before update, after insert, after update) {
    fflib_SObjectDomain.triggerHandler(BP_Games.class);
}