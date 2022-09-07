import 'dart:js';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_cart/pages/landing_page.dart';
import 'package:english_cart/values/share_keys.dart';
import 'package:english_cart/models/english_today.dart';
import 'package:english_cart/packages/qoute_model.dart';
import 'package:english_cart/packages/quote.dart';
import 'package:english_cart/pages/control_page.dart';
import 'package:english_cart/values/app_assets.dart';
import 'package:english_cart/values/app_colors.dart';
import 'package:english_cart/values/app_styles.dart';
import 'package:english_cart/widgets/app_button.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_words_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  String quote = Quotes().getRandom().content!;

  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];
    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    print('before await');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('aftter await');

    int len = prefs.getInt(Sharekeys.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
    print('data');
  }

  EnglishToday getQuote(String noun) {
    Quote? qoute;
    qoute = Quotes().getByWord(noun);
    return EnglishToday(noun: noun, quote: qoute?.content, id: qoute?.id);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.secondColor,
        appBar: AppBar(
          backgroundColor: AppColors.secondColor,
          elevation: 0,
          title: Text(
            'English Today',
            style:
                AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
          ),
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Image.asset(AppAssets.menu),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: size.height * 1 / 10,
                alignment: Alignment.centerLeft,
                child: Text('$quote',
                    style: AppStyles.h5.copyWith(
                      fontSize: 12,
                      color: AppColors.textColor,
                    )),
              ),
              Container(
                height: size.height * 2 / 3,
                // color: AppColors.secondColor,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    String firstLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    firstLetter = firstLetter.substring(0, 1);

                    String leftLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    leftLetter = leftLetter.substring(1, leftLetter.length);
                    String quoteDefault =
                        'Thinh of all the beauty still left around yo and be happy.';
                    String qoute = words[index].quote != null
                        ? words[index].quote!
                        : quoteDefault;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        color: AppColors.primaryColor,
                        elevation: 4,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              setState(() {
                                words[index].isFavorite =
                                    !words[index].isFavorite;
                              });
                            });
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //     alignment: Alignment.centerRight,
                                //     child: Image.asset(
                                //       AppAssets.heart,
                                //       color: words[index].isFavorite
                                //           ? Color.fromARGB(255, 216, 49, 37)
                                //           : Colors.white,
                                //     )),
                                LikeButton(
                                  onTap: (bool isLiked) async {
                                    setState(() {
                                      words[index].isFavorite =
                                          !words[index].isFavorite;
                                    });
                                    return words[index].isFavorite;
                                  },
                                  isLiked: words[index].isFavorite,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  size: 42,
                                  circleColor: CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor:
                                        Color.fromARGB(255, 51, 229, 185),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return ImageIcon(
                                      AssetImage(AppAssets.heart),
                                      color: isLiked
                                          ? Color.fromARGB(255, 235, 59, 59)
                                          : Color.fromARGB(255, 255, 255, 255),
                                      size: 42,
                                    );
                                  },
                                ),
                                RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: firstLetter.toUpperCase(),
                                        style: TextStyle(
                                            fontFamily: FontFamily.sen,
                                            fontSize: 89,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6),
                                            ]),
                                        children: [
                                          TextSpan(
                                            text: leftLetter,
                                            style: TextStyle(
                                                fontFamily: FontFamily.sen,
                                                fontSize: 56,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                shadows: [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      offset: Offset(3, 6),
                                                      blurRadius: 6),
                                                ]),
                                          )
                                        ])),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: AutoSizeText(
                                    '"$qoute"',
                                    maxFontSize: 26,
                                    style: AppStyles.h4.copyWith(
                                        letterSpacing: 2,
                                        color: AppColors.textColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              //indicator
              _currentIndex >= 5
                  ? buildShowMore(context)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        height: size.height * 1 / 13,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          alignment: Alignment.center,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return buidIndndicator(
                                  index == _currentIndex, size);
                            },
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            print('exchange');
            setState(() {
              getEnglishToday();
            });
          },
          child: Image.asset(AppAssets.exchange),
        ),
        drawer: Drawer(
          child: Container(
            color: AppColors.lighBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 16),
                  child: Text('Your mind',
                      style: AppStyles.h3.copyWith(
                        color: AppColors.textColor,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: AppButton(
                      laber: 'Favorites',
                      onTap: () {
                        print('Favorites');
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: AppButton(
                      laber: 'Your control',
                      onTap: () {
                        print('Your control');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ControlPage(),
                            ));
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buidIndndicator(bool isAactive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: isAactive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
        color: isAactive ? AppColors.lighBlue : AppColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.black38, offset: Offset(2, 3), blurRadius: 3),
        ],
      ),
    );
  }

  Widget buildShowMore(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        alignment: Alignment.centerLeft,
        child: Material(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            elevation: 4,
            color: AppColors.primaryColor,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllWordsPage(
                              words: this.words,
                            )));
              },
              splashColor: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(24)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'Show more',
                  style: AppStyles.h5
                      .copyWith(color: AppColors.textColor, fontSize: 18),
                ),
              ),
            )));
  }
}
