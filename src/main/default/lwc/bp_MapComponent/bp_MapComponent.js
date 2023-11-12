/**
 * Created by Jedrzej Gruca on 12/11/2023.
 */

import {LightningElement, api, track, wire} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getAccountLocationsToDisplayOnMap from "@salesforce/apex/BP_MapComponentController.getAccountLocationsToDisplayOnMap";

export default class BpMapComponent extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track mapMarkers = [];
    @track mapOptions = {
        draggable: true,
        scrollWhell: true,
        zoomControl: true,
        disableDefaultUI: false
    };
    zoomLevel = 14;
    selectedMarkerValue;

    @wire(getAccountLocationsToDisplayOnMap, {recordId: '$recordId'})
    getAccountsToDisplay({data, error}) {
        if (data) {
            const mapMarkers = [];
            data.forEach(mapData => {
                const singleLocation = {
                    value: mapData.value,
                    title: mapData.title,
                    location: {
                        Latitude: mapData.location.latitude,
                        Longitude: mapData.location.longitude
                    }
                }
                mapMarkers.push(singleLocation);
            })
            if (mapMarkers.length > 0) {
                this.selectedMarkerValue = mapMarkers[0].value;
                this.mapMarkers = mapMarkers;
            }
        }
        if (error) {
            this.handleError(error);
        }
    }

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.detail.selectedMarkerValue;
    }

    handleError(error) {
        let errorMessage = error;
        if (error.body && error.body.message) {
            errorMessage = error.body.message;
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Błąd!',
                message: errorMessage,
                variant: 'error'
            })
        );
    }
}