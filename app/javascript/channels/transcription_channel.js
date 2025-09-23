subscription = consumer.subscriptions.create(
  { channel: "TranscriptionChannel", id: transcriptionId },
  {
    connected() { console.log("AC connected for", transcriptionId); },
    disconnected() { console.log("AC disconnected"); },
    received(data) {
      console.log("AC received", data);
      if (data.final_transcription) finalText.innerText = data.final_transcription;
      if (data.summary) summaryText.innerText = data.summary;
      if (data.status === "error") finalText.innerText = "Error: " + (data.error || "unknown");
    }
  }
);