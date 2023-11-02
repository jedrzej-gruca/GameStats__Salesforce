/**
 * Created by Jedrzej Gruca on 02/11/2023.
 */

public with sharing class BP_Games extends fflib_SObjectDomain {

    public BP_Games(List<BP_Game__c> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_sObjectDomain.IConstructable {
         public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new BP_Games(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        setProperDescription();
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {}

    private void setProperDescription() {
        for (BP_Game__c game : (List<BP_Game__c>)Records) {
            if (game.BP_Description__c != null) {
                game.BP_Description__c = game.BP_Description__c.replace('<br/><br/>', ' ');
                game.BP_Description__c = game.BP_Description__c.replace('&quot;', '"');
                game.BP_Description__c = game.BP_Description__c.replace('<br/>', ' ');
                game.BP_Description__c = game.BP_Description__c.replace('&mdash;', '');
                game.BP_Description__c = game.BP_Description__c.replace('<a target=\'_blank\' href="', '');
                game.BP_Description__c = game.BP_Description__c.replace('" rel="nofollow noreferrer noopener">', '');
                game.BP_Description__c = game.BP_Description__c.replace('</a>', '');
                game.BP_Description__c = game.BP_Description__c.replace('&rsquo;', '\'');
                game.BP_Description__c = game.BP_Description__c.replace('&ndash;', '-');
                game.BP_Description__c = game.BP_Description__c.replace('&times;', '*');
                game.BP_Description__c = game.BP_Description__c.replace('&amp;', '&');
                game.BP_Description__c = game.BP_Description__c.replace('  ', ' ');
            }
        }
    }
}