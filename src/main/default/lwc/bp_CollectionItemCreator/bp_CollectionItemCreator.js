/**
 * Created by Jedrzej Gruca on 15/11/2023.
 */

import { LightningElement, track, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import currentUserId from '@salesforce/user/Id';

import COLLECTION_ITEM_OBJECT from '@salesforce/schema/BP_CollectionItem__c';
import GAME_CONDITION_FIELD from '@salesforce/schema/BP_CollectionItem__c.BP_GameCondition__c';
import GAME_NAME_FIELD from '@salesforce/schema/BP_Game__c.Name';

import upsertNewItem from '@salesforce/apex/BP_CollectionItemController.upsertCollectionItem';

const GAME_CONDITION_USED = 'Used';
const GAME_CONDITION_DAMAGED = 'Damaged';

export default class BpCollectionItemCreator extends NavigationMixin(LightningElement) {

    objectApiName = COLLECTION_ITEM_OBJECT.objectApiName;
    @track userId = currentUserId;
    blockSaveButtons = false;
    showLoader = true;
    showDescription = false;
    createNewAfter = false;
    @track gameId;
    @track gameName;
    @track gameConditionApi;
    gameConditionName;
    collectionItemName;


    @wire(getObjectInfo, { objectApiName: COLLECTION_ITEM_OBJECT })
    collectionItemInfo;

    get defaultRecordTypeId() {
        if (this.collectionItemInfo && this.collectionItemInfo.data) {
            return this.collectionItemInfo.data.defaultRecordTypeId;
        }
    }

    @wire(getPicklistValues, {fieldApiName: GAME_CONDITION_FIELD, recordTypeId: '$defaultRecordTypeId'})
    getGameCondition({data, error}) {
        if (data) {
            this.gameConditions = data.values;
        }
    };

    @wire(getRecord, { recordId: '$gameId', fields: [GAME_NAME_FIELD] })
    getGameName({data, error}) {
        if (data && data.fields) {
            this.gameName = data.fields[GAME_NAME_FIELD.fieldApiName].value;
        }
    }

    handleGameConditionChanged(event) {
        if (event.target.value) {
            const gameCondition = this.gameConditions.find(gameCondition => {
                return gameCondition.value === event.target.value;
            });
            if (gameCondition && gameCondition.label) {
                this.gameConditionName = gameCondition.label;
                this.gameConditionApi = gameCondition.value;
            }
            if(this.gameConditionApi === GAME_CONDITION_USED || this.gameConditionApi === GAME_CONDITION_DAMAGED) {
                this.showDescription = true;
            } else {
                this.showDescription = false;
            }
        } else {
            this.gameConditionApi = null;
        }
    }

    handleGameChanged(event) {
        if(event.target.value){
            this.gameId = event.target.value;
        }else{
            this.gameId = null;
        }
    }

    handleSubmit(event) {
        event.preventDefault();
        const validationPassed = this.validateFields();
        if (validationPassed) {
            let fields = event.detail.fields;
            this.blockSaveButtons = true;
            this.showLoader = true;
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
    }

    validateFields() {
        let validationPassed = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            if (!element.reportValidity()) {
                validationPassed = false;
            };
        });
        return validationPassed;
    }

    handleLoad() {
        this.showLoader = false;
    }

    handleSave() {
        this.createNewAfter = false;
    };

    handleSaveAndNew() {
        this.createNewAfter = true;
    };

    handleSuccess(event) {
        const cmp = this;
        upsertNewItem({collectionItemId: event.detail.id})
            .then(data => {
                const toastEvent = new ShowToastEvent({
                    title: "Sukces",
                    message: "Nowa gra została dodana do kolekcji",
                    variant: "success"
                });
                cmp.blockSaveButtons = false;
                cmp.handleReset();
                cmp.showLoader = false;
                cmp.dispatchEvent(toastEvent);
                if (!this.createNewAfter) {
                    cmp.goToNewRecordPage(event.detail.id);
                } else {
                    window.location.reload();
                }
            })
            .catch(error => {
                if (error.body && error.body.message) {
                    const evt = new ShowToastEvent({
                        title: "Błąd",
                        message: error.body.message,
                        variant: "error"
                    });
                    cmp.dispatchEvent(evt);
                }
            });
    }

    handleError(event) {
        this.blockSaveButtons = false;
        this.showLoader = false;
    }

    goToNewRecordPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view',
            },
        });
        if (!this.createNewAfter) {
            const exitEditionEvent = new CustomEvent("navigation");
            this.dispatchEvent(exitEditionEvent);
        }
        this.createNewAfter = false;
    }

    handleReset(event) {
        const lightningInputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (lightningInputFields) {
            lightningInputFields.forEach((field, index) => {
                if (!this.createNewAfter) {
                    field.reset();
                }
            });
        }
        this.gameId = null;
        this.gameConditionApi = null;
        this.gameName = null;
        this.gameConditionName = null;
    }

    get generateName(){
        return this.collectionItemName = `${this.gameName} - ${this.gameConditionName}`;
    }
}