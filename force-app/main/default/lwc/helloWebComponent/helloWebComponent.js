import { LightningElement, track } from 'lwc';
	
export default class HelloWebComponent extends LightningElement {
    @track greeting = 'Trailblazer';
    
    handleGreetingChange(event) {
        this.greeting = event.target.value;
    }
    get currentDate() {
        return new Date().toDateString();
    }
    get capitalizedGreeting() {
        return `Hello ${this.greeting.toUpperCase()}!`;
    }
}