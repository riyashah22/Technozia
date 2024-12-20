import 'package:flutter/material.dart';
import 'package:technozia/constants/global_variables.dart';
import 'package:technozia/models/post.dart';
import 'package:technozia/services/auth_services.dart';

class ViewPostScreen extends StatefulWidget {
  static const String routeName = '/view-post-screen';
  const ViewPostScreen({super.key});

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  AuthServices authServices = AuthServices();
  List<Post>? post;
  @override
  void initState() {
    super.initState();
    getAllPost();
  }

  void getAllPost() async {
    post = await authServices.fetchAllPost(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVariables.bodyBackgroundColor,
        appBar: AppBar(
          backgroundColor: GlobalVariables.appBarColor,
          title: Text(
            "Posts",
            style: TextStyle(color: GlobalVariables.appBarContentColor),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    getAllPost();
                  });
                },
                icon: Icon(
                  Icons.refresh,
                  color: GlobalVariables.appBarContentColor,
                ))
          ],
        ),
        body: post == null
            ? const Center(child: CircularProgressIndicator())
            : post!.isEmpty
                ? Center(
                    child: Text(
                      "Announcements are coming soon,            stay tuned !!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: GlobalVariables.richBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return postItem(post![index]);
                      },
                      itemCount: post?.length,
                    ),
                  ));
  }

  Widget postItem(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xffedf6f9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/profile_icon.jpg",
                          ),
                          backgroundColor: Colors.blueGrey,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.username,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.richBlackColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              "@${post.type}",
                              style: TextStyle(
                                color: GlobalVariables.richBlackColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    post.date.substring(0, 10),
                    style: TextStyle(
                      color: GlobalVariables.richBlackColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          const Divider(
            color: Colors.black45,
            indent: 20,
          ),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              post.title,
              style: TextStyle(
                fontSize: 24,
                color: GlobalVariables.richBlackColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            post.description,
            style: TextStyle(
              fontSize: 16,
              color: GlobalVariables.richBlackColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
