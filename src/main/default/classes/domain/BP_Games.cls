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

    private void setProperDescription() {

    }
}