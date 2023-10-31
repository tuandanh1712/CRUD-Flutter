import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddTodoPage extends StatefulWidget{
  Map? todo;
  AddTodoPage({super.key, this.todo});
  @override
  State<StatefulWidget> createState() => _AddTodoPageState();

}
class _AddTodoPageState extends State<AddTodoPage>{
  bool isEdit=false;
  TextEditingController titleControler=TextEditingController();
  TextEditingController descriptionControler=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.todo !=null){
     isEdit=true;
     final title= widget.todo?['title'];
     final description= widget.todo?['description'];
     titleControler.text=title;
     descriptionControler.text=description;
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: isEdit?Text('Edit Todo'):Text("Add Todo"),
     ),
     body: ListView(
       padding: EdgeInsets.all(20),
       children: [
         TextField(
           controller: titleControler,
           decoration: InputDecoration(hintText: "Title"),
         ),
         TextField(
           controller:descriptionControler ,
           decoration: InputDecoration(hintText: "Description"),
           minLines: 5,
           maxLines: 8,
           keyboardType: TextInputType.multiline,
         ),
         SizedBox(height: 20,),
         ElevatedButton(onPressed: isEdit ? updateData:submitData, child: Text(isEdit?"Update":"Submit"))
       ],
     ),
   );
  }
  Future<void> submitData() async {
    final title=titleControler.text;
    final description=descriptionControler.text;
    final body={
      "title":title,
      "description":description,
      "is_completed":false
    };
    final url='https://api.nstack.in/v1/todos';
    final uri=Uri.parse(url);
    final response= await http.post(uri,
        headers: {"Content-Type":'application/json'},
        body: jsonEncode(body));
    if(response.statusCode==201){
      titleControler.text='';
      descriptionControler.text='';
      print("Sucess");
      showSuccessMessage('Created Success');
    }else{
      print(response.body);
      showErrorMessage("Created Faill");
    }
  }
  Future<void> updateData() async {
    final todo=widget.todo;

    if(todo==null){
      print("You can not call");
      return;
    }
    final id=todo['_id'];
    final body={
      "title":titleControler.text,
      "description":descriptionControler.text,
      "is_completed":false
    };
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    final response= await http.put(uri,
        headers: {"Content-Type":'application/json'},
        body: jsonEncode(body));
    if(response.statusCode==200){
      print("Sucess");
      showSuccessMessage('Updated Success');
    }else{
      print(response.body);
      showErrorMessage("Updated Faill");
    }
  }

  void showSuccessMessage(String message){
    final snackbar=SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  void showErrorMessage(String message){
    final snackbar=SnackBar(content: Text(message,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


}

