class URLConstants {
  static const String BASE_URL = 'https://be.dhn.io.vn';
  static String GET_ORDER_VIDEO(int page, int limit, String? orderCode) => '/dpm/v1/order/video/search?page=$page&limit=$limit&orderCode=$orderCode';
  static String PRE_UPLOAD = '/dpm/v1/file/pres-upload';
  static String GET_LIST_PARCEL(int page, int limit, String? name) => '/dpm/v1/parcel/search?page=$page&limit=$limit&name=$name';
  static String CREATE_PARCEL = '/dpm/v1/parcel';
  static String CREATE_PARCEL_ITEM = '/dpm/v1/parcel/item';
}