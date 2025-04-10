class URLConstants {
  static const String BASE_URL = 'https://be.dhn.io.vn';
  static String GET_ORDER_VIDEO(int page, int limit, String? orderCode) => '/dpm/v1/order/video/search?page=$page&limit=$limit';
    static String PRE_UPLOAD = '/dpm/v1/file/pres-upload';
    static String CREATE_PARCEL = '/dpm/v1/parcel';
    static String CREATE_PARCEL_ITEM = '/dpm/v1/parcel/item';
}