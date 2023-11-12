/**
 * Created by drzeju on 12/11/2023.
 */

trigger BP_AccountTrigger on Account (before insert, before update) {
    fflib_SObjectDomain.triggerHandler(BP_Accounts.class);
}