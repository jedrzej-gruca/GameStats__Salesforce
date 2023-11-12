/**
 * Created by Jedrzej Gruca on 12/11/2023.
 */

public with sharing class BP_Accounts extends fflib_SObjectDomain {

    public BP_Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_sObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new BP_Accounts(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        setLocationOnPublisher(null);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        setLocationOnPublisher((Map<Id, Account>)existingRecords);
    }

    private void setLocationOnPublisher(Map<Id, Account> existingRecords) {
        List<Account> publishersToSetLocation = new List<Account>();
        if (existingRecords != null && !existingRecords.isEmpty()) {
            publishersToSetLocation = (List<Account>)getChangedRecords(new Set<SObjectField>{Account.BillingCountry, Account.BillingState, Account.BillingCity, Account.BillingStreet, Account.BillingPostalCode});
        } else {
            publishersToSetLocation.addAll((List<Account>)Records);
        }
        if (publishersToSetLocation.isEmpty()) {
            return;
        }
        for (Account acc : publishersToSetLocation) {
            acc.Location__Latitude__s = acc.BillingLatitude;
            acc.Location__Longitude__s = acc.BillingLongitude;
        }
    }
}