# **Project: App for Short-term Memory Assistance**

## **I. Overview**
Design and develop an app to aid individuals with short-term memory loss. The app's primary features focus on recording and transcribing conversations, identifying participants, and providing potential follow-up items. It also integrates with a browser extension for form-filling tasks.

## **II. Core Features**

- **Conversation Recording**: Captures and saves audio conversations directly on the user's device.
- **Transcription**: Uses Whisper AI to convert audio conversations into written text.
- **Context Setup**: Leverages Chat GPT for extracting relevant information such as reminders, orders, and form-fill data from the transcribed text.
- **Participant Identification**: Identifies and records conversation participants.

## **III. Use Cases**

1. **Follow-Up Item Extraction**: Helps the user by identifying any potential follow-up tasks or items from the transcribed conversation.
2. **Form Filling Assistance**: Assists the user in filling out online web forms. Users can select a conversation for reference, and the browser extension will interact with the webpage to fill out the form.
3. **Order Recording for Waitstaff**: Helps waitstaff at restaurants record and transcribe orders, including any customizations. The transcriptions will be analyzed by Chat GPT to identify all ordered items.

## **IV. Unique Features**

- **Conversation Titling**: Each conversation is assigned a suggested title determined by the content of the conversation using Chat GPT.
- **Form Scrubbing**: The Chrome extension identifies the information requested in web forms (e.g., name, address, phone number).

## **V. Development Details**

- **Platform**: The app will be available on Android and iOS devices.
- **Technology Stack**: The app will be developed using the Flutter framework and Dart language.
- **Data Storage**: All recordings will be stored on the user's device.

