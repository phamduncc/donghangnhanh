class URLConstants {
  static const String BASE_URL = 'https://be.dhn.io.vn';
  static String GET_ORDER_VIDEO(int page, int limit, String? orderCode) => '/dpm/v1/order/video/search?page=$page&limit=$limit';
}