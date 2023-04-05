import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["input"]

  connect() {
    if(this.inputTarget){
      this.checkImageSize()
    }

  }

  checkImageSize() {
    this.inputTarget.addEventListener('change', (e) => {
      var fileSize = this.inputTarget.files[0].size;
      var maxSize = 5 * 1024 * 1024; // 5MB
      if(fileSize > maxSize){
        alert('File cant be larger than 5MB. Please choose other file.');
        $(this.inputTarget).val('');
      }
    });
  }

}