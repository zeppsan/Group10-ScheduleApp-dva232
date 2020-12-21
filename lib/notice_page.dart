import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class NotificationPage extends StatefulWidget {
  final Map notifications;
  final double appBarSize;

  NotificationPage({this.notifications, this.appBarSize});

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage>{
  bool menuOpen = false;
  OverlayEntry overlayEntry;
// var notifications = {'1': Note(title: 'MAA140', content:'Anmälan till tentan öppen'), '2' : Note(title: 'MAA140', content: 'Föreläsning 15 inställd')};

  void openMenu(){
   menuOpen = true;
  }

  void closeMenu(){
    menuOpen = false;
  }

 @override
  Widget build(BuildContext context) {
    print('notiser');
    return Stack(
      children: [
        Opacity(
          opacity: 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff2c1d33),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
        ),
        Center(
          child: ListView.builder(
            itemCount: widget.notifications.length,
            itemBuilder: (BuildContext context, int index){
             return Card(
                color: const Color(0xffeeb462),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(

                      title: Text(widget.notifications[index].title),
                      subtitle: Text(widget.notifications[index].content),
                      trailing: IconButton(
                          onPressed: (){
                          /*  noteList.removeAt(index);
                            setState(() {});
                            print(noteList.length.toString());*/
                          },
                          icon: Icon(Icons.check)),
                    )
                  ],
                ),
              );
             },
          ),
        ),
      ],
    );
  }
}


Widget NotificationIcon (int number, bool visible){
  if(number == 0){
    return  Badge(
      badgeColor: Colors.grey[400],
      badgeContent: Text(number.toString()),
      position: BadgePosition.bottomEnd(end: 6, bottom: 6),
      child: IconButton(
        onPressed: () { },
        icon: Icon(
          Icons.notifications_none_rounded,
          color:  const Color(0xffdfb15b),
        ),
      ),
    );
  }
 /* else {
    Badge(
      badgeColor: Colors.red[400],
      badgeContent: Text(notifications.toString()),
      position: BadgePosition.bottomEnd(end: 6, bottom: 6),
      child: IconButton(
        onPressed: () {
          print('onpressed');
          if (!visible)
            showNotification();
          else
            hideNotification();
        },
        icon: Icon(
          Icons.notifications_none_rounded,
          color:  const Color(0xffdfb15b),
        ),
      ),
    ),
  }*/
}