import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_page.dart';
import 'package:http/http.dart' as http;
class TodoListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TodoListPageState();

}

class _TodoListPageState extends State<TodoListPage>{
  late bool isLoading=false;
  List items=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Todo List'),
    ),
    body: Visibility(
      visible: isLoading,
      replacement: Center(child: CircularProgressIndicator(),),
      child: RefreshIndicator(
        onRefresh: fetchData,
        child: Visibility(
          visible: items.isNotEmpty ,
          replacement: Center(child: Text("No item"),),
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context,index){
                final item=items[index]as Map;
                final id=item['_id'] as String;
                return ListTile(
                  leading:CircleAvatar(child: Text('${index+1}'),) ,
                  title: Text('${item['title']}',style: TextStyle(color: Colors.red),),
                  subtitle: Text('${item['description']}'),
                  trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value=='edit'){
                        navigateEditItem(item);
                      }if(value=='delete'){
                        print(id);
                           deleteById(id);
                      }
                    },
                    itemBuilder: (context){
                      return[
                        PopupMenuItem(child: Text('edit'),value: 'edit',),
                        PopupMenuItem(child: Text('delete'),value: 'delete',)
                      ];
                    },
                  ),
                );

              }),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          navigateToAddPage();
        },
        label: Text('Add Todo')),
  );
  }
 Future<void> navigateToAddPage()async {
    final route= MaterialPageRoute(
        builder: (context)=>AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchData();
  }
  Future<void> fetchData() async {
    setState(() {
      isLoading=false;
    });
    final url='https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri=Uri.parse(url);
    final respose=await http.get(uri);
    if(respose.statusCode==200){
      final json = jsonDecode(respose.body) as Map<String, dynamic>?;
      print("json ${json}");
      if (json != null) {

        final result = json['items'] as List;
        items = result;
        print(result);

      } else {
        // Xử lý trường hợp dữ liệu JSON là null
      }
    }
    setState(() {
      isLoading=true;
    });
  }
  Future<void> deleteById(String id)async {
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    final response= await http.delete(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // Xử lý trường hợp response không hợp lệ
      print('No delete');
    }

  }
 Future<void>  navigateEditItem(Map item)async {
   final route= MaterialPageRoute(
       builder: (context)=>AddTodoPage(todo:item));
   await Navigator.push(context, route);
 }
}