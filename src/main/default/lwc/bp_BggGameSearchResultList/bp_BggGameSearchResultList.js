/**
 * Created by drzeju on 15/10/2023.
 */

import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getGamesBySearchString from '@salesforce/apex/BP_GameWrapperController.getGamesBySearchString'

export default class BpBggGameSearchResultList extends LightningElement {
    @track isLoading = false;
    @track gameName = undefined;
    @track data;
    @track isGameFound = true;

    handleGameNameChange(event) {
        this.gameName = event.target.value;
        if (this.gameName.toString().includes(' ')) {
            this. gameName = this.gameName.toString().replace(' ', '_');
        }
    }

    handleSearchGame(){
        this.isLoading = true;
        getGamesBySearchString({gameName: this.gameName})
            .then(result => {
                this.isLoading = false;
                this.isGameFound = true;
                console.log(result);
                for (let row in result){
                    console.log(row + ': ' + result[row]);
                }
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

}