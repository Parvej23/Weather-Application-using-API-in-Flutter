import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String weatherApikey='5e4c0c432d6bd9a6fe451056258ccf2e';
const String metric='metric';
const String imperial='imperial';
const String celsius='C';
const String fahrenheit='F';
const String degree='\u00B0';
const String iconPrefix='http://openweathermap.org/img/wn/';
const String iconSuffix='@2x.png';
const String timePattern12='hh:mm: a';
const String timePattern24='HH:mm';
const cities = [
  'Athens',
  'Barishal',
  'Bangalore',
  'Berlin',
  'Capetown',
  'Dhaka',
  'Doha',
  'Dublin',
  'Dubai',
  'Faridpur',
  'Gopalgonj',
  'Hobigonj',
  'Istanbul',
  'Jakarta',
  'Jamalpur',
  'Keranigonj',
  'Kualalampur',
  'London',
  'Milan',
  'Moscow',
  'New York',
  'Oslo',
  'Paris',
  'Riadh',
  'Rome',
  'Sydney',
  'Tongi',
];

const txtTempBig80= TextStyle(
  fontSize: 80,
  color: Colors.white,
);
const txtTempSmall18= TextStyle(
  fontSize: 18,
  color: Colors.white,
);
const txtAddressWhite24= TextStyle(
  fontSize: 24,
  color: Colors.white,
  letterSpacing: 1.5
);
const txtNormalWhite16= TextStyle(
  fontSize: 16,
  color: Colors.white,
);
const txtNormalWhite54= TextStyle(
  fontSize: 16,
  color: Colors.white54,
);