import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newappofapi/Models/CategoriesNewsModel.dart';
import 'package:newappofapi/Models/NewsChannelsHeadlinesModel.dart';
import 'package:newappofapi/View/category_screen.dart';
import 'package:newappofapi/View/news_detailed_screen.dart';
import 'package:newappofapi/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {BBCNews,AryNews,GoogleNews,Bloomberg,CNN,AlJazeeraEnglish,}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd,yyyy');

  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesScreen()));},
          icon: Image.asset('Assets/category_icon.png',height: 30,width: 30,),),
        title: Text('News',style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w700),),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              onSelected: (FilterList item){
                if(FilterList.BBCNews.name==item.name){
                  name ='bbc-news';
                }
                else if(FilterList.AryNews.name==item.name){
                  name ='ary-news';
                }
                else if(FilterList.AlJazeeraEnglish.name==item.name){
                  name ='al-jazeera-english';
                }
                else if(FilterList.CNN.name==item.name){
                  name ='cnn';
                }
                else if(FilterList.GoogleNews.name==item.name){
                  name ='google-news';
                }
                else if(FilterList.Bloomberg.name==item.name){
                  name ='bloomberg';
                }
                setState(() {
                  selectedMenu =item;
                });
              },
              itemBuilder: (BuildContext context)=> <PopupMenuEntry<FilterList>>[
                PopupMenuItem<FilterList>(
                    value: FilterList.BBCNews,
                    child: Text('BBC News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.AryNews,
                    child: Text('ARY News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.AlJazeeraEnglish,
                    child: Text('Aljazeera News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.CNN,
                    child: Text('CNN News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.GoogleNews,
                    child: Text('Google News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.Bloomberg,
                    child: Text('Bloomberg News')),

              ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: size.height *.55,
            width: size.width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              builder: (BuildContext context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                }else{
                  return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                NewsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                auther: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString())));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: size.height * .6,
                                  width: size.width * .9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.height * .02,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context,url)=>Container(child: spinKit2,),
                                      errorWidget: (context,url,error)=>Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 15,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      height: size.height * .22,
                                      width: size.width *.75,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: size.width * 0.7,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(snapshot.data!.articles![index].title.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style:GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: size.width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:GoogleFonts.poppins(fontSize: 11,fontWeight: FontWeight.w600),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(format.format(dateTime),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.w500),),
                                                ),
                                              ],),)
                                        ],
                                      ),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                  newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  newsTitle: snapshot.data!.articles![index].title.toString(),
                                  NewsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  auther: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString())));
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    height: size.height * .18,
                                    width: size.width * .3,
                                    placeholder: (context, url) => Container(
                                      child: Center(
                                        child: SpinKitCircle(
                                          size: 50,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: size.height * .18,
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.blue),
                                              ),
                                            ),

                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
const spinKit2=SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
