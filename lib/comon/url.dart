class URLConstants {
  static const String BASE_URL = 'https://be.dhn.io.vn';
  static String GET_ME = '/dpm/v1/user/me';
  static String GET_STORAGE = '/dpm/v1/file/storage';
  static String GET_ORDER_VIDEO(int page, int limit, String? orderCode) => '/dpm/v1/order/video/search?page=$page&limit=$limit&orderCode=$orderCode';
  static String GET_LIST_STORE = '/dpm/v1/user/store';
  static String AUTH_STORE(String id) => '/dpm/v1/auth/store/$id/switch';
  static String PRE_UPLOAD = '/dpm/v1/file/pres-upload';
  static String INIT_UPLOAD = '/dpm/v1/file/init';
  static String COMPLETE_UPLOAD = '/dpm/v1/file/complete';
  static String GET_LIST_PARCEL(int page, int limit, String? name) => '/dpm/v1/parcel/search?page=$page&limit=$limit&name=$name';
  static String CREATE_PARCEL = '/dpm/v1/parcel';
  static String CREATE_PARCEL_ITEM = '/dpm/v1/parcel/item';
  static String GET_FILE_URL(String path) => '/dpm/v1/file/$path';
  static String GET_LIST_PARCEL_ITEM(int page, int limit, String? orderCode, String parcelId) => '/dpm/v1/parcel/item/search?page=$page&limit=$limit&parcelId=$parcelId';
  static String CREATE_ORDER_VIDEO = '/dpm/v1/order';
  static String GET_ORDER_STATS(String period) => '/dpm/v1/order/statistic?p=$period';
}