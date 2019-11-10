import { LightningElement, track } from 'lwc';

export default class SampleComponent extends LightningElement {
    @track

    contacts = [
        {
            Id : 1,
            Name:'Aravindh',
            Title:'Salesforce Geek',
        },
        {
            Id : 2,
            Name:'Aravindh',
            Title:'Java Geek',
        },
        {
            Id : 3,
            Name:'Tejas',
            Title:'Tipco',
        },
    ];
}