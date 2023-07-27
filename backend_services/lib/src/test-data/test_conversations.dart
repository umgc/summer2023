import 'package:backend_services/model/conversation.dart';

class TestConversations {
  static List<Conversation> get sampleConversations {
    //Sample Data - Method will load literals into memory as recordingFile

    String transcript1 =
        """{"jobName":"test-interview-sample","accountId":"375374704108","results":{"transcripts":[{"transcript":"Hey, but I'm going into this very humble, smart, smart, I mean, I don't think I have that high of a pain tolerance. Well, I guess we'll find out today. Are you ready to get started? Yeah. Sure. Oh, we're going right to the left. Yeah, that's very important. Ok."}],"speaker_labels":{"channel_label":"ch_0","speakers":2,"segments":[{"start_time":"0.0","speaker_label":"spk_0","end_time":"7.71","items":[{"start_time":"0.009","speaker_label":"spk_0","end_time":"0.579"},{"start_time":"0.589","speaker_label":"spk_0","end_time":"0.8"},{"start_time":"0.81","speaker_label":"spk_0","end_time":"0.99"},{"start_time":"1.0","speaker_label":"spk_0","end_time":"1.269"},{"start_time":"1.279","speaker_label":"spk_0","end_time":"1.46"},{"start_time":"1.47","speaker_label":"spk_0","end_time":"1.779"},{"start_time":"1.789","speaker_label":"spk_0","end_time":"2.569"},{"start_time":"2.579","speaker_label":"spk_0","end_time":"3.24"},{"start_time":"3.349","speaker_label":"spk_0","end_time":"4.119"},{"start_time":"4.13","speaker_label":"spk_0","end_time":"4.78"},{"start_time":"5.07","speaker_label":"spk_0","end_time":"5.619"},{"start_time":"5.63","speaker_label":"spk_0","end_time":"6.07"},{"start_time":"6.079","speaker_label":"spk_0","end_time":"6.09"},{"start_time":"6.099","speaker_label":"spk_0","end_time":"6.309"},{"start_time":"6.32","speaker_label":"spk_0","end_time":"6.429"},{"start_time":"6.44","speaker_label":"spk_0","end_time":"6.449"},{"start_time":"6.46","speaker_label":"spk_0","end_time":"6.769"},{"start_time":"6.78","speaker_label":"spk_0","end_time":"7.079"},{"start_time":"7.09","speaker_label":"spk_0","end_time":"7.289"},{"start_time":"7.3","speaker_label":"spk_0","end_time":"7.46"},{"start_time":"7.469","speaker_label":"spk_0","end_time":"7.48"},{"start_time":"7.489","speaker_label":"spk_0","end_time":"7.71"}]},{"start_time":"7.719","speaker_label":"spk_1","end_time":"11.939","items":[{"start_time":"7.719","speaker_label":"spk_1","end_time":"8.329"},{"start_time":"8.56","speaker_label":"spk_1","end_time":"8.77"},{"start_time":"8.779","speaker_label":"spk_1","end_time":"8.8"},{"start_time":"8.81","speaker_label":"spk_1","end_time":"9.05"},{"start_time":"9.06","speaker_label":"spk_1","end_time":"9.25"},{"start_time":"9.26","speaker_label":"spk_1","end_time":"9.56"},{"start_time":"9.569","speaker_label":"spk_1","end_time":"9.789"},{"start_time":"9.8","speaker_label":"spk_1","end_time":"10.34"},{"start_time":"10.35","speaker_label":"spk_1","end_time":"10.77"},{"start_time":"10.779","speaker_label":"spk_1","end_time":"10.85"},{"start_time":"10.859","speaker_label":"spk_1","end_time":"11.069"},{"start_time":"11.079","speaker_label":"spk_1","end_time":"11.149"},{"start_time":"11.159","speaker_label":"spk_1","end_time":"11.31"},{"start_time":"11.319","speaker_label":"spk_1","end_time":"11.939"}]},{"start_time":"11.949","speaker_label":"spk_0","end_time":"12.829","items":[{"start_time":"11.949","speaker_label":"spk_0","end_time":"12.119"},{"start_time":"12.13","speaker_label":"spk_0","end_time":"12.739"}]},{"start_time":"20.079","speaker_label":"spk_0","end_time":"21.12","items":[{"start_time":"20.09","speaker_label":"spk_0","end_time":"20.139"},{"start_time":"20.149","speaker_label":"spk_0","end_time":"20.409"},{"start_time":"20.42","speaker_label":"spk_0","end_time":"20.7"},{"start_time":"20.709","speaker_label":"spk_0","end_time":"20.959"},{"start_time":"20.969","speaker_label":"spk_0","end_time":"21.12"}]},{"start_time":"21.129","speaker_label":"spk_1","end_time":"22.84","items":[{"start_time":"21.129","speaker_label":"spk_1","end_time":"21.149"},{"start_time":"21.159","speaker_label":"spk_1","end_time":"21.579"},{"start_time":"21.59","speaker_label":"spk_1","end_time":"21.729"},{"start_time":"21.739","speaker_label":"spk_1","end_time":"21.969"},{"start_time":"21.979","speaker_label":"spk_1","end_time":"22.19"},{"start_time":"22.2","speaker_label":"spk_1","end_time":"22.84"}]},{"start_time":"24.77","speaker_label":"spk_0","end_time":"25.35","items":[{"start_time":"24.77","speaker_label":"spk_0","end_time":"25.25"}]}]},"items":[{"start_time":"0.009","speaker_label":"spk_0","end_time":"0.579","alternatives":[{"confidence":"0.995","content":"Hey"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"0.589","speaker_label":"spk_0","end_time":"0.8","alternatives":[{"confidence":"0.997","content":"but"}],"type":"pronunciation"},{"start_time":"0.81","speaker_label":"spk_0","end_time":"0.99","alternatives":[{"confidence":"0.997","content":"I'm"}],"type":"pronunciation"},{"start_time":"1.0","speaker_label":"spk_0","end_time":"1.269","alternatives":[{"confidence":"0.999","content":"going"}],"type":"pronunciation"},{"start_time":"1.279","speaker_label":"spk_0","end_time":"1.46","alternatives":[{"confidence":"0.997","content":"into"}],"type":"pronunciation"},{"start_time":"1.47","speaker_label":"spk_0","end_time":"1.779","alternatives":[{"confidence":"0.997","content":"this"}],"type":"pronunciation"},{"start_time":"1.789","speaker_label":"spk_0","end_time":"2.569","alternatives":[{"confidence":"0.997","content":"very"}],"type":"pronunciation"},{"start_time":"2.579","speaker_label":"spk_0","end_time":"3.24","alternatives":[{"confidence":"0.997","content":"humble"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"3.349","speaker_label":"spk_0","end_time":"4.119","alternatives":[{"confidence":"0.998","content":"smart"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"4.13","speaker_label":"spk_0","end_time":"4.78","alternatives":[{"confidence":"0.998","content":"smart"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"5.07","speaker_label":"spk_0","end_time":"5.619","alternatives":[{"confidence":"0.507","content":"I"}],"type":"pronunciation"},{"start_time":"5.63","speaker_label":"spk_0","end_time":"6.07","alternatives":[{"confidence":"0.997","content":"mean"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"6.079","speaker_label":"spk_0","end_time":"6.09","alternatives":[{"confidence":"0.998","content":"I"}],"type":"pronunciation"},{"start_time":"6.099","speaker_label":"spk_0","end_time":"6.309","alternatives":[{"confidence":"0.998","content":"don't"}],"type":"pronunciation"},{"start_time":"6.32","speaker_label":"spk_0","end_time":"6.429","alternatives":[{"confidence":"0.999","content":"think"}],"type":"pronunciation"},{"start_time":"6.44","speaker_label":"spk_0","end_time":"6.449","alternatives":[{"confidence":"0.999","content":"I"}],"type":"pronunciation"},{"start_time":"6.46","speaker_label":"spk_0","end_time":"6.769","alternatives":[{"confidence":"0.998","content":"have"}],"type":"pronunciation"},{"start_time":"6.78","speaker_label":"spk_0","end_time":"7.079","alternatives":[{"confidence":"0.998","content":"that"}],"type":"pronunciation"},{"start_time":"7.09","speaker_label":"spk_0","end_time":"7.289","alternatives":[{"confidence":"0.996","content":"high"}],"type":"pronunciation"},{"start_time":"7.3","speaker_label":"spk_0","end_time":"7.46","alternatives":[{"confidence":"0.996","content":"of"}],"type":"pronunciation"},{"start_time":"7.469","speaker_label":"spk_0","end_time":"7.48","alternatives":[{"confidence":"0.996","content":"a"}],"type":"pronunciation"},{"start_time":"7.489","speaker_label":"spk_0","end_time":"7.71","alternatives":[{"confidence":"0.995","content":"pain"}],"type":"pronunciation"},{"start_time":"7.719","speaker_label":"spk_1","end_time":"8.329","alternatives":[{"confidence":"0.996","content":"tolerance"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"8.56","speaker_label":"spk_1","end_time":"8.77","alternatives":[{"confidence":"0.995","content":"Well"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"8.779","speaker_label":"spk_1","end_time":"8.8","alternatives":[{"confidence":"0.998","content":"I"}],"type":"pronunciation"},{"start_time":"8.81","speaker_label":"spk_1","end_time":"9.05","alternatives":[{"confidence":"0.999","content":"guess"}],"type":"pronunciation"},{"start_time":"9.06","speaker_label":"spk_1","end_time":"9.25","alternatives":[{"confidence":"0.996","content":"we'll"}],"type":"pronunciation"},{"start_time":"9.26","speaker_label":"spk_1","end_time":"9.56","alternatives":[{"confidence":"0.999","content":"find"}],"type":"pronunciation"},{"start_time":"9.569","speaker_label":"spk_1","end_time":"9.789","alternatives":[{"confidence":"0.999","content":"out"}],"type":"pronunciation"},{"start_time":"9.8","speaker_label":"spk_1","end_time":"10.34","alternatives":[{"confidence":"0.998","content":"today"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"10.35","speaker_label":"spk_1","end_time":"10.77","alternatives":[{"confidence":"0.996","content":"Are"}],"type":"pronunciation"},{"start_time":"10.779","speaker_label":"spk_1","end_time":"10.85","alternatives":[{"confidence":"0.997","content":"you"}],"type":"pronunciation"},{"start_time":"10.859","speaker_label":"spk_1","end_time":"11.069","alternatives":[{"confidence":"0.999","content":"ready"}],"type":"pronunciation"},{"start_time":"11.079","speaker_label":"spk_1","end_time":"11.149","alternatives":[{"confidence":"0.997","content":"to"}],"type":"pronunciation"},{"start_time":"11.159","speaker_label":"spk_1","end_time":"11.31","alternatives":[{"confidence":"0.999","content":"get"}],"type":"pronunciation"},{"start_time":"11.319","speaker_label":"spk_1","end_time":"11.939","alternatives":[{"confidence":"0.999","content":"started"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"?"}],"type":"punctuation"},{"start_time":"11.949","speaker_label":"spk_0","end_time":"12.119","alternatives":[{"confidence":"0.974","content":"Yeah"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"12.13","speaker_label":"spk_0","end_time":"12.739","alternatives":[{"confidence":"0.995","content":"Sure"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"20.09","speaker_label":"spk_0","end_time":"20.139","alternatives":[{"confidence":"0.918","content":"Oh"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"20.149","speaker_label":"spk_0","end_time":"20.409","alternatives":[{"confidence":"0.985","content":"we're"}],"type":"pronunciation"},{"start_time":"20.42","speaker_label":"spk_0","end_time":"20.7","alternatives":[{"confidence":"0.996","content":"going"}],"type":"pronunciation"},{"start_time":"20.709","speaker_label":"spk_0","end_time":"20.959","alternatives":[{"confidence":"0.996","content":"right"}],"type":"pronunciation"},{"start_time":"20.969","speaker_label":"spk_0","end_time":"21.12","alternatives":[{"confidence":"0.996","content":"to"}],"type":"pronunciation"},{"start_time":"21.129","speaker_label":"spk_1","end_time":"21.149","alternatives":[{"confidence":"0.461","content":"the"}],"type":"pronunciation"},{"start_time":"21.159","speaker_label":"spk_1","end_time":"21.579","alternatives":[{"confidence":"0.995","content":"left"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"21.59","speaker_label":"spk_1","end_time":"21.729","alternatives":[{"confidence":"0.995","content":"Yeah"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":","}],"type":"punctuation"},{"start_time":"21.739","speaker_label":"spk_1","end_time":"21.969","alternatives":[{"confidence":"0.99","content":"that's"}],"type":"pronunciation"},{"start_time":"21.979","speaker_label":"spk_1","end_time":"22.19","alternatives":[{"confidence":"0.995","content":"very"}],"type":"pronunciation"},{"start_time":"22.2","speaker_label":"spk_1","end_time":"22.84","alternatives":[{"confidence":"0.996","content":"important"}],"type":"pronunciation"},{"speaker_label":"spk_1","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"},{"start_time":"24.77","speaker_label":"spk_0","end_time":"25.25","alternatives":[{"confidence":"0.99","content":"Ok"}],"type":"pronunciation"},{"speaker_label":"spk_0","alternatives":[{"confidence":"0.0","content":"."}],"type":"punctuation"}]},"status":"COMPLETED"}""";

    Conversation recording1 = Conversation(
        id: 'c74dcec0-6fb7-45a9-98da-472e13413dd8',
        audioFilePath: 'path',
        duration: Duration(minutes: 1),
        recordedDate: DateTime.now().add(-Duration(hours: 1)),
        title: 'Description A',
        transcript: transcript1,
        customDescription: 'Description',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');
    Conversation recording2 = Conversation(
        id: '0a60bf00-a057-4ad7-87fd-534c7d407160',
        audioFilePath: 'path',
        duration: Duration(minutes: 2),
        recordedDate: DateTime.now().add(-Duration(hours: 4)),
        title: 'Description B',
        transcript: '''spk_0: Do I dare ask?

spk_1: Yes, I'll start with the carpaccio and then I'll have the grilled prawns. 

spk_2: That sounds great. Same for me.

spk_0: And for the gentleman?

spk_3: Yeah, I'll have the Thai chicken pizza.But hey, look, if I get it without the nuts and leaks and stuff, is it cheaper?

spk_0: You'd think.  How about you miss?

spk_4: Okay, I will have the side salad.

spk_0: And would that be on the side of it?

spk_4: I don't know. Why don't you just put it right here next to my water?

spk_0: And for you?

spk_5: I'm going to have a cup of the cucumber soup.

spk_6: I will have the cajun cat fish. 

spk_0: Anything else?''',
        customDescription: 'Description',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');
    Conversation recording3 = Conversation(
        id: 'e3bc7acc-3b20-4056-94b6-6199fdba5870',
        audioFilePath: 'path',
        duration: Duration(minutes: 5),
        recordedDate: DateTime.now().add(-Duration(hours: 2)),
        title: 'Description C',
        transcript:
            '''spk_0: Make sure you take your medication every morning at 08:00 a.m. and every evening at 07:00 p.m..

spk_1: Set my alarm for 08:00 a.m. Monday through Friday and 09:00 a.m. Saturday and Sunday.  When I wake up, remind me that I'm staying in the memory care Village, room 312, and I need the day and the date for that day.

spk_0: Remember to call your kids on Saturdays at 10:00 a.m.

spk_1: Remind me every day at 04:30 p.m. that dinner is in the cafeteria at 05:00. It's down the hall and to the left.''',
        customDescription: 'Description',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');
    Conversation recording4 = Conversation(
        id: '866731c8-a9cd-408c-ae04-886f31a42493',
        audioFilePath: 'path',
        duration: Duration(minutes: 3),
        recordedDate: DateTime.now().add(-Duration(hours: 3)),
        title: 'Description D',
        transcript: '''Remind me to prepare for a meeting on Thursdays at 9 a.m. The meeting will start at 10 a.m. This is on cloud meeting.''',
        customDescription: 'Description',
        gptDescription: '',
        gptReminders: '''Reminder 1: 2023-07-13T08:00, Prepare for Thursday's meeting at 9 a.m.\nReminder 2: 2023-07-13T10:00, Start the cloud meeting''',
        gptFoodOrder: '');
    Conversation recording5 = Conversation(
        id: 'e7cb2be9-75f2-44a0-9976-df7dfc0e1363',
        audioFilePath: 'path',
        duration: Duration(minutes: 1),
        recordedDate: DateTime.now().add(-Duration(hours: 1)),
        title: 'Description E',
        transcript: '',
        customDescription: 'Description',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');
    Conversation recording6 = Conversation(
        id: '173d6dc0-fb47-4284-bd09-9465177f8eea',
        audioFilePath: 'path',
        duration: Duration(minutes: 1),
        recordedDate: DateTime.now().add(-Duration(hours: 1)),
        title: 'George Washington Bio',
        transcript:
            '''My name is George Washington and I cannot tell a lie. My email address is george_washington@aol.com. My password is Marietta1. 
The following is a short biography about my life.
George Washington was born at his family's plantation on Popes Creek in Westmoreland County, Virginia, on February 22, 1732, to Augustine and Mary Ball Washington. George's father was a leading planter in the area and served as a justice of the county court.

Augustine Washington's first wife, Jane Butler, died in 1729, leaving him with two sons, Lawrence and Augustine, Jr., and a daughter, Jane. George was the eldest of Augustine and Mary's six children: George, Elizabeth, Samuel, John Augustine, Charles, and Mildred.

Ferry Farm
Around 1734, the family moved up the Potomac River to another Washington property, Little Hunting Creek Plantation (later renamed Mount Vernon). In 1738, they moved again to Ferry Farm, a plantation on the Rappahannock River near Fredericksburg, Virginia, where George spent much of his youth.

Little is known of George Washington's childhood, and it remains the most poorly understood part of his life. When he was eleven years old, his father Augustine died, leaving most of his property to George's adult half brothers. The income from what remained was just sufficient to maintain Mary Washington and her children. As the oldest of Mary's children, George undoubtedly helped his mother manage the Rappahannock River plantation where they lived. There he learned the importance of hard work and efficiency.

Washington's Education
Unlike many of his contemporaries, Washington never attended college or received a formal education. His two older half brothers, Lawrence and Augustine, attended Appleby Grammar School in England. However, after the death of their father, the family limited funds for education. Private tutors and possibly a local school in Fredericksburg provided George and his siblings with the only formal instruction he would receive.

In addition to reading, writing, and basic legal forms, George studied geometry and trigonometry—in preparation for his first career as a surveyor—and manners—which would shape his character and conduct for the rest of his life.''',
        customDescription: 'Description',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');
    Conversation recording7 = Conversation(
        id: 'cff13755-0a90-4f90-975f-fe9f5a13fcd5',
        audioFilePath: 'path',
        duration: Duration(minutes: 1),
        recordedDate: DateTime.now().add(-Duration(hours: 1)),
        title: 'UMGC Admissions Information',
        transcript:
            '''My name is John Doe and I want to apply for admission to the University of Maryland Global Campus Graduate degree program. I like computers so I was thinking a degree in IT would be the way to go. I am interested in security and have done some penetration testing at work, and would like to pursue those interests further. I am a vetaran, serving in the Air Force for 4 years. I live at 4321 Cypress St, Eastern Shore, Maryland. My email address is john_doe_iii@gmail.com.''',
        customDescription: '',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');
    Conversation recording8 = Conversation(
        id: 'cff13755-0a90-4f90-975f-fe9f5a13fcd7',
        audioFilePath: 'path',
        duration: Duration(minutes: 1),
        recordedDate: DateTime.now().add(-Duration(hours: 1)),
        title: 'Work History Part 1',
        transcript:
            '''My previous job I worked with Auto Blitz, an auto parts reseller. Auto Blitz is located
            at 24362 Latitude Pl, Oxgarden, Massachusetts, zip code 01520.  I was a shift supervisor 
            working full time, and I worked there from May 2018 to April 2023. 
            As a shift supervisor I oversaw the daily activities and how employees perform during their shift. I
            was responsible for maximizing customer satisfaction through handling requests or complaints. I was 
            also in charge of maintaining a tidy and organized workspace stocked with essential supplies, while 
            ensuring that production or service runs smoothly. I received a commendation and award during the month
            of June 2021 for maintaining outstanding productivity and safety during the shift I oversaw.''',
        customDescription: '',
        gptDescription: '',
        gptReminders: '',
        gptFoodOrder: '');

    List<Conversation> sampleRecordingList = [
      recording1,
      recording2,
      recording3,
      recording4,
      recording5,
      recording6,
      recording7,
      recording8
    ];

    return sampleRecordingList;
  }
}
