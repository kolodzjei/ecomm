import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "input1", "input2", "error", "submitButton" ]; 

  connect(){
    this.checkPriceRange();
  }

  checkPriceRange(){
    this.input1Target.addEventListener('change', () => {
      var min = parseFloat(this.input1Target.value);
      var max = parseFloat(this.input2Target.value);
      if(min > max){
        this.errorTarget.style.display = "block";
        this.submitButtonTarget.disabled = true;
      }else{
        this.errorTarget.style.display = "none";
        this.submitButtonTarget.disabled = false;
      }
    });
    this.input2Target.addEventListener('change', () => {
      var min = parseFloat(this.input1Target.value);
      var max = parseFloat(this.input2Target.value);
      if(min > max){
        this.errorTarget.style.display = "block";
        this.submitButtonTarget.disabled = true;
      }else{
        this.errorTarget.style.display = "none";
        this.submitButtonTarget.disabled = false;
      }
    });
  }




}