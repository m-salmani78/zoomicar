// ignore_for_file: constant_identifier_names

const String baseUrl = 'https://pazapp.ir';
const String authorization = 'Authorization';

class StatusResponse {
  StatusResponse._();
  static const key = 'status';
  static const failed = 'failed';
  static const success = 'success';
}

const String mapAccessToken =
    'pk.eyJ1IjoibW9tYXNhbCIsImEiOiJja3JkNXBoNjM0YmlwMnBzNnM5czA5ZGR2In0.5t5WF4SzOZDV1UAqisBDAA';

class SharedPrefsKeys {
  const SharedPrefsKeys._();

  static const app_theme_key = 'app_theme';
  static const current_car_index = 'current_car_index';
  static const token_key = 'token_key';
}
