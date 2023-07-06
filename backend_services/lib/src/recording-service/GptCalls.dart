import 'package:dart_openai/dart_openai.dart';




class GptCalls {

  //String browserRequest;
  //String userProfile;
  //String restaurantPrompt;


  final String descriptionPrompt = '''You are a Text-to-speech transcription service.  The following JSON data depicts the contents of an audio file: it indicates the number of speakers participating in the conversation and gives an indication of which speaker says which words, indicating the speaker labels "spk_0" or "spk_1" to distinguish between people.  Refer to speakers as Speaker 1 or Speaker 2.

Given the content of the JSON file, write a short 2 sentence high level description of this conversation.''';

final String summaryPrompt = '''You are a Text-to-speech transcription service.  The following JSON data depicts the contents of an audio file: it indicates the number of speakers participating in the conversation and gives an indication of which speaker says which words, indicating the speaker labels "spk_0" or "spk_1" to distinguish between people.  Refer to speakers as Speaker 1 or Speaker 2.

Given the content of the JSON file, write a human readable transcript of the following format:

Speaker1: Did you get Mike's invitation to the party?

Speaker2: Yes, I'm looking forward to it.''';


  //String formFillerPrompt;
  //String remindersPrompt;


    Future<String?> getOpenAiSummary(String transcript, String userProfile, ) async {
      OpenAI.apiKey = 'DANGER_WILL_ROBINSON';

      String descriptionPromptToSend = descriptionPrompt + userProfile + transcript;
      
      List<OpenAIChatCompletionChoiceMessageModel> messages = [OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.user, content: descriptionPromptToSend)];


      final completion = await OpenAI.instance.chat.create(model: "gpt-3.5-turbo", messages: messages);

      return completion.choices[0].toString();  //The conversation involves Speaker 1 expressing their hesitation and uncertainty about their pain tolerance, while Speaker 2 reassures them and expresses readiness to start the activity.
      // Possible Error: RequestFailedException (RequestFailedException{message: That model is currently overloaded with other requests. You can retry your request, or contact us through our help center at help.openai.com if the error persists. (Please include the request ID d946214a3b7fa731346976ac8a39e724 in your message.), statusCode: 503})

    }

  






}