/**
 * Created by Jedrzej Gruca on 15/10/2023.
 */

import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {FlowNavigationBackEvent, FlowNavigationNextEvent, FlowAttributeChangeEvent} from 'lightning/flowSupport';
import getGamesBySearchString from '@salesforce/apex/BP_GameWrapperController.getGamesBySearchString';

export default class BpBggGameSearchResultList extends LightningElement {
    @track isLoading = false;
    @track gameName = '';
    @track data;
    @track isGameFound = true;
    @api selectedGameId;
    @api BP_FlowContinued;
    @api BP_isFinishing;

    handleGameNameChange(event) {
        this.gameName = event.target.value;
    }

    handleSearchGame(){
        this.isLoading = true;
        getGamesBySearchString({gameName: this.gameName})
            .then(result => {
                this.isLoading = false;
                this.isGameFound = true;
                this.data = result;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Znaleziono gry!',
                    variant: 'success'
                }));
                this.dispatchEvent(new CustomEvent('submit'));
            })
            .catch(error => {
                console.log(error);
                this.isLoading = false;
                this.isGameFound = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Błąd',
                    message: 'Nie udało się znaleźć gier. ' + error.body?.message,
                    variant: 'error'
                }));
            });
    }

    get noGames() {
        return !this.isLoading && this.data.length === 0;
    }

    get dataLoaded() {
        return this.data;
    }

    get isNextButtonDisabled() {
        return this.isLoading || !this.selectedGameId;
    }

    get searchResultListName() {
        return 'Dla frazy: "' + this.gameName + '" znaleziono następujące gry:';
    }

    get isFlowContinued() {
        return this.BP_FlowContinued;
    }

    handleGameChoice(event) {
        let gameId = event.currentTarget.getAttribute('id');
        this.selectedGameId = gameId.split('-')[0];
        this.dispatchEvent(new FlowAttributeChangeEvent('selectedGameId', this.selectedGameId));
        this.dispatchEvent(new FlowNavigationNextEvent());
    }

    handleGoBack() {
        this.dispatchEvent(new FlowNavigationBackEvent());
    }

    handleQuit() {
        this.BP_isFinishing = true;
        const changeEvent = new FlowAttributeChangeEvent('BP_isFinishing', this.BP_isFinishing);
        this.dispatchEvent(changeEvent);
        this.dispatchEvent(new FlowNavigationNextEvent());
    }
}