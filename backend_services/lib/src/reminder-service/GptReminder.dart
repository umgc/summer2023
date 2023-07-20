import 'package:dart_openai/dart_openai.dart';

class GptReminder {
  GptReminder(this._openAIApiKey);

  final String _openAIApiKey;

  final String reminderPrompt =
      '''You are a Text-to-speech transcription service. The following JSON data depicts the contents of an audio file: From this audio file, find any sections that refer to an event occuring in the future 
      and create reminders in the form of a list of Strings that are divided by commas. The reminder should be in the form of the event, the time in military standard, and the day on which the reminder will occur.''';

  //String remindersPrompt;

  Future<String?> getOpenAiReminderList(
    String transcript,
    String userProfile,
  ) async {
    OpenAI.apiKey = _openAIApiKey;

    String reminderPromptToSend = reminderPrompt + userProfile + transcript;

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: reminderPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    return completion.choices[0]
        .toString(); // This is where the string of reminders would be generated and divided by
    // Possible Error: RequestFailedException (RequestFailedException{message: That model is currently overloaded with other requests. You can retry your request, or contact us through our help center at help.openai.com if the error persists. (Please include the request ID d946214a3b7fa731346976ac8a39e724 in your message.), statusCode: 503})
  }
}
