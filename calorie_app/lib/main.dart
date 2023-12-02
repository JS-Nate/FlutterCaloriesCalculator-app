import 'package:flutter/material.dart';







void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date Picker App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  double _sliderValue = 0.0;
  Map<DateTime, double> _sliderValuesMap = {};
  Map<DateTime, List<FoodItem>> _selectedFoodsMap = {};

  // Sample food data
  List<FoodItem> _foodItems = [
    FoodItem(name: 'Apple', calories: 95),
    FoodItem(name: 'Banana', calories: 105),
    FoodItem(name: 'Chicken Breast', calories: 165),
    FoodItem(name: 'Salad', calories: 50),
    FoodItem(name: 'Pasta (1 cup)', calories: 200),
    FoodItem(name: 'Cheeseburger', calories: 300),
    FoodItem(name: 'Pizza (1 slice)', calories: 285),
    FoodItem(name: 'Brown Rice (1 cup)', calories: 215),
    FoodItem(name: 'Grilled Salmon', calories: 206),
    FoodItem(name: 'Greek Yogurt (1 cup)', calories: 150),
    FoodItem(name: 'Oatmeal (1 cup)', calories: 150),
    FoodItem(name: 'Almonds (1 ounce)', calories: 160),
    FoodItem(name: 'Avocado', calories: 234),
    FoodItem(name: 'Egg (1 large)', calories: 70),
    FoodItem(name: 'Orange', calories: 62),
    FoodItem(name: 'Carrot (1 medium)', calories: 25),
    FoodItem(name: 'Broccoli (1 cup)', calories: 31),
    FoodItem(name: 'Quinoa (1 cup)', calories: 222),
    FoodItem(name: 'Strawberries (1 cup)', calories: 50),
    FoodItem(name: 'Spinach (1 cup)', calories: 7),
    
  ];

  double calculateTotalCalories() {
    List<FoodItem>? selectedFoods = _selectedFoodsMap[_selectedDate];

    if (selectedFoods != null) {
      // Calculate the total calories for the selected foods
      return selectedFoods.fold(0.0, (sum, foodItem) => sum + foodItem.calories);
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calories Calculator'),
      ),
      // on screen display for all the buttons and numerical information
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            Text(
              _selectedDate != null
                  ? 'Selected Date: ${_selectedDate.toLocal()}'
                  : 'No date selected',
            ),
            SizedBox(height: 20),
            Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              min: 0,
              max: 1500,
              divisions: 75,
              label: _sliderValue.round().toString(),
            ),
            SizedBox(height: 20),
            Text(
              'Target Calories: ${_sliderValuesMap[_selectedDate]?.toStringAsFixed(2) ?? "N/A"}',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSliderValue();
              },
              child: Text('Save Calorie Target'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showFoodListDialog(context);
              },
              child: Text('Show Meal Plan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectFoodItems(context);
              },
              child: Text('Select Food Items'),
            ),
            SizedBox(height: 20),
            Text(
              'Total Calories: ${calculateTotalCalories()}',
            ),
          ],
        ),
      ),
    );
  }








  // method for selecting the calendar and choosing a date and time to display
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _sliderValue = _sliderValuesMap[_selectedDate] ?? 0.0;
      });
    }
  }

  void _saveSliderValue() {
    setState(() {
      _sliderValuesMap[_selectedDate] = _sliderValue;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Slider value saved for ${_selectedDate.toLocal()}'),
      ),
    );
  }










  // shows the list of food the user has added for the selected date's meal plan and their calories
  Future<void> _showFoodListDialog(BuildContext context) async {
    List<FoodItem>? selectedFoods = _selectedFoodsMap[_selectedDate];
    double? sliderValue = _sliderValuesMap[_selectedDate];

    double totalCalories = calculateTotalCalories();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details for ${_selectedDate.toLocal()}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Calorie target today: $sliderValue'),
              SizedBox(height: 10),
              Text('Total Calories: $totalCalories'),
              SizedBox(height: 10),
              Text('Food Items:'),
              selectedFoods != null && selectedFoods.isNotEmpty
                  ? Column(
                      children: selectedFoods
                          .map(
                            (foodItem) => ListTile(
                              title: Text('${foodItem.name} - ${foodItem.calories} calories'),
                              subtitle: ElevatedButton(
                                onPressed: () {
                                  _removeFoodItem(foodItem);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Remove'),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Text('No food items selected for ${_selectedDate.toLocal()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
// lets the s\user remove items from the list
void _removeFoodItem(FoodItem foodItem) {
  setState(() {
    _selectedFoodsMap[_selectedDate]?.remove(foodItem);
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Removed ${foodItem.name} from ${_selectedDate.toLocal()}'),
    ),
  );
}




  




// menu to let the user choose the foods to add to their meal plan
Future<void> _selectFoodItems(BuildContext context) async {
  List<FoodItem>? selectedFoods = await showDialog<List<FoodItem>>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Food Items'),
        content: SizedBox(
          height: 200,
          width: 300,
          child: ListView.builder(
            itemCount: _foodItems.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                title: Text('${_foodItems[index].name} - ${_foodItems[index].calories} calories'),
                value: _selectedFoodsMap[_selectedDate]?.contains(_foodItems[index]) ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        double currentCalories = calculateTotalCalories();
                        double newCalories = currentCalories + _foodItems[index].calories;

                        if (_sliderValuesMap[_selectedDate] == null ||
                            newCalories <= _sliderValuesMap[_selectedDate]!) {
                          _selectedFoodsMap[_selectedDate] ??= [];
                          _selectedFoodsMap[_selectedDate]!.add(_foodItems[index]);
                        } else {
                          // Exceeds the target calories value, don't add the item
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Cannot Add Food Item'),
                                content: Text(
                                  'Adding this food item would exceed the calorie target for ${_selectedDate.toLocal()}.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        _selectedFoodsMap[_selectedDate]?.remove(_foodItems[index]);
                      }
                    }
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedFoodsMap[_selectedDate]);
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );

// displays the list of food saved in the database for a given date
  if (selectedFoods != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Food items saved for ${_selectedDate.toLocal()}'),
      ),
    );
  }
}













}



// displays the list of food's name and calories
class FoodItem {
  final String name;
  final int calories;

  FoodItem({required this.name, required this.calories});
}