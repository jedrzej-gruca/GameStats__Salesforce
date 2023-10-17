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