import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["alert"];

  connect(){
    if(this.hasAlertTarget){
      this.removeAlert();
    }
  }

  removeAlert(){
    setTimeout(() => {
      this.alertTarget.animate( 
        { opacity: [1, 0] }, 
        { duration: 500 });
    }, 3000);
    setTimeout(() => {
      this.alertTarget.remove();
    }, 3500);
  }

}