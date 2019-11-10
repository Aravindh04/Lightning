import { LightningElement, track, api } from 'lwc';
import { bikes } from 'c/data';


export default class Detail extends LightningElement {

    // Ensure changes are reactive when product is updated
    @track product;

    // Private var to track @api productId
    _productId = undefined;

    // Use set and get to process the value every time it's
    // requested while switching between products
    @api set productId(value) {
        this._productId = value;
        this.product = bikes.find(bike => bike.fields.Id.value === value);
    }
    
    // getter for productId
    get productId(){
        return this._productId;
    }
}