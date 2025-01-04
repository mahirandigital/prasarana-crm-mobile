import 'package:crm_prasarana_mobile/core/service/api_service.dart';
import 'package:crm_prasarana_mobile/core/utils/method.dart';
import 'package:crm_prasarana_mobile/core/utils/url_container.dart';
import 'package:crm_prasarana_mobile/common/models/response_model.dart';

class ItemRepo {
  ApiClient apiClient;
  ItemRepo({required this.apiClient});

  Future<ResponseModel> getAllItems() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.itemsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getItemDetails(itemId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.itemsUrl}/id/$itemId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchItem(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.itemsUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
