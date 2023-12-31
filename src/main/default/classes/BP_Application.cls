/**
 * Created by Jedrzej Gruca on 12/10/2023.
 * Class containing mappings for fflib framework, mainly for the purposes of test data mocking.
 */

public with sharing class BP_Application {
    public static final fflib_Application.UnitOfWorkFactory unitOfWork =
            new fflib_Application.UnitOfWorkFactory(
                    new List<SObjectType> {
                    }
            );

    public static final fflib_Application.ServiceFactory service =
            new fflib_Application.ServiceFactory(
                    new Map<Type, Type> {
                            BP_GameService.BP_IGameService.class => BP_GameService.class
                    }
            );

    public static final fflib_Application.SelectorFactory selector =
            new fflib_Application.SelectorFactory(
                    new Map<SObjectType, Type>{
                        BP_Game__c.SObjectType => BP_GameSelector.class,
                        Account.SObjectType => BP_AccountSelector.class,
                        BP_CollectionItem__c.SObjectType => BP_CollectionItemSelector.class,
                        BP_Gameplay__c.SObjectType => BP_GameplaySelector.class,
                        BP_Score__c.SObjectType => BP_ScoreSelector.class
                    }
            );

    public static final fflib_Application.DomainFactory domain =
            new fflib_Application.DomainFactory(
                    BP_Application.selector,
                    new Map<SObjectType, Type>{
                        BP_Game__c.SObjectType => BP_Games.Constructor.class,
                        Account.SObjectType => BP_Accounts.Constructor.class,
                        BP_Score__c.SObjectType => BP_Scores.Constructor.class
                    }
            );

    public without sharing class WithoutSharingUowManager {
        private final fflib_ISObjectUnitOfWork uow;
        public WithoutSharingUowManager(fflib_ISObjectUnitOfWork uow) {
            this.uow = uow;
        }
        public void commitUow() {
            uow.commitWork();
        }
    }
}