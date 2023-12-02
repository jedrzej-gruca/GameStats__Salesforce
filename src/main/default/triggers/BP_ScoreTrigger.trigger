/**
 * Created by drzeju on 02/12/2023.
 */

trigger BP_ScoreTrigger on BP_Score__c (after insert) {
    fflib_SObjectDomain.triggerHandler(BP_Scores.class);
}