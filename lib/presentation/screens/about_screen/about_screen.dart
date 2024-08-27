import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                """     ကျွန်ုပ်တို့ application သည် လယ်သမား  များကြားတွင်လယ်ယာစိုက်ပျိုး‌ရေးနှင့်ပတ်သတ်သောသတင်းအချက်အလက်များကိုမျှဝေခြင်းဖြင့် ချိတ်ဆက်ပေးမည့်    Application ဖြစ်သည်။လယ်သမားအချင်းချင်း အသိပညာ၊အတတ်ပညာများ မျှဝေနိုင်သော ကျွန်တော်တို့Applicationသည် လယ်ယာစိုက်ပျိုးရေးလုပ်ငန်းများအတွက် ပိုမိုကောင်းမွန်သောဝန်ဆောင်မှုများကို ဖန်တီးပေးနိုင်မည်ဖြစ်ပါသည်။ လယ်သမားများအတွက်လဲ မိမိနေရာမှာတင်လယ်ယာစိုက်ပျိိုးရေးနဲ့ပတ်သက်သောအသိပညာအမျိုးမျိုးကို လွယ်ကူစွာလေ့လာနိုင်ပီးလယ်ယာစိုက်ပျိုးရေးနဲ့ပတ်သက်သော သတင်းအချက်အလက်များကိုလဲ up-to-date သိရှိနိုင်ပါသည်။ကျွန်တော်တို့၏ ခေတ်မီသောFarmerHub Application ဖြင့်သင့်ရဲ့ လယ်ယာစိုက်ပျိိုးရေးလုပ်ငန်းအား အောင်မြင်မှုကိုချဲ့ထွင်နိုင်ပါသည်။""",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  // color: Theme.of(context).primaryColor,

                  wordSpacing: 1,
                  height: 2,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "FarmerHub Application ဖန်တီးရခြင်း ရည်ရွယ်ချက်များ",
                style: TextStyle(
                    // color: Theme.of(context).primaryColor,
                    wordSpacing: 1,
                    height: 1.5,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "    အဓိကရည်ရွယ်ချက်မှာလယ်သမားများအ‌နေဖြင့်လူကိုယ်တိုင်သီးနှံကုန်ကြမ်းများနှင့်လယ်ယာစိုက်ပျိုးရေးဆိုင်ရာပစ္စည်းများကိုနယ်လှည့်ရှာဖွေစရာမလိုအပ်ပဲကျွန်တော်တို့Applicationကိုအသုံးပြုခြင်းဖြင့်ပိုမိုမြန်ဆန်တိကျ၍အချိန်ကုန်သက်သာစေပြီးလယ်သမားများအနေဖြင့်မိမိလုပ်ငန်းအားပိုမိုတိုးတက်ကြီးပွားစေရန်ဖြစ်ပါသည်။",
                textAlign: TextAlign.justify,
                style: TextStyle(wordSpacing: 1, height: 2),
              ),
              const SizedBox(height: 20),
              const Text(
                "စည်းမျဉ်းစည်းကမ်းများအကြောင်း",
                style: TextStyle(
                    // color: Theme.of(context).primaryColor,
                    wordSpacing: 1,
                    height: 1.5,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "       ကျွန်ုပ်တို့ applicationတွင် မစီလျှော် မသင့်တော်သောမန့်များမန့်ခြင်း/ပို့များတင်ခြင်းပြုလုပ်ပါက ထိုသူအား help center မှတဆင့်တိုင်ကြားနိုင်သည်။ထို့နောက်ကျွန်ုပ်တို့  Admin Team ဘက်မှထိုသူအား စစ်ဆေးမှုများပြုလုပ်ဲပြီး သက်မှတ်ထားသော စည်းကမ်းများနှင့်မကိုက်ညီပါက Comment permission ပိတ်ခြင်း Post permissionပိတ်ခြင်းများဖြင့်အပစ်ပေးအရေးယူ ခြင်းများ ပြုလုပ်သွားမည်ဖြစ်သည်။",
                textAlign: TextAlign.justify,
                style: TextStyle(wordSpacing: 1, height: 2),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Any Problem,contact me ").tr(),
                    InkWell(
                      child: const Text(
                        "hhtz12450@gmail.com",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'hhtz12450@gmail.com',
                          query: encodeQueryParameters(<String, String>{
                            'subject':
                                'Help me and explain  about this problem.',
                          }),
                        );

                        launchUrl(emailLaunchUri);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
