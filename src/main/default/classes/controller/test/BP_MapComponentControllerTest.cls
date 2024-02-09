/**
 * Created by Jedrzej Gruca on 04/02/2024.
 */

@IsTest
public with sharing class BP_MapComponentControllerTest {

    @IsTest
    static void getAccountLocationsToDisplayOnMapTest() {
        final Account fakeAccount = new Account(
                Id = fflib_IDGenerator.generate(Account.SObjectType),
                Name = 'Fake Account',
                Location__Latitude__s = 1000,
                Location__Longitude__s = 1000
        );

        BP_MapComponentController.Location fakeLocation = new BP_MapComponentController.Location();
        fakeLocation.latitude = fakeAccount.Location__Latitude__s;
        fakeLocation.longitude = fakeAccount.Location__Longitude__s;

        BP_MapComponentController.MapMarkers fakeMapMarkers = new BP_MapComponentController.MapMarkers();
        fakeMapMarkers.value = fakeAccount.Id;
        fakeMapMarkers.title = fakeAccount.Name;
        fakeMapMarkers.location = fakeLocation;

        final fflib_ApexMocks mocks = new fflib_ApexMocks();
        final BP_AccountSelector selectorMock = (BP_AccountSelector) mocks.mock(BP_AccountSelector.class);
        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMock.selectByIdWithAdditionalFields(new Set<Id>{fakeAccount.Id}))
                .thenReturn(new List<Account>{fakeAccount});
        mocks.stopStubbing();
        BP_Application.selector.setMock(selectorMock);

        Test.startTest();
        BP_MapComponentController.MapMarkers retrievedMarker = BP_MapComponentController.getAccountLocationsToDisplayOnMap(fakeAccount.Id).get(0);
        Test.stopTest();

        Assert.areEqual(fakeMapMarkers.value, retrievedMarker.value);
    }

}