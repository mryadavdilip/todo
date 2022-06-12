import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/CustomWidgets/CustomFormButton.dart';
import 'package:todo/CustomWidgets/CustomFormTextField.dart';
import 'package:todo/CustomWidgets/CustomToast.dart';
import 'package:todo/NavigationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _searchEditingController = TextEditingController();
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();

  ScrollController _taskListScrollController = ScrollController();

  List<int> selectedItems = [];
  List<String> selectedDocIds = [];

  int snapshotSize = 0;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedItems.isNotEmpty) {
          setState(() {
            selectedItems.clear();
          });
          return false;
        } else if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          _searchEditingController.text = '';
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _searchEditingController.text = '';
        },
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: Colors.blueGrey[100],
          drawer: SafeArea(
            child: Container(
              height: 812.h,
              width: 275.w,
              color: Colors.blueGrey,
              child: Column(
                children: [
                  Spacer(),
                  SizedBox(
                    width: 250.w,
                    child: MaterialButton(
                      height: 50.h,
                      color: Colors.blueGrey[100],
                      onPressed: () {
                        _auth.signOut().then(
                          (v) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationPage(),
                                ),
                                (route) => false);
                            toast(context, 'logged out successfully');
                          },
                        ).onError(
                          (error, stackTrace) {
                            toast(
                              context,
                              error.toString(),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Logout',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.logout,
                            size: 25.sp,
                            color: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          appBar: !_searchFocusNode.hasFocus
              ? AppBar(
                  backgroundColor: Colors.blueGrey[300],
                  foregroundColor: Colors.white,
                  title: Text(
                    'Task List',
                    style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    Visibility(
                        visible: selectedItems.isEmpty,
                        child: IconButton(
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(_searchFocusNode);
                            if (kDebugMode) {
                              print(
                                  'hasfocus: ${_searchFocusNode.hasFocus}, hasprimaryfocus: ${_searchFocusNode.hasPrimaryFocus}');
                            }
                          },
                          padding: EdgeInsets.zero,
                          splashRadius: 25.r,
                          icon: Icon(
                            Icons.search,
                            size: 25.sp,
                          ),
                        )),
                    Visibility(
                      visible: selectedItems.length == 1,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierColor: Colors.black26,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50.w, vertical: 200.h),
                                      child: Scaffold(
                                        resizeToAvoidBottomInset: false,
                                        backgroundColor: Colors.white,
                                        body: SizedBox(
                                          width: 275.w,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10.h),
                                              Text(
                                                'Edit Task',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              Container(
                                                height: 1.sp,
                                                width: 100.w,
                                                color: Colors.blueGrey,
                                              ),
                                              SizedBox(height: 30.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                child: Column(
                                                  children: [
                                                    CustomFormTextField(
                                                      controller:
                                                          _titleEditingController,
                                                      lableText: 'Title',
                                                      hintText: 'Title',
                                                    ),
                                                    SizedBox(height: 20.h),
                                                    CustomFormTextField(
                                                      controller:
                                                          _descriptionEditingController,
                                                      lableText: 'Description',
                                                      hintText:
                                                          'Title description',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 30.h),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w),
                                                child: Row(
                                                  children: [
                                                    CustomFormButton(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        _titleEditingController
                                                            .text = '';
                                                        _descriptionEditingController
                                                            .text = '';
                                                      },
                                                      height: 50,
                                                      width: 120,
                                                      title: 'Cancel',
                                                      outlined: true,
                                                    ),
                                                    Spacer(),
                                                    CustomFormButton(
                                                      onTap: () {
                                                        _firestore
                                                            .collection('users')
                                                            .doc(_auth
                                                                .currentUser!
                                                                .email)
                                                            .collection('tasks')
                                                            .doc(selectedDocIds[
                                                                0])
                                                            .update({
                                                          'title':
                                                              _titleEditingController
                                                                  .text,
                                                          'description':
                                                              _descriptionEditingController
                                                                  .text,
                                                        }).then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          _titleEditingController
                                                              .text = '';
                                                          _descriptionEditingController
                                                              .text = '';
                                                          setState(() {
                                                            selectedItems
                                                                .clear();
                                                            selectedDocIds
                                                                .clear();
                                                          });
                                                          toast(context,
                                                              'task edited');
                                                        }).onError((error,
                                                                stackTrace) {
                                                          toast(context,
                                                              error.toString());
                                                        });
                                                      },
                                                      height: 50,
                                                      width: 120,
                                                      title: 'Apply',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            padding: EdgeInsets.zero,
                            splashRadius: 25.r,
                            icon: Icon(
                              Icons.edit,
                              size: 25.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: selectedItems.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierColor: Colors.black26,
                              barrierDismissible: false,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50.w, vertical: 320.h),
                                  child: Scaffold(
                                    resizeToAvoidBottomInset: false,
                                    backgroundColor: Colors.white,
                                    body: SizedBox(
                                      width: 275.w,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10.h),
                                          Text(
                                            'Confirm delete',
                                            style: GoogleFonts.roboto(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                          Container(
                                            height: 1.sp,
                                            width: 100.w,
                                            color: Colors.blueGrey,
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Row(
                                              children: [
                                                CustomFormButton(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  height: 50,
                                                  width: 120,
                                                  title: 'Cancel',
                                                  outlined: true,
                                                ),
                                                Spacer(),
                                                CustomFormButton(
                                                  onTap: () {
                                                    CollectionReference doc =
                                                        _firestore
                                                            .collection('users')
                                                            .doc(_auth
                                                                .currentUser!
                                                                .email)
                                                            .collection(
                                                                'tasks');
                                                    try {
                                                      for (String id
                                                          in selectedDocIds) {
                                                        doc
                                                            .doc(id)
                                                            .delete()
                                                            .then((value) {
                                                          setState(() {
                                                            selectedItems
                                                                .clear();
                                                            selectedDocIds
                                                                .clear();
                                                          });
                                                          sortOrder();
                                                          toast(context,
                                                              'task deleted');
                                                        }).onError((error,
                                                                stackTrace) {
                                                          toast(context,
                                                              error.toString());
                                                        });
                                                      }
                                                      Navigator.pop(context);
                                                    } catch (e) {
                                                      toast(context,
                                                          e.toString());
                                                      if (kDebugMode) {
                                                        print(e);
                                                      }
                                                    }
                                                  },
                                                  height: 50,
                                                  width: 120,
                                                  title: 'Delete',
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        padding: EdgeInsets.zero,
                        splashRadius: 25.r,
                        icon: Icon(
                          Icons.delete,
                          size: 25.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                  ],
                )
              : PreferredSize(
                  preferredSize: Size(
                    375.w,
                    100.h,
                  ),
                  child: SafeArea(
                    child: Container(
                      height: 60.5.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 2.sp,
                          color: Colors.blueGrey,
                        ),
                      ),
                      child: TextField(
                        controller: _searchEditingController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        onEditingComplete: () {
                          _searchFocusNode.unfocus();
                          _searchEditingController.text = '';
                        },
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.blueGrey,
                        ),
                        cursorColor: Colors.blueGrey,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.w),
                          hintText: 'Search task',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            color: Colors.blueGrey[300],
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierColor: Colors.black26,
                  barrierDismissible: false,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 200.h),
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: Colors.white,
                        body: SizedBox(
                          width: 275.w,
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                'Add Task',
                                style: GoogleFonts.roboto(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Container(
                                height: 1.sp,
                                width: 100.w,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(height: 30.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  children: [
                                    CustomFormTextField(
                                      controller: _titleEditingController,
                                      lableText: 'Title',
                                      hintText: 'Title',
                                    ),
                                    SizedBox(height: 20.h),
                                    CustomFormTextField(
                                      controller: _descriptionEditingController,
                                      lableText: 'Description',
                                      hintText: 'Title description',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  children: [
                                    CustomFormButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                        _titleEditingController.text = '';
                                        _descriptionEditingController.text = '';
                                      },
                                      height: 50,
                                      width: 120,
                                      title: 'Cancel',
                                      outlined: true,
                                    ),
                                    Spacer(),
                                    CustomFormButton(
                                      onTap: () {
                                        _firestore
                                            .collection('users')
                                            .doc(_auth.currentUser!.email)
                                            .collection('tasks')
                                            .doc()
                                            .set({
                                          'title': _titleEditingController.text,
                                          'description':
                                              _descriptionEditingController
                                                  .text,
                                          'order': snapshotSize++,
                                        }).then((value) {
                                          Navigator.pop(context);
                                          _titleEditingController.text = '';
                                          _descriptionEditingController.text =
                                              '';
                                          toast(context, 'task added');
                                        }).onError((error, stackTrace) {
                                          toast(context, error.toString());
                                        });
                                      },
                                      height: 50,
                                      width: 120,
                                      title: 'Add',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            backgroundColor: Colors.blueGrey.withOpacity(0.8),
            foregroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 50.sp,
            ),
          ),
          body: SafeArea(
            child: Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: Colors.blueGrey),
              ),
              child: StreamBuilder(
                  stream: _firestore
                      .collection('users')
                      .doc(_auth.currentUser!.email)
                      .collection('tasks')
                      .orderBy('order', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        width: 375.w,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: ListView.builder(
                            controller: _taskListScrollController,
                            itemCount: snapshot.data!.size,
                            itemExtent: 80.h,
                            addSemanticIndexes: true,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot document =
                                  snapshot.data!.docs[index];
                              snapshotSize = snapshot.data!.size;
                              return InkWell(
                                onTap: () {
                                  _searchFocusNode.unfocus();
                                  _searchEditingController.text = '';
                                  if (selectedItems.isNotEmpty) {
                                    setState(() {
                                      if (selectedItems.contains(index)) {
                                        selectedItems.remove(index);
                                        selectedDocIds.remove(document.id);
                                      } else {
                                        selectedItems.add(index);
                                        selectedDocIds.add(document.id);
                                      }
                                    });

                                    if (kDebugMode) {
                                      print(
                                          'selectedItems: $selectedItems, selectedDocIds: $selectedDocIds');
                                    }
                                  }
                                },
                                onLongPress: () {
                                  _searchFocusNode.unfocus();
                                  _searchEditingController.text = '';
                                  setState(() {
                                    selectedItems.add(index);
                                    selectedDocIds.add(document.id);
                                  });

                                  if (kDebugMode) {
                                    print(
                                        'selectedItems: $selectedItems, selectedDocIds: $selectedDocIds');
                                  }
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: Container(
                                        height: 50.h,
                                        width: 300.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.r,
                                              offset: Offset(0, 2),
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${document['title']}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${document['description']}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: selectedItems.contains(index),
                                      child: Container(
                                        height: 50.h,
                                        width: 375.w,
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      toast(context, 'something went wrong!');
                      return Text(
                        'Something went wrong, pleaser try again later!',
                        style: GoogleFonts.roboto(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Future sortOrder() async {
    int i = 0;
    List orderList = [];
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.email)
        .collection('tasks')
        .orderBy('order')
        .get()
        .then((value) {
      for (var element in value.docs) {
        orderList.add(element.id);
      }
    });
    if (kDebugMode) {
      print('orderList $orderList');
    }
    for (var element in orderList) {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.email)
          .collection('tasks')
          .doc(element)
          .update({
        'order': i,
      });
      i++;
    }
  }
}
