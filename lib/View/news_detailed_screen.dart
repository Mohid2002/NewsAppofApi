import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newImage,newsTitle,NewsDate,auther,description,content,source;
  NewsDetailScreen({super.key,
    required this.newImage,
    required this.newsTitle,
    required this.NewsDate,
    required this.auther,
    required this.description,
    required this.content,
    required this.source
  });


  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMMM dd,yyyy');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    DateTime dateTime = DateTime.parse(widget.NewsDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height*.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newImage,
                fit: BoxFit.cover,
                placeholder: (context,url)=>Center(child: CircularProgressIndicator(),),
              ),
            ),
          ),
          Container(
            height: size.height*.6,
            margin: EdgeInsets.only(top: size.height*.4),
            padding: EdgeInsets.only(top: 20,left: 20,right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(

              children: [
                Text(widget.newsTitle,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black87,fontWeight: FontWeight.w700),),
                SizedBox(height: size.height*.02,),
                Row(children: [
                  Expanded(child: Text(widget.source,style: GoogleFonts.poppins(fontSize: 13,color: Colors.blue,fontWeight: FontWeight.w600),)),
                  Text(format.format(dateTime),style: GoogleFonts.poppins(fontSize: 10,color: Colors.black87,fontWeight: FontWeight.w600),),
                ],),
                SizedBox(height: size.height*.03,),
                Text(widget.description,style: GoogleFonts.poppins(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w500),),
              ],
            ),
          )
        ],

      ),
    );
  }
}