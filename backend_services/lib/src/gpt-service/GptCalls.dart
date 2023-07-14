import 'package:dart_openai/dart_openai.dart';
import 'package:logger/logger.dart';

class GptCalls {
  GptCalls(this._openAIApiKey);

  final String _openAIApiKey;

  final Logger _logger = Logger();

  //String browserRequest;
  //String userProfile;
  //String restaurantPrompt;

  final String descriptionPrompt =
      '''You are a Text-to-speech transcription service.  The following JSON data depicts the contents of an audio file: it indicates the number of speakers participating in the conversation and gives an indication of which speaker says which words, indicating the speaker labels "spk_0" or "spk_1" to distinguish between people.  Refer to speakers as Speaker 1 or Speaker 2.

Given the content of the JSON file, write a short 2 sentence high level description of this conversation.''';

  final String summaryPrompt =
      '''You are a Text-to-speech transcription service.  The following JSON data depicts the contents of an audio file: it indicates the number of speakers participating in the conversation and gives an indication of which speaker says which words, indicating the speaker labels "spk_0" or "spk_1" to distinguish between people.  Refer to speakers as Speaker 1 or Speaker 2.

Given the content of the JSON file, write a human readable transcript of the following format:

Speaker1: Did you get Mike's invitation to the party?

Speaker2: Yes, I'm looking forward to it.''';

  //String remindersPrompt;

  Future<String?> getOpenAiSummary(
    String transcript,
    String userProfile,
  ) async {
    OpenAI.apiKey = _openAIApiKey;

    String descriptionPromptToSend =
        descriptionPrompt + userProfile + transcript;

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: descriptionPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    return completion.choices[0]
        .toString(); //The conversation involves Speaker 1 expressing their hesitation and uncertainty about their pain tolerance, while Speaker 2 reassures them and expresses readiness to start the activity.
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

    _logger.i(formFillerPromptToSend);

    List<OpenAIChatCompletionChoiceMessageModel> messages = [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: formFillerPromptToSend)
    ];

    final completion = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages);

    return completion.choices[0].message.content;
  }
}
