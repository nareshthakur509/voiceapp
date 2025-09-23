import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["liveText", "finalText", "startBtn", "stopBtn"]

  connect() {
    console.log("Transcribe controller connected")
    this.recognition = null
    this.finalTranscript = ""
  }

  start() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (!SpeechRecognition) {
      alert("Your browser does not support Web Speech API. Use Chrome or Edge.")
      return
    }

    this.recognition = new SpeechRecognition()
    this.recognition.interimResults = true
    this.recognition.continuous = true
    this.recognition.lang = "en-US"

    this.recognition.onresult = (event) => {
      let interim = ""
      for (let i = event.resultIndex; i < event.results.length; i++) {
        const transcript = event.results[i][0].transcript
        if (event.results[i].isFinal) this.finalTranscript += transcript + " "
        else interim += transcript
      }
      this.liveTextTarget.innerText = (this.finalTranscript + interim).trim()
    }

    this.recognition.start()
    this.startBtnTarget.disabled = true
    this.stopBtnTarget.disabled = false
  }

  stop() {
    if (this.recognition) this.recognition.stop()
    this.finalTextTarget.innerText = this.finalTranscript.trim()
    this.startBtnTarget.disabled = false
    this.stopBtnTarget.disabled = true
  }
}
