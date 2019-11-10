import { LightningElement, api } from 'lwc';
import urlResources from '@salesforce/resourceUrl/ursus_park'

export default class BearTile extends LightningElement {
    @api bear;
    appResources = {
        bearSilhouette: urlResources+'/img/standing-bear-silhouette.png',
    };
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('bearview', {
            bubbles: true
        });
        this.dispatchEvent(selectEvent);
    }
}