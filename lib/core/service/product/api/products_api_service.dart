import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:nb_posx/database/db_utils/db_taxes.dart';
import 'package:nb_posx/database/models/taxes.dart';

import '../../../../../constants/app_constants.dart';
import '../model/category_products_response.dart' as cat_resp;

import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/db_utils/db_product.dart';
import '../../../../../database/models/attribute.dart';
import '../../../../../database/models/category.dart';
import '../../../../../database/models/option.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../../database/models/product.dart';
import '../model/products_response.dart';

class ProductsService {
  Future<CommanResponse> getCategoryProduct() async {
    if (await Helper.isNetworkAvailable()) {
      String lastSyncDateTime =
          await DBPreferences().getPreference(PRODUCT_LAST_SYNC_DATETIME);

      String formattedDate = lastSyncDateTime.isNotEmpty
          ? DateFormat("yyyy-MM-dd").format(DateTime.parse(lastSyncDateTime))
          : "";

      var categoryProductsPath = "$CATEGORY_PRODUCTS_PATH?from_date=";
      //Call to products list api
      var apiResponse =
          await APIUtils.getRequestWithHeaders(categoryProductsPath);
      log(jsonEncode(apiResponse));

      cat_resp.CategoryProductsResponse resp =
          cat_resp.CategoryProductsResponse.fromJson(apiResponse);
      if (resp.message!.isNotEmpty) {
        List<Category> categories = [];
        //TODO :: Debug on this line

// resp.message!.forEach((catObj){})
        // await Future.forEach(resp.message!, (catObj) async {

//resp.message!.forEach((catObj)async{

        await Future.forEach(resp.message!, (catObj) async {
          var catData = catObj as cat_resp.Message;
          //   log("catObj:$catObj");
          //var image = Uint8List.fromList([]);
          var image = (catData.itemGroupImage == null ||
                  catData.itemGroupImage!.isEmpty)
              ? Uint8List.fromList([])
              : await Helper.getImageBytesFromUrl(catData.itemGroupImage!);
          List<Product> products = [];

          await Future.forEach(catData.items!, (itemObj) async {
            var item = itemObj as cat_resp.Items;
            List<Attribute> attributes = [];
            await Future.forEach(item.attributes!, (attributeObj) async {
              var attributeData = attributeObj as cat_resp.Attributes;
              List<Option> options = [];
              for (var optionObj in attributeData.options!) {
                Option option = Option(
                    id: optionObj.id!,
                    name: optionObj.name!,
                    price: optionObj.price!,
                    selected: optionObj.selected!,
                    tax: optionObj.tax != null
                        ? optionObj.tax!.first.taxRate!
                        : 0.0);
                options.add(option);
              }
              Attribute attrib = Attribute(
                  name: attributeData.name!,
                  moq: attributeData.moq!,
                  type: attributeData.type!,
                  options: options);
              attributes.add(attrib);
            });

            List<Taxes> taxes = [];
            await Future.forEach(item.tax!, (taxObj) async {
              var taxData = taxObj as cat_resp.Tax;
              if (item.stockQty! > 0 &&
                  item.productPrice! > 0 &&
                  taxData.taxRate! > 0) {
              Taxes tax = Taxes(
                taxId: taxData.taxId!,
                itemTaxTemplate: taxData.itemTaxTemplate!,
                taxType: taxData.taxType!,
                taxRate: taxData.taxRate!,
                
              );
              taxes.add(tax);

              }
            });
            await DbTaxes().addTaxes(taxes);

            await DBPreferences().savePreference(
                PRODUCT_LAST_SYNC_DATETIME, Helper.getCurrentDateTime());

            var imageBytes = await Helper.getImageBytesFromUrl(item.image!);

            Product product = Product(
                id: item.id!,
                name: item.name!,
                group: catData.itemGroup!,
                description: '',
                stock: item.stockQty!,
                price: item.productPrice ?? 0.0,
                attributes: attributes,
                productImage: imageBytes,
                productImageUrl: item.image,
                productUpdatedTime: DateTime.now(),
                // tax: item.tax != null && item.tax!.isNotEmpty
                //     ? item.tax!.first.taxRate!
                //     : 0.0);
                tax: taxes);
            products.add(product);
          });
          Category category = Category(
              id: catData.itemGroup!,
              name: catData.itemGroup!,
              image: image,
              items: products);
          categories.add(category);
        });

        await DbCategory().addCategory(categories);
        await DBPreferences().savePreference(
            PRODUCT_LAST_SYNC_DATETIME, Helper.getCurrentDateTime());

        //returning the CommanResponse as true
        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      } else {
        //returning the CommanResponse as false with message from api.
        return CommanResponse(
            status: false,
            message: NO_PRODUCTS_FOUND_MSG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      //returning CommanResponse as false with message that no internet,
      //so loading data from local database (if available).
      return CommanResponse(
          status: false,
          message: NO_INTERNET_LOADING_DATA_FROM_LOCAL,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }

  Future<CommanResponse> getProducts() async {
    if (await Helper.isNetworkAvailable()) {
      //Fetching hub manager id/email from DbPreferences
      String hubManagerId = await DBPreferences().getPreference(HubManagerId);

      String lastSyncDateTime =
          await DBPreferences().getPreference(PRODUCT_LAST_SYNC_DATETIME);

      String apiUrl = PRODUCTS_PATH;
      apiUrl += '?hub_manager=$hubManagerId&last_sync=$lastSyncDateTime';

      //Call to products list api
      var apiResponse = await APIUtils.getRequestWithHeaders(apiUrl);
      log(jsonEncode(apiResponse));

      //Parsing the JSON response
      ProductsResponse productData = ProductsResponse.fromJson(apiResponse);

      //If success response from api
      if (productData.message.message == "success") {
        //Creating the object of DBCustomer

        //Products list
        List<Product> products = [];

        //Populating the customer database with new data from api
        await Future.forEach(productData.message.itemList, (prodData) async {
          var product = prodData as ItemList;
          var image = Uint8List.fromList([]);

          if (product.image != null) {
            //Fetching image bytes (Uint8List) from image url
            image = await Helper.getImageBytesFromUrl(product.image!);
          }

          //Creating object for product
          Product tempProduct = Product(
              id: product.itemCode,
              name: product.itemName,
              group: product.itemGroup,
              description: product.description,
              stock: product.availableQty,
              price: product.priceListRate.toDouble(),
              attributes: [],
              productImage: image,
              productUpdatedTime: DateTime.parse(product.itemModified),
              tax: []);

          //Adding product into the products list
          products.add(tempProduct);
        });

        //Adding new products list into the database
        await DbProduct().addProducts(products);
        await DBPreferences().savePreference(
            PRODUCT_LAST_SYNC_DATETIME, Helper.getCurrentDateTime());

        //returning the CommanResponse as true
        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      }

      //If failure response from api
      else {
        //returning the CommanResponse as false with message from api.
        return CommanResponse(
            status: false,
            message: NO_PRODUCTS_FOUND_MSG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      //returning CommanResponse as false with message that no internet,
      //so loading data from local database (if available).
      return CommanResponse(
          status: false,
          message: NO_INTERNET_LOADING_DATA_FROM_LOCAL,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
