import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  static targets = ["downloadButton", "downloadLink", "startDate", "endDate"]

  async onClick(){
    const startDate = this.startDateTarget.value
    const endDate = this.endDateTarget.value
    this.downloadButtonTarget.innerText = 'Generating CSV...'
    this.downloadButtonTarget.disabled = true

    try {
      const response = await fetch('/admin/summary/download_csv', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({start_date: startDate, end_date: endDate})
      })

      const data = await response.json()
      const jobId = data.job_id
      this.checkJobStatus(jobId)
    } catch (error) {
      alert('Error generating CSV. Please try again.')
    }
  }

  async checkJobStatus(jobId) {
    try{
      const response = await fetch(`/admin/summary/check_job_status?job_id=${jobId}`)
      
      const {status, download_url} = await response.json()

      if (status == 'complete') {
        const downloadLink = document.createElement('a')
        downloadLink.classList.add('btn', 'btn-success', 'btn-sm')
        downloadLink.innerText = 'Download CSV'
        downloadLink.href = download_url
        this.downloadButtonTarget.replaceWith(downloadLink)

        setTimeout(() => {
          const disabledButton = document.createElement('button')
          disabledButton.classList.add('btn', 'btn-dark', 'btn-sm')
          disabledButton.innerText = 'Download expired'
          disabledButton.disabled = true
          downloadLink.replaceWith(disabledButton)
        }, 60000)
    }else {
      setTimeout(() => {
        this.checkJobStatus(jobId)
      }, 5000)
    }}catch(error){
      alert('Error generating CSV. Please try again.')
    }
  }
}