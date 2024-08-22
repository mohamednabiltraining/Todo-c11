import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/database/collections/TasksCollection.dart';
import 'package:todo_c11/database/collections/UsersCollection.dart';
import 'package:todo_c11/database/models/Task.dart';
import 'package:todo_c11/providers/AuthProvider.dart';
import 'package:todo_c11/providers/TasksProvider.dart';
import 'package:todo_c11/ui/DialogUtils.dart';
import 'package:todo_c11/ui/common/DateTimeField.dart';
import 'package:todo_c11/ui/common/MaterialTextFormField.dart';
import 'package:todo_c11/AppDateUtils.dart';
class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var title = TextEditingController();
  var description = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialTextFormField(hint: "Task title",
            validator: (text) {
              if(text == null || text.trim().isEmpty){
                return "please enter task title";
              }
              return null;
            },
            controller: title,),
            MaterialTextFormField(hint: "Task Description",
              lines: 3,
              validator: (text) {
                if(text == null || text.trim().isEmpty){
                  return "please enter task description";
                }
                return null;
              },
              controller: description,
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                    child: DateTimeField(title: "Task Date", hint:
                    selectedDate == null?
                    "select date": "${selectedDate?.formatDate()}",
                      onClick: () {
                        showDatePickerDialog();
                      },

                    )),
                Expanded(
                    child: DateTimeField(title: "Task Time", hint:
                    selectedTime == null ?
                    "select time" : "${selectedTime?.formatTime()}",
                      onClick: () {
                        showTimePickerDialog();
                      },))
              ],
            ),
            ElevatedButton(onPressed: (){
              addTask();
            }, child: Text("AddTask"))
          ],
        ),
      ),
    );
  }

  DateTime? selectedDate;

  void showDatePickerDialog()async{
    var date = await showDatePicker(context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if(date==null)return;

    setState(() {
      selectedDate = date;
    });
  }

  TimeOfDay? selectedTime;

  void showTimePickerDialog()async {
    var time = await showTimePicker(context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),);
    if(time==null)return;
    setState(() {
      selectedTime = time;
    });
  }

  bool isValidTask(){
    bool isValid = true;
    if(formKey.currentState?.validate() == false){
      isValid = false;
    }
    if(selectedDate == null){
      showMessageDialog(context, message: "Please select task date",
          posButtonTitle: "ok");
      isValid = false;
    }
    if(selectedTime == null){
      showMessageDialog(context, message: "Please select task time",
          posButtonTitle: "ok");
      isValid = false;
    }
    return isValid;
  }
  void addTask()async{

    if(isValidTask()==false)return;

    var authProvider = Provider.of<AppAuthProvider>(context,listen: false);

    var tasksProvider =  Provider.of<TasksProvider>(context,listen: false);

    var task = Task(
      title: title.text,
      description: description.text,
      date: selectedDate?.dateOnly(),
      time: selectedTime?.timeSinceEpoch()
    );

    try{
      showLoadingDialog(context, message: "Adding task please wait");
      var result = await tasksProvider.addTask(authProvider.appUser?.authId ?? "", task);
      hideLoading(context);
      showMessageDialog(context, message: "Task added successfully",
          posButtonTitle: "ok",
      posButtonAction: (){
        Navigator.pop(context);
      });
     }catch(e){
      hideLoading(context);
      showMessageDialog(context, message: e.toString(),
      posButtonTitle: "ok");
    }


  }
}
