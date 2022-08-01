// import 'package:nb_pos/database/models/customer.dart';
// import 'package:nb_pos/database/models/product.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'createorderbloc_event.dart';
// part 'createorderbloc_state.dart';

// class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
//   CreateOrderBloc() : super(CreateOrderInitialState()) {
//     on<CreateOrderEvent>((event, emit) {});

//     on<CreateOrderInitialEvent>(
//         (event, emit) => emit(CreateOrderInitialState()));

//     on<CreateOrderLoadingEvent>(
//         (event, emit) => emit(CreateOrderLoadingState()));

//     on<CreateOrderSelectCustomerEvent>(
//         (event, emit) => emit(CreateOrderSelectCustomerState()));

//     on<CreateOrderCustomerSelectedEvent>(
//         (event, emit) => emit(CreateOrderCustomerSelectedState()));

//     on<CreateOrderAddProductsEvent>(
//         (event, emit) => emit(CreateOrderAddProductsState()));

//     on<CreateOrderProductsAddedEvent>(
//         (event, emit) => emit(CreateOrderProductsAddedState()));

//     on<CreateOrderCheckoutEvent>(
//         (event, emit) => emit(CreateOrderCheckoutState()));

//     on<CreateOrderSelectCustomerErrorEvent>(
//         (event, emit) => emit(CreateOrderSelectCustomerErrorState()));

//     on<CreateOrderSelectProductsErrorEvent>(
//         (event, emit) => emit(CreateOrderSelectProductsErrorState()));

//     on<CreateOrderSelectedCustomerDeletedEvent>(
//         (event, emit) => emit(CreateOrderSelectedCustomerDeletedState()));

//     on<CreateOrderSelectedProductDeletedEvent>(
//         (event, emit) => emit(CreateOrderSelectedProductDeletedState()));

//     on<CreateOrderAddProductInCartEvent>((event, emit) async {
//       Product productData = event.product;
//       List<Product> orderedProducts = event.orders;

//       if (productData.orderedQuantity + 1 <= productData.stock) {
//         if (orderedProducts.any((element) => element.id == productData.id)) {
//           int indexOfProduct = orderedProducts
//               .indexWhere((element) => element.id == productData.id);
//           Product tempProduct = orderedProducts.elementAt(indexOfProduct);
//           productData.orderedQuantity = tempProduct.orderedQuantity + 1;
//           orderedProducts.removeAt(indexOfProduct);
//           orderedProducts.insert(indexOfProduct, productData);
//         } else {
//           productData.orderedQuantity = productData.orderedQuantity + 1;
//           orderedProducts.add(productData);
//         }

//         emit(CreateOrderAddProductSuccessState(orderedProducts));
//       } else {
//         emit(CreateOrderInSufficientStockState());
//       }
//     });

//     on<CreateOrderRemoveProductFromCartEvent>((event, emit) async {
//       Product productData = event.product;
//       List<Product> orderedProducts = event.orders;

//       if (orderedProducts.any((element) => element.id == productData.id)) {
//         productData.orderedQuantity = productData.orderedQuantity - 1;
//       }

//       if (productData.orderedQuantity == 0) {
//         orderedProducts.removeWhere((element) => element.id == productData.id);
//       }

//       emit(CreateOrderRemoveProductFromCartState(orderedProducts));
//     });

//     on<CreateOrderDeleteProductFromCartEvent>((event, emit) async {
//       final Product product = event.product;
//       final List<Product> orderedProducts = event.orders;
//       product.orderedQuantity = 0;

//       orderedProducts.removeWhere((element) => element.id == product.id);

//       emit(CreateOrderDeleteProductFromCartState(orderedProducts));
//     });

//     on<CreateOrderProceedToCheckoutEvent>((event, emit) {
//       Customer? customer = event.customer;
//       List<Product> orders = event.orders;

//       if (customer != null) {
//         if (orders.isNotEmpty) {
//           emit(CreateOrderCheckoutState());
//         } else {
//           emit(CreateOrderSelectProductsErrorState());
//         }
//       } else {
//         emit(CreateOrderSelectCustomerErrorState());
//       }

//       emit(CreateOrderProceedToCheckoutState());
//     });

//     on<CreateOrderAddMoreProductsEvent>(
//         (event, emit) => emit(CreateOrderAddMoreProductsState()));

//     on<CreateOrderChangeCustomerEvent>(
//         (event, emit) => emit(CreateOrderChangeCustomerState()));

//     on<CreateOrderDeleteSelectedCustomerEvent>((event, emit) async {
//       emit(CreateOrderDeleteSelectedCustomerState());
//     });
//   }
// }
