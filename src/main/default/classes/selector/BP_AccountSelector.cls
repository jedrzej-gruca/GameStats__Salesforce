/**
 * Created by Jedrzej Gruca on 11/11/2023.
 */

public with sharing class BP_AccountSelector extends fflib_SObjectSelector implements BP_IAccountSelector {

    public BP_AccountSelector() {
        super();
    }

    public static BP_AccountSelector newInstance() {
        return (BP_AccountSelector) BP_Application.selector.newInstance(Account.SObjectType);
    }

    public SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Account.Id,
                Account.Name,
                Account.BP_NumberOfGames__c,
                Account.BP_NumberOfExpansions__c
        };
    }

    public List<Account> selectById(Set<Id> ids) {
        return (List<Account>)selectSObjectsById(ids);
    }

    public List<Account> selectByIdWithAdditionalFields(Set<Id> ids) {
        final fflib_QueryFactory queryFactory = newQueryFactory()
                .selectField(Account.Location__Latitude__s)
                .selectField(Account.Location__Longitude__s)
                .setCondition('Id IN :ids');
        return Database.query(String.escapeSingleQuotes(queryFactory.toSOQL()));
    }

    public interface BP_IAccountSelector {
        SObjectType getSObjectType();
        List<SObjectField> getSObjectFieldList();
        List<Account> selectById(Set<Id> ids);
    }
}