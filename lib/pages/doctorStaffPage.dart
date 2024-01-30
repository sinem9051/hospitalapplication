import 'package:flutter/material.dart';

class ObesityCalculatorPage extends StatefulWidget {
  const ObesityCalculatorPage({Key? key}) : super(key: key);

  @override
  _ObesityCalculatorPageState createState() => _ObesityCalculatorPageState();
}

enum Gender { Male, Female }

class _ObesityCalculatorPageState extends State<ObesityCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmiResult;
  String? _bmiCategory;
  Gender _selectedGender = Gender.Male;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    if (_formKey.currentState!.validate()) {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      final bmi = weight / ((height / 100) * (height / 100));

      setState(() {
        _bmiResult = bmi;
        if (bmi < 18.5) {
          _bmiCategory = 'Underweight';
        } else if (bmi < 25) {
          _bmiCategory = 'Normal weight';
        } else if (bmi < 30) {
          _bmiCategory = 'Overweight';
        } else {
          _bmiCategory = 'Obese';
        }
      });
    }
  }

  String _getDiagnosis() {
    if (_selectedGender == Gender.Male) {
      if (_bmiResult! < 18.5) {
        return 'You are underweight. Consider consulting a nutritionist.';
      } else if (_bmiResult! < 25) {
        return 'You have a normal weight. Keep up the good work!';
      } else if (_bmiResult! < 30) {
        return 'You are overweight. Consider adopting a healthier lifestyle.';
      } else {
        return 'You are obese. It is recommended to consult a doctor.';
      }
    } else {
      if (_bmiResult! < 18.5) {
        return 'You are underweight. Consider consulting a nutritionist.';
      } else if (_bmiResult! < 24) {
        return 'You have a normal weight. Keep up the good work!';
      } else if (_bmiResult! < 29) {
        return 'You are overweight. Consider adopting a healthier lifestyle.';
      } else {
        return 'You are obese. It is recommended to consult a doctor.';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff649f90),
        title: const Text('ABOUT HEALTH'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            const Text(
              'Enter your height and weight to calculate your BMI:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<Gender>(
                  value: Gender.Male,
                  groupValue: _selectedGender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Text('Male'),
                Radio<Gender>(
                  value: Gender.Female,
                  groupValue: _selectedGender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            ElevatedButton(
              onPressed: _calculateBmi,
              child: const Text('Calculate BMI'),
            ),
            const SizedBox(height: 20),
            if (_bmiResult != null && _bmiCategory != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'BMI: ${_bmiResult!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Category: $_bmiCategory',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Diagnosis:',
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getDiagnosis(),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
