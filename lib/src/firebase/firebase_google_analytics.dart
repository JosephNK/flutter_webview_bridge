import 'package:firebase_analytics/firebase_analytics.dart';

import '../utils/type_converter.dart';

export 'package:firebase_analytics/firebase_analytics.dart'
    show AnalyticsEventItem;

class FirebaseGoogleAnalytics {
  static final FirebaseGoogleAnalytics _instance =
      FirebaseGoogleAnalytics._internal();

  static FirebaseGoogleAnalytics get shared => _instance;

  FirebaseGoogleAnalytics._internal();

  bool _isSupported = false;

  Future<bool> isSupported() async {
    if (_isSupported) return _isSupported;
    _isSupported = await FirebaseAnalytics.instance.isSupported();
    return _isSupported;
  }

  Future<void> setUserId({
    required String userId,
    AnalyticsCallOptions? callOptions,
  }) async {
    if (await isSupported()) {
      await FirebaseAnalytics.instance.setUserId(
        id: userId,
        callOptions: callOptions,
      );
    }
  }

  Future<void> sendLogEvent(
    String eventName, {
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {
    if (await isSupported()) {
      await FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: parameters,
        callOptions: callOptions,
      );
    }
  }

  Future<void> sendLogPurchaseEvent({
    required Map<String, Object> ecommerce,
  }) async {
    if (await isSupported()) {
      final typeConverter = WebViewTypeConverter();
      final currency = typeConverter.convertTo<String>(ecommerce['currency']);
      final coupon = typeConverter.convertTo<String>(ecommerce['coupon']);
      final value = typeConverter.convertTo<double>(ecommerce['value']);
      final tax = typeConverter.convertTo<double>(ecommerce['tax']);
      final shipping = typeConverter.convertTo<double>(ecommerce['shipping']);
      final transactionId = typeConverter.convertTo<String>(
        ecommerce['transaction_id'],
      );
      final affiliation = typeConverter.convertTo<String>(
        ecommerce['affiliation'],
      );
      final orderId = typeConverter.convertTo<String>(ecommerce['order_id']);
      final userId = typeConverter.convertTo<String>(ecommerce['user_id']);
      final items = (ecommerce['items'] as List?)?.map((item) {
        final affiliation = typeConverter.convertTo<String>(
          item['affiliation'],
        );
        final currency = typeConverter.convertTo<String>(item['currency']);
        final coupon = typeConverter.convertTo<String>(item['coupon']);
        final creativeName = typeConverter.convertTo<String>(
          item['creative_name'],
        );
        final creativeSlot = typeConverter.convertTo<String>(
          item['creative_slot'],
        );
        final discount = typeConverter.convertTo<num>(item['discount']);
        final index = typeConverter.convertTo<int>(item['index']);
        final itemBrand = typeConverter.convertTo<String>(item['item_brand']);
        final itemCategory = typeConverter.convertTo<String>(
          item['item_category'],
        );
        final itemCategory2 = typeConverter.convertTo<String>(
          item['item_category2'],
        );
        final itemCategory3 = typeConverter.convertTo<String>(
          item['item_category3'],
        );
        final itemCategory4 = typeConverter.convertTo<String>(
          item['item_category4'],
        );
        final itemCategory5 = typeConverter.convertTo<String>(
          item['item_category5'],
        );
        final itemId = typeConverter.convertTo<String>(item['item_id']);
        final itemListId = typeConverter.convertTo<String>(
          item['item_list_id'],
        );
        final itemListName = typeConverter.convertTo<String>(
          item['item_list_name'],
        );
        final itemName = typeConverter.convertTo<String>(item['item_name']);
        final itemVariant = typeConverter.convertTo<String>(
          item['item_variant'],
        );
        final locationId = typeConverter.convertTo<String>(item['location_id']);
        final price = typeConverter.convertTo<num>(item['price']);
        final promotionId = typeConverter.convertTo<String>(
          item['promotion_id'],
        );
        final promotionName = typeConverter.convertTo<String>(
          item['promotion_name'],
        );
        final quantity = typeConverter.convertTo<int>(item['quantity']);

        return AnalyticsEventItem(
          affiliation: affiliation,
          currency: currency,
          coupon: coupon,
          creativeName: creativeName,
          creativeSlot: creativeSlot,
          discount: discount,
          index: index,
          itemBrand: itemBrand,
          itemCategory: itemCategory,
          itemCategory2: itemCategory2,
          itemCategory3: itemCategory3,
          itemCategory4: itemCategory4,
          itemCategory5: itemCategory5,
          itemId: itemId,
          itemListId: itemListId,
          itemListName: itemListName,
          itemName: itemName,
          itemVariant: itemVariant,
          locationId: locationId,
          price: price,
          promotionId: promotionId,
          promotionName: promotionName,
          quantity: quantity,
        );
      }).toList();

      await FirebaseAnalytics.instance.logPurchase(
        currency: currency,
        coupon: coupon,
        value: value,
        items: items,
        tax: tax,
        shipping: shipping,
        transactionId: transactionId,
        affiliation: affiliation,
        parameters: {'order_id': orderId ?? '', 'user_id': userId ?? ''},
        callOptions: null,
      );
    }
  }
}
