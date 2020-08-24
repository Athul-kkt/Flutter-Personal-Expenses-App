import 'package:flutter/material.dart';
import 'package:PaymentApp/dataClass.dart';
import 'package:intl/intl.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _chartValue(){
    double total=0;
    for(int j=0;j<7;j++){
      double sum=0;
      values[new DateFormat.E().format((new DateTime.now()).add(Duration(days:j)))]=0.0;
        for(int i=0;i<transactions.length;i++){
          if((new DateFormat('yMd').format(transactions[i].date))== (new DateFormat('yMd').format(new DateTime.now().subtract(Duration(days:j)))).toString()){
           sum=sum+transactions[i].amount;
           print(sum);
          }
          values[new DateFormat.E().format((new DateTime.now()).add(Duration(days:j)))]=sum;
        }
        total=total+sum;
        print(total);
        values['total']=total;
    }  
  
  }

  void _bottomSheet(){
     var _data = Data();
    var _datePicked=true;
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              focusedBorder: UnderlineInputBorder(
	              borderSide: BorderSide(color: Colors.purple),
              )
            ),
            onChanged: (value){
              _data.amount=double.parse(value) ;
              _data.total=int.parse(value);
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              focusedBorder: UnderlineInputBorder(
	              borderSide: BorderSide(color: Colors.purple),
              )
            ),
            onChanged: (value){
              _data.title=value;
            },
          ),
          ListTile(
            leading:_datePicked? 
                Text('No Date Choosen',
                style: TextStyle(
                  fontSize:20,color: Colors.grey
                  ),
                ) : Text(new DateFormat.yMMMMd('en_US').format(_data.date)),
            trailing: FlatButton(
              onPressed: (){
                showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(2001), 
                  lastDate: DateTime(2021),
                  initialDatePickerMode:  DatePickerMode.day,
                   builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData(
                          primarySwatch: Colors.purple, 
                          accentColor: Color(0xFCA311),
                          dialogBackgroundColor: Colors.white, 
                        ),
                        child: child,
                      );
                    },
                  ).then((value){
                    setState((){
                      _data.date=value;
                      _datePicked=false;
                     
                    });
                  });
              }, 
              child: Text('Choose Date',
                  style:TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                )
              )
          ),
          ListTile(
            trailing:   RaisedButton(
            color: Colors.purple,
            onPressed: (){ 
                print(values);
                _data.id=new DateTime.now().toString();
                transactions.add(_data);
                print(_data.date);
                print(new DateTime.now());
                setState(() {
                   _data.day =new DateFormat.E().format(_data.date);
                  Navigator.pop(context);
                });
                _chartValue();
            },
            child: Text(
              'Add Transaction',
              style: TextStyle(
                color: Colors.white,
                fontSize:20
              ),
            ),
            ),
          ),
        ],),
        );
      }
      );
  }   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.purple,
        title: Text('Personal Expenses'),
      ),
      body:Column(
        children: [
          Card(
            elevation: 5,
            child: 
            Container(
              height: 150,
              child: Center(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                 for(int i=6;i>=0;i--)   
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(values[
                        new DateFormat.E().format(
                          (new DateTime.now()).add(
                            Duration(days:i))
                          )
                        ]!=null?
                      '\u{20B9}'+values[
                        new DateFormat.E().format(
                          (new DateTime.now()).add(
                            Duration(days:i))
                          )
                        ].toString()
                      :'0',
                      style: TextStyle(fontWeight: FontWeight.bold),),
                     Stack(children: [
                        Container(
                        height:100,
                        width:6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(vertical:50),
                          height: values[
                            new DateFormat.E().format(
                              (new DateTime.now()).add(
                                Duration(days:i))
                              )
                            ]!=null? (values[
                            new DateFormat.E().format(
                              (new DateTime.now()).add(
                                Duration(days:i))
                              )
                            ])*(100/values['total']):0.0,
                          width:6,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: Colors.purple
                        ),

                        ),
                     ],

                     ),
                    Text(
                      new DateFormat.E().format(
                        (new DateTime.now()).subtract(
                          Duration(days:i))).substring(0,1),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    
                  ],)
                ],),
              )
              
            )
           
            ),

        new Expanded(child: 
        ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context,index){
          return  Card(
                  child: ListTile(
                    title:Text(transactions[transactions.length-index-1].title),
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Text('\u{20B9}${transactions[transactions.length-index-1].amount}',style: TextStyle(color:Colors.white),),
                    ),
                    subtitle: Text(new DateFormat.yMMMMd('en_US').format(transactions[transactions.length-index-1].date)),
                    trailing: IconButton(
                        icon: Icon(Icons.delete,color:Colors.red), 
                        onPressed: (){
                          setState(() {
                            transactions.removeAt(transactions.length-index-1);
                            _chartValue();
                          });
                        }
                        ),
                  ),
                );
                }
            ),)

      ],),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: _bottomSheet,
        tooltip: 'Add Item',
        child: Icon(Icons.add,color: Colors.black,),
      )
    );
  }
}

