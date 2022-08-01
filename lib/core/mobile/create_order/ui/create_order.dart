// import 'package:nb_pos/constants/app_constants.dart';
// import 'package:nb_pos/core/add_products/ui/add_products_screen.dart';
// import 'package:nb_pos/core/add_products/ui/added_products_widget.dart';
// import 'package:nb_pos/core/checkout/ui/checkout_screen.dart';
// import 'package:nb_pos/core/create_order/bloc/createorderbloc_bloc.dart';
// import 'package:nb_pos/core/create_order/ui/create_order_options.dart';
// import 'package:nb_pos/core/select_customer/ui/select_customer.dart';
// import 'package:nb_pos/core/select_customer/ui/selected_customer_widget.dart';
// import 'package:nb_pos/database/models/customer.dart';
// import 'package:nb_pos/database/models/product.dart';
// import 'package:nb_pos/utils/helper.dart';
// import 'package:nb_pos/widgets/custom_appbar.dart';
// import 'package:nb_pos/widgets/long_button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CreateOrderScreen extends StatefulWidget {
//   const CreateOrderScreen({Key? key}) : super(key: key);

//   @override
//   _CreateOrderScreenState createState() => _CreateOrderScreenState();
// }

// class _CreateOrderScreenState extends State<CreateOrderScreen> {
//   //Customer to store the selected customer
//   Customer? selectedCustomer;

//   //List to store the ordered products
//   List<Product> orderedProducts = [];

//   //Order total amount
//   double totalAmount = 0.0;

//   //Total ordered items count
//   int totalItems = 0;

//   //CreateOrder bloc
//   late CreateOrderBloc _createOrderBloc;

//   @override
//   void initState() {
//     super.initState();

//     //initializing object of CreateOrderBloc
//     _createOrderBloc = CreateOrderBloc();
//     //Adding initial event into bloc
//     _createOrderBloc.add(CreateOrderInitialEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: BlocProvider.value(
//           value: _createOrderBloc,
//           child: BlocListener<CreateOrderBloc, CreateOrderState>(
//             listener: (context, state) async {
//               //show SnackBar messages, popups, navigator etc here...

//               //State when select customer
//               if (state is CreateOrderSelectCustomerState) {
//                 //Navigator to move on Select Customer Screen
//                 var data = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SelectCustomerScreenOld()));

//                 if (data != null) {
//                   selectedCustomer = data;

//                   _createOrderBloc.add(CreateOrderCustomerSelectedEvent());
//                 } else {
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                 }
//               }

//               //State for Add Products in Cart
//               else if (state is CreateOrderAddProductsState) {
//                 //Navigator to move on Add Products Screen
//                 var orders = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => AddProductsScreen(
//                               orderedProducts: orderedProducts,
//                             )));
//                 if (orders != null) {
//                   orderedProducts = orders;

//                   _createOrderBloc.add(CreateOrderProductsAddedEvent());
//                 } else {
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                 }
//               }

//               //State for showing error for selecting the customer if not selected
//               else if (state is CreateOrderSelectCustomerErrorState) {
//                 //If user press on Proceed button and customer is not selected then show error
//                 Helper.showSnackBar(context, SELECT_CUSTOMER_ERROR);
//                 _createOrderBloc.add(CreateOrderInitialEvent());
//               }

//               //State for showing error for selecting the customer if not selected
//               else if (state is CreateOrderSelectProductsErrorState) {
//                 //If user press on Proceed button and products is not added in cart then show error
//                 Helper.showSnackBar(context, SELECT_PRODUCT_ERROR);
//                 _createOrderBloc.add(CreateOrderInitialEvent());
//               }

//               //State for Changing the customer
//               else if (state is CreateOrderChangeCustomerState) {
//                 //Navigator to move on Select Customer Screen
//                 var data = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SelectCustomerScreenOld()));
//                 if (data != null) {
//                   selectedCustomer = data;

//                   _createOrderBloc.add(CreateOrderCustomerSelectedEvent());
//                 } else {
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                 }
//               }

//               //State to add more products in cart
//               else if (state is CreateOrderAddMoreProductsState) {
//                 //Navigator to move on Add Products Screen
//                 var orders = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => AddProductsScreen(
//                               orderedProducts: orderedProducts,
//                             )));
//                 if (orders != null) {
//                   orderedProducts = orders;

//                   _createOrderBloc.add(CreateOrderProductsAddedEvent());
//                 } else {
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                 }
//               }

//               //State to show error when insufficient stock
//               else if (state is CreateOrderInSufficientStockState) {
//                 Helper.showSnackBar(context, INSUFFICIENT_STOCK_ERROR);
//                 _createOrderBloc.add(CreateOrderInitialEvent());
//               }

