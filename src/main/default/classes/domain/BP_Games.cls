/**
 * Created by Jedrzej Gruca on 02/11/2023.
 */

public with sharing class BP_Games extends fflib_SObjectDomain {

    //TODO: DUPLICATE CHECK FOR GAME RECORDS

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

    public override void onAfterInsert() {

    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        setHasExpansionOnParentGame();
    }

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
                game.BP_Description__c = game.BP_Description__c.replace('&nbsp;', ' ');
                game.BP_Description__c = game.BP_Description__c.replace('  ', ' ');
            }
        }
    }

    private void setHasExpansionOnParentGame() {
        final List<BP_Game__c> expansions = getChangedRecords(new Set<SObjectField>{BP_Game__c.BP_IsExpansion__c});
        final Set<Id> parentGamesIds = new Set<Id>();
        for (BP_Game__c exp : expansions) {
            if (exp.BP_IsExpansion__c && exp.BP_ExpansionFor__c != null) {
                parentGamesIds.add(exp.BP_ExpansionFor__c);
            }
        }
        if (parentGamesIds.isEmpty()) {
            return;
        }
        final List<BP_Game__c> parentGames = new List<BP_Game__c>(BP_GameSelector.newInstance().selectByIdAndHasExpansion(parentGamesIds, false));
        if (parentGames.isEmpty()) {
            return;
        }
        final fflib_ISObjectUnitOfWork uow = BP_Application.unitOfWork.newInstance(new List<SObjectType>{BP_Game__c.SObjectType});
        for (BP_Game__c game : parentGames) {
            if (!game.BP_IsExpansion__c) {
                game.BP_HasExpansion__c = true;
                uow.registerDirty(game);
            }

        }
        uow.commitWork();
    }
}