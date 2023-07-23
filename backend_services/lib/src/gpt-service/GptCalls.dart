import 'package:dart_openai/dart_openai.dart';

import '../ambients.dart';

class GptCalls {
  GptCalls(this._openAIApiKey);

  final String _openAIApiKey;

  //String browserRequest;
  //String userProfile;
  final String restaurantPrompt =
      '''You are a restaurant assistant.  Take the following audio transcript of a waiter taking patrons' orders and generate a summary of patrons' orders at a restaurant.  There may be up to 10 speakers in the conversation.  Different speakers' voices are indicated by "spk_0", "spk_1", "spk_2" or up to "spk_9".  You must separate out different speakers' orders and refer to them using using "Seat 1", "Seat 2", "Seat 3", etc.

Example format:

Seat 1: Hamburger, hold the lettuce, fries, Diet Dr. Pepper.

Seat 2: Caesar salad, iced tea.

Audio Transcript:
''';

  final String descriptionPrompt =
      '''You are a Text-to-speech transcription service.  The following JSON data depicts the contents of an audio file: it indicates the number of speakers participating in the conversation and gives an indication of which speaker says which words, indicating the speaker labels "spk_0" or "spk_1" to distinguish between people.  Refer to speakers as Speaker 1 or Speaker 2.

Given the content of the JSON file, write a short 2 sentence high level description of this conversation.''';

  final String summaryPrompt =
      '''You are a Text-to-speech transcription service.  The following JSON data depicts the contents of an audio file: it indicates the number of speakers participating in the conversation and gives an indication of which speaker says which words, indicating the speaker labels "spk_0" or "spk_1" to distinguish between people.  Refer to speakers as Speaker 1 or Speaker 2.

Given the content of the JSON file, write a human readable transcript of the following format:

Speaker1: Did you get Mike's invitation to the party?

Speaker2: Yes, I'm looking forward to it.''';

  final reminderPrompt =
      '''You are a reminder assistant.  Take the following audio transcript and generate a list of reminders for a person with short term memory loss.  Provide clear reminder descriptions and date/times for reminders that will occur within the next 7 days.

Provide a description date/time of the following format:

Reminder 1: 2023-08-03T08:00, Take your morning pill
Reminder 2: 2023-08-04T11:00, Call Michael

If this is a conversation about food orders in a restaurant, apologize that you are unable to generate reminders.

''';

  Future<String?> getOpenAiSummary(
    String transcript,
    String userProfile,
  ) async {
    OpenAI.apiKey = _openAIApiKey;

    String descriptionPromptToSend =
        descriptionPrompt + userProfile + transcript;

    logPrompt('getOpenAiSummary', descriptionPromptToSend);

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: descriptionPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    final response = completion.choices[0].message.content;
    logResponse('getOpenAiSummary', response);
    return response;
    //The conversation involves Speaker 1 expressing their hesitation and uncertainty about their pain tolerance, while Speaker 2 reassures them and expresses readiness to start the activity.
    // Possible Error: RequestFailedException (RequestFailedException{message: That model is currently overloaded with other requests. You can retry your request, or contact us through our help center at help.openai.com if the error persists. (Please include the request ID d946214a3b7fa731346976ac8a39e724 in your message.), statusCode: 503})
  }

  Future<String> extractFormValuesFromTranscript(
      String transcript, String userProfile, dynamic fields) async {
    OpenAI.apiKey = _openAIApiKey;

    String formFillerPromptToSend =
        '''You are a form filler service. I will give you a transcript and list of field 
names and I want you to extract the values for the fields out of the information 
in the transcript. The field values should be in JSON format. 
Here is additional information about the user:
$userProfile
Here are the list of fields in JSON format:
$fields
Here is the transcript I want you to extract field values from:
$transcript
Please ensure that every field in the list of fields has a value filled in, and make up answers if no relevant information is available.''';

    logPrompt('extractFormValuesFromTranscript', formFillerPromptToSend);

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: formFillerPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    final response = completion.choices[0].message.content;
    logResponse('extractFormValuesFromTranscript', response);
    return response;
  }

  Future<String> getRestaurantOrder(
      String transcript, String userProfile) async {
    OpenAI.apiKey = _openAIApiKey;

    String restaurantPromptToSend = restaurantPrompt + transcript;

    logPrompt('getRestaurantOrder', restaurantPromptToSend);

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: restaurantPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    final response = completion.choices[0].message.content;
    logResponse('getRestaurantOrder', response);
    return response;
  }

  Future<String> getReminders(
      String transcript, String userProfile, DateTime recordedDate) async {
    OpenAI.apiKey = _openAIApiKey;

    String reminderPromptToSend =
        '$reminderPrompt \n The Current Date and time is: ${recordedDate.toIso8601String()}\n The Audio Transcript:\n$transcript';

    logPrompt('getReminders', reminderPromptToSend);

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: reminderPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    final response = completion.choices[0].message.content;
    logResponse('getReminders', response);
    return response;
  }

  void logPrompt(String methodName, String prompt) {
    log.i("$methodName prompt:\n$prompt");
  }

  void logResponse(String methodName, String response) {
    log.i("$methodName response:\n$response");
  }
}