//               //State to do successful checkout
//               else if (state is CreateOrderCheckoutState) {
//                 //Navigator to move on Checkout Screen
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => CheckoutScreen(
//                               selectedCustomer: selectedCustomer,
//                               orderedProducts: orderedProducts,
//                             )));
//                 _createOrderBloc.add(CreateOrderInitialEvent());
//               }
//             },
//             child: BlocBuilder<CreateOrderBloc, CreateOrderState>(
//               builder: (context, state) {
//                 //Initial State
//                 if (state is CreateOrderInitialState) {
//                   totalAmount = Helper().getTotal(orderedProducts);
//                   totalItems = orderedProducts.length;

//                   return loadUI(context, orderedProducts);
//                 }

//                 //Loading state
//                 else if (state is CreateOrderLoadingState) {
//                   //Return Loading UI from here...
//                   return Container();
//                 }

//                 //Customer selected state
//                 else if (state is CreateOrderCustomerSelectedState) {
//                   return loadUI(context, orderedProducts);
//                 }

//                 //Products added in Cart, when navigator comes back from Add Products screen
//                 else if (state is CreateOrderProductsAddedState) {
//                   return loadUI(context, orderedProducts);
//                 }

//                 //State when products is added in Cart by +1
//                 else if (state is CreateOrderAddProductSuccessState) {
//                   orderedProducts = state.orders;
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                   return loadUI(context, state.orders);
//                 }

//                 //State when product is removed from cart by -1
//                 else if (state is CreateOrderRemoveProductFromCartState) {
//                   orderedProducts = state.orders;
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                   return loadUI(context, state.orders);
//                 }

//                 //State when product is deleted from the cart with all the added quantities
//                 else if (state is CreateOrderDeleteProductFromCartState) {
//                   orderedProducts = state.orders;
//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                   return loadUI(context, state.orders);
//                 }

//                 //State when selected customer is deleted
//                 else if (state is CreateOrderDeleteSelectedCustomerState) {
//                   selectedCustomer = null;

//                   _createOrderBloc.add(CreateOrderInitialEvent());
//                   return loadUI(context, orderedProducts);
//                 }

//                 //When no state is matched, then blank screen
//                 //(WARNING : FOR DEBUGGING PURPOSE ONLY)
//                 else {
//                   return Container();
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BlocBuilder<CreateOrderBloc, CreateOrderState>(
//           bloc: _createOrderBloc,
//           builder: (context, state) {
//             totalAmount = Helper().getTotal(orderedProducts);
//             totalItems = orderedProducts.length;
//             String bottomButtonText =
//                 selectedCustomer == null && orderedProducts.isEmpty
//                     ? PROCEED_TO_NXT_TXT
//                     : CHECKOUT_TXT;
//             //Bottom Widget for showing items count, item total and proceed button
//             return LongButton(
//                 buttonTitle: bottomButtonText,
//                 isAmountAndItemsVisible: true,
//                 totalAmount: '$totalAmount',
//                 totalItems: '$totalItems',
//                 onTap: () => _createOrderBloc.add(
//                     CreateOrderProceedToCheckoutEvent(
//                         selectedCustomer, orderedProducts)));
//           }),
//     );
//   }

//   ///Function to load the UI for Create Order Screen
//   Widget loadUI(BuildContext context, List<Product> orderedProducts) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const CustomAppbar(title: CREATE_ORDER_TXT),
//           Visibility(
//               visible: selectedCustomer == null,
//               child: CreateOrderOptions(
//                 tileTile: SELECT_CUSTOMER_TXT,
//                 onTap: () =>
//                     _createOrderBloc.add(CreateOrderSelectCustomerEvent()),
//               )),
//           Visibility(
//               visible: selectedCustomer != null,
//               child: SelectedCustomerWidget(
//                 selectedCustomer: selectedCustomer,
//                 onDelete: () => _createOrderBloc
//                     .add(CreateOrderDeleteSelectedCustomerEvent()),
//                 onTapChangeCustomer: () =>
//                     _createOrderBloc.add(CreateOrderChangeCustomerEvent()),
//               )),
//           Visibility(
//               visible: orderedProducts.isEmpty,
//               child: CreateOrderOptions(
//                   tileTile: ADD_PRODUCT_TXT,
//                   onTap: () =>
//                       _createOrderBloc.add(CreateOrderAddProductsEvent()))),
//           Visibility(
//               visible: orderedProducts.isNotEmpty,
//               child: AddProductsWidget(
//                 orderedProducts: orderedProducts,
//                 onDelete: (product) => _createOrderBloc.add(
//                     CreateOrderDeleteProductFromCartEvent(
//                         product, orderedProducts)),
//                 onItemAdd: (product) => _createOrderBloc.add(
//                     CreateOrderAddProductInCartEvent(product, orderedProducts)),
//                 onItemRemove: (product) => _createOrderBloc.add(
//                     CreateOrderRemoveProductFromCartEvent(
//                         product, orderedProducts)),
//                 onAddMoreProducts: () =>
//                     _createOrderBloc.add(CreateOrderAddProductsEvent()),
//               )),
//         ],
//       ),
//     );
//   }
// }
