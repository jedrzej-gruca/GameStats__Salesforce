/**
 * Created by Jedrzej Gruca on 02/11/2023.
 */

public with sharing class BP_Games extends fflib_SObjectDomain {

    final public static String BASE_GAME_STATUS = 'BASE';
    final public static String EXPANSION_GAME_STATUS = 'EXPANSION';

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
        setNumberOfGamesOnPublisher(null);
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        setHasExpansionOnParentGame();
        setNumberOfGamesOnPublisher((Map<Id, BP_Game__c>)existingRecords);
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

    /**
    * @description checks if publisher number of games or expansions has changed
    * @param publishers publisher Accounts
    * @return Map with base or expansion game status key (BASE, EXPANSION), and Account Id to new number of games Map value
    */
    private Map<String, Map<Id, Integer>> checkIfNumberOfGamesHasChanged(List<Account> publishers) {
        if (publishers.isEmpty()) {
            return null;
        }
        final Map<Id, Account> publisherMap = new Map<Id, Account>(publishers);
        final List<BP_Game__c> gamesWithPublisher = new List<BP_Game__c>(BP_GameSelector.newInstance().selectByPublisherId(publisherMap.keySet()));
        if (gamesWithPublisher.isEmpty()) {
            return null;
        }
        final Map<Id, Map<String, List<BP_Game__c>>> publisherIdToGameListMap = new Map<Id, Map<String, List<BP_Game__c>>>();
        final Map<String, Map<Id, Integer>> publishersIdsToUpdateMap = new Map<String, Map<Id, Integer>>();
        for (BP_Game__c game : gamesWithPublisher) {
            if (game.BP_IsExpansion__c) {
                if (publisherIdToGameListMap.containsKey(game.BP_Publisher__c)) {
                    if (publisherIdToGameListMap.get(game.BP_Publisher__c).containsKey(EXPANSION_GAME_STATUS)) {
                        publisherIdToGameListMap.get(game.BP_Publisher__c).get(EXPANSION_GAME_STATUS).add(game);
                    } else {
                        publisherIdToGameListMap.get(game.BP_Publisher__c).put(EXPANSION_GAME_STATUS, new List<BP_Game__c>{game});
                    }
                } else {
                    publisherIdToGameListMap.put(game.BP_Publisher__c, new Map<String, List<BP_Game__c>>{EXPANSION_GAME_STATUS => new List<BP_Game__c>{game}});
                }
            } else {
                if (publisherIdToGameListMap.containsKey(game.BP_Publisher__c)) {
                    if (publisherIdToGameListMap.get(game.BP_Publisher__c).containsKey(BASE_GAME_STATUS)) {
                        publisherIdToGameListMap.get(game.BP_Publisher__c).get(BASE_GAME_STATUS).add(game);
                    } else {
                        publisherIdToGameListMap.get(game.BP_Publisher__c).put(BASE_GAME_STATUS, new List<BP_Game__c>{game});
                    }
                } else {
                    publisherIdToGameListMap.put(game.BP_Publisher__c, new Map<String, List<BP_Game__c>>{BASE_GAME_STATUS => new List<BP_Game__c>{game}});
                }
            }
        }
        for (Id publisherId : publisherIdToGameListMap.keySet()) {
            if (publisherIdToGameListMap.get(publisherId).containsKey(BASE_GAME_STATUS) &&
                    publisherMap.get(publisherId).BP_NumberOfGames__c != publisherIdToGameListMap.get(publisherId).get(BASE_GAME_STATUS).size()) {
                if (publishersIdsToUpdateMap.containsKey(BASE_GAME_STATUS)) {
                    publishersIdsToUpdateMap.get(BASE_GAME_STATUS).put(publisherId, publisherIdToGameListMap.get(publisherId).get(BASE_GAME_STATUS).size());
                } else {
                    publishersIdsToUpdateMap.put(BASE_GAME_STATUS, new Map<Id, Integer>{publisherId => publisherIdToGameListMap.get(publisherId).get(BASE_GAME_STATUS).size()});
                }
            } else if (publisherIdToGameListMap.get(publisherId).containsKey(EXPANSION_GAME_STATUS) &&
                    publisherMap.get(publisherId).BP_NumberOfExpansions__c != publisherIdToGameListMap.get(publisherId).get(EXPANSION_GAME_STATUS).size()) {
                if (publishersIdsToUpdateMap.containsKey(EXPANSION_GAME_STATUS)) {
                    publishersIdsToUpdateMap.get(EXPANSION_GAME_STATUS).put(publisherId, publisherIdToGameListMap.get(publisherId).get(EXPANSION_GAME_STATUS).size());
                } else {
                    publishersIdsToUpdateMap.put(EXPANSION_GAME_STATUS, new Map<Id, Integer>{publisherId => publisherIdToGameListMap.get(publisherId).get(EXPANSION_GAME_STATUS).size()});
                }
            }
        }
        return publishersIdsToUpdateMap;
    }

    private void setNumberOfGamesOnPublisher(Map<Id,BP_Game__c> existingRecords) {
        final Set<Id> publisherIds = new Set<Id>();
        for (BP_Game__c gm : (List<BP_Game__c>)Records) {
            if (gm.BP_Publisher__c != null) {
                publisherIds.add(gm.BP_Publisher__c);
            }
            if (existingRecords != null && !existingRecords.isEmpty() && existingRecords.get(gm.Id).BP_Publisher__c != gm.BP_Publisher__c) {
                publisherIds.add(existingRecords.get(gm.Id).BP_Publisher__c);
            }
        }
        if (publisherIds.isEmpty()) {
            return;
        }
        final Map<Id, Account> publishersToUpdateMap = new Map<Id, Account>(BP_AccountSelector.newInstance().selectById(publisherIds));
        final Map<String, Map<Id, Integer>> publishersIdsToUpdateMap = new Map<String, Map<Id, Integer>>(checkIfNumberOfGamesHasChanged(publishersToUpdateMap.values()));
        if (publishersIdsToUpdateMap.isEmpty()) {
            return;
        }
        final fflib_ISObjectUnitOfWork uow = BP_Application.unitOfWork.newInstance(new List<SObjectType>{Account.SObjectType});
        for (String key : publishersIdsToUpdateMap.keySet()) {
            for (Account acc : publishersToUpdateMap.values()) {
                if (publishersIdsToUpdateMap.containsKey(BASE_GAME_STATUS) && publishersIdsToUpdateMap.get(BASE_GAME_STATUS).containsKey(acc.Id)) {
                    acc.BP_NumberOfGames__c = publishersIdsToUpdateMap.get(BASE_GAME_STATUS).get(acc.Id);
                    uow.registerDirty(acc);
                } else if (publishersIdsToUpdateMap.containsKey(EXPANSION_GAME_STATUS) && publishersIdsToUpdateMap.get(EXPANSION_GAME_STATUS).containsKey(acc.Id)) {
                        acc.BP_NumberOfExpansions__c = publishersIdsToUpdateMap.get(EXPANSION_GAME_STATUS).get(acc.Id);
                        uow.registerDirty(acc);
                }
            }
        }
        uow.commitWork();
    }
}