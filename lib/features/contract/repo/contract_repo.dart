import 'package:crm_prasarana_mobile/core/service/api_service.dart';
import 'package:crm_prasarana_mobile/core/utils/method.dart';
import 'package:crm_prasarana_mobile/core/utils/url_container.dart';
import 'package:crm_prasarana_mobile/common/models/response_model.dart';
import 'package:crm_prasarana_mobile/features/contract/model/contract_post_model.dart';

class ContractRepo {
  ApiClient apiClient;
  ContractRepo({required this.apiClient});

  Future<ResponseModel> getAllContracts() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.contractsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getContractDetails(contractId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.contractsUrl}/id/$contractId";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getAllCustomers() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createContract(ContractPostModel contractModel,
      {String? contractId, bool isUpdate = false}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.contractsUrl}";

    Map<String, dynamic> params = {
      "subject": contractModel.subject,
      "client": contractModel.client,
      "datestart": contractModel.startDate,
      "dateend": contractModel.endDate,
      "contract_value": contractModel.contractValue,
      "description": contractModel.description,
      "content": contractModel.content,
    };

    ResponseModel responseModel = await apiClient.request(
        isUpdate ? '$url/id/$contractId' : url,
        isUpdate ? Method.putMethod : Method.postMethod,
        params,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> deleteContract(contractId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.contractsUrl}/id/$contractId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.deleteMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchContract(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.contractsUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
