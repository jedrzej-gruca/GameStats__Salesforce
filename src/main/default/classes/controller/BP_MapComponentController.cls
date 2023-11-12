/**
 * Created by Jedrzej Gruca on 12/11/2023.
 */

public without sharing class BP_MapComponentController {

    @AuraEnabled(Cacheable = true)
    public static List<MapMarkers> getAccountLocationsToDisplayOnMap(Id recordId) {
        final List<Account> accounts = new List<Account>(BP_AccountSelector.newInstance().selectByIdWithAdditionalFields(new Set<Id>{recordId}));
        final List<MapMarkers> mapMarkers = new List<MapMarkers>();
        for (Account acc : accounts) {
            MapMarkers mapMrk = new MapMarkers();
            Location location = new Location();
            mapMrk.value = acc.Id;
            mapMrk.title = acc.Name;
            location.latitude = acc.Location__Latitude__s;
            location.longitude = acc.Location__Longitude__s;
            mapMrk.location = location;
            mapMarkers.add(mapMrk);
        }
        return mapMarkers;
    }

    @TestVisible
    private class MapMarkers {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public Location location;
    }

    @TestVisible
    private class Location {
        @AuraEnabled
        public Decimal latitude;
        @AuraEnabled
        public Decimal longitude;
    }
}