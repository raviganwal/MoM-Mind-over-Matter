import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:mom/widgets/components/appbar_design.dart';

class SummernoteScreen extends StatefulWidget {
  String? articleContent;

  SummernoteScreen({super.key, this.articleContent});
  @override
  _SummernoteScreenState createState() => _SummernoteScreenState();
}

class _SummernoteScreenState extends State<SummernoteScreen> {
  final GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  final String _title = "Dummy Title";
  final String _content =
      "<h1>Mental Wellbeing: Taking Care of Your Mind and Emotions</h1>	<article>		<p> 			Mental wellbeing is an essential aspect of our overall health and happiness. It involves taking care of our mind, emotions, and overall psychological well-being. The way we think, feel, and behave is interconnected, and when we neglect one of these areas, it can have negative effects on our mental and physical health. Therefore, it's crucial to pay attention to our mental wellbeing and take steps to maintain it. Here are some tips for achieving mental wellbeing: 		</p> 	<h2>1. Practice Mindfulness</h2>		<p>			Mindfulness is the practice of being present in the moment and paying attention to our thoughts and feelings without judgment. It can help reduce stress and anxiety, increase self-awareness, and improve overall well-being. There are many ways to practice mindfulness, such as meditation, deep breathing, or simply taking a walk in nature and being present in the moment.		</p>		<h2>2. Connect with Others</h2>	<p>			Human connection is vital for our mental health and wellbeing. Spending time with friends and family, joining a community group, or volunteering can all help us feel more connected and less isolated. It's important to prioritize social relationships and maintain them regularly.		</p>		<h2>3. Take Care of Your Body</h2>	<p>			Physical and mental health are interconnected. Taking care of your body can help improve your mental health as well. Exercise, healthy eating, getting enough sleep, and avoiding harmful substances like alcohol and drugs can all contribute to better mental wellbeing.	</p>		<h2>4. Practice Self-Care</h2>	<p>			Practicing self-care means taking time to do things that make you feel good and refreshed. This can be anything from taking a relaxing bath, reading a book, or practicing a hobby. It's essential to make time for yourself and prioritize your own needs and wants.	</p> 		<h2>5. Seek Professional Help if Needed</h2>		<p>			Finally, if you're struggling with your mental health, it's important to seek professional help. Mental health professionals can provide support, guidance, and treatment to help you improve your mental wellbeing. Don't hesitate to reach out if you need help.		</p>		<p>			In conclusion, mental wellbeing is crucial for our overall health and happiness. By practicing mindfulness, connecting with others, taking care of our body, practicing self-care, and seeking professional help if needed, we can all work towards achieving better mental wellbeing.	</p>	</article>";
  final String _imageUrl = "https://dummyimage.com/600x400/000/fff";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDesign(title: "", isLeading: true),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(12),
            child: FlutterSummernote(
              key: _keyEditor,
              value: _content,
              decoration: const BoxDecoration(color: Colors.transparent),
              showBottomToolbar: false,
              customToolbar: """[]""",
            )),
      ),
    );
  }
}
