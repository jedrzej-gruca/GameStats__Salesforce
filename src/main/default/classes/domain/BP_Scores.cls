/**
 * Created by Jedrzej Gruca on 02/12/2023.
 */

public with sharing class BP_Scores extends fflib_SObjectDomain {

    public BP_Scores(List<BP_Score__c> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new BP_Scores(sObjectList);
        }
    }

    public override void onAfterInsert() {
        setNewWinnerOnRelatedGameplay();
    }

    private void setNewWinnerOnRelatedGameplay() {
        final Set<Id> gameplayIds = new Set<Id>();
        for (BP_Score__c score : (List<BP_Score__c>)Records) {
            gameplayIds.add(score.BP_GamePlay__c);
        }
        if (gameplayIds.isEmpty()) {
            return;
        }
        final List<BP_Score__c> scores = BP_ScoreSelector.newInstance().selectByGameplayId(gameplayIds);
        final Map<Id, BP_Score__c> gameplayToHighestScoreMap = new Map<Id, BP_Score__c>();
        for (BP_Score__c sc : scores) {
            if (gameplayToHighestScoreMap.containsKey(sc.BP_GamePlay__c)) {
                continue;
            } else {
                gameplayToHighestScoreMap.put(sc.BP_GamePlay__c, sc);
            }
        }
        final List<BP_Gameplay__c> gameplaysToUpdate = BP_GameplaySelector.newInstance().selectById(gameplayToHighestScoreMap.keySet());
        final fflib_ISObjectUnitOfWork uow = BP_Application.unitOfWork.newInstance(new List<SObjectType>{BP_Gameplay__c.SObjectType});
        for (BP_Gameplay__c gp : gameplaysToUpdate) {
            if (gp.BP_Winner__c == gameplayToHighestScoreMap.get(gp.Id).BP_Player__c) {
                continue;
            } else {
                gp.BP_Winner__c = gameplayToHighestScoreMap.get(gp.Id).BP_Player__c;
                uow.registerDirty(gp);
            }
        }
        uow.commitWork();
    }
}