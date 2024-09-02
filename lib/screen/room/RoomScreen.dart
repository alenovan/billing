import 'package:carabaobillingapps/helper/global_helper.dart';
import 'package:carabaobillingapps/screen/room/OpenTableScreen.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/navigation_utils.dart';
import '../../service/bloc/order/order_bloc.dart';
import '../../service/models/order/ResponseListOrdersModels.dart';
import '../BottomNavigationScreen.dart';
import 'BillingScreen.dart';

class RoomScreen extends StatefulWidget {
  final String? meja_id;

  const RoomScreen({super.key, this.meja_id});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  OrderBloc? _OrderBloc;
  late NewestOrder? dataGet = null;
  var loading = true;

  @override
  void initState() {
    super.initState();
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    _OrderBloc?.add(getDetailOrders(id: widget.meja_id.toString()));
  }

  Widget _consumerApi() {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (c, s) {
        if (s is OrdersLoadingState) {
          LoadingDialog.show(c, "Please wait...");
        } else if (s is OrdersDetailLoadedState) {
          setState(() {
            popScreen(context);
            dataGet = s.result.data![0];
            loading = false;

            if (dataGet?.type == "OPEN-BILLING" &&
                dataGet?.statusOrder == "START") {
              _currentIndex = 1;
            } else {
              _currentIndex = 0;
            }
          });
        } else if (s is OrdersErrorState) {
          BottomSheetFeedback.showError(context, "Sorry", s.message);
        }
      },
      builder: (c, s) {
        return Container(); // This will hold the loading indicator if needed
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>(
          create: (BuildContext context) => _OrderBloc!,
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          NavigationUtils.navigateTo(
              context, const BottomNavigationScreen(), false);
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: ColorConstant.primary,
            title: loading
                ? CircularProgressIndicator()
                : Text(dataGet?.name ?? "", style: GoogleFonts.openSans(color: Colors.white)),
          ),
          body: Stack(
            children: [
              _consumerApi(),
              loading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20.w),
                    height: 50.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabButton(0, "Open Table"),
                        SizedBox(width: 10.w),
                        _buildTabButton(1, "Open Billing"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      children: [
                        if (dataGet?.type == "OPEN-TABLE" ||
                            dataGet?.type.toString() == "null" ||
                            dataGet?.statusOrder == "STOP")
                          OpenTableScreen(
                            isMuiltiple: dataGet?.isMultipleChannel ?? 0,
                            id_order: dataGet?.id.toString(),
                            id_meja: dataGet!.roomId.toString(),
                            code: dataGet?.code ?? "",
                            status: dataGet?.statusOrder == "START",
                            ip: dataGet?.ip ?? "",
                            keys: dataGet?.secret ?? "",
                            multipleChannel: dataGet?.multipleChannel ?? "",
                          ),
                        if (dataGet?.type == "OPEN-BILLING" ||
                            dataGet?.type.toString() == "null" ||
                            dataGet?.statusOrder == "STOP")
                          BillingScreen(
                            isMuiltiple: dataGet?.isMultipleChannel ?? 0,
                            multipleChannel: dataGet?.multipleChannel ?? "",
                            id_order: dataGet?.id.toString(),
                            id_meja: dataGet!.roomId.toString(),
                            code: dataGet?.code ?? "",
                            status: dataGet?.statusOrder == "START",
                            ip: dataGet?.ip ?? "",
                            keys: dataGet?.secret ?? "",
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _navigateToPage(index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _currentIndex == index
                  ? ColorConstant.primary
                  : ColorConstant.subtext,
            ),
            color: _currentIndex == index
                ? ColorConstant.primary
                : Colors.transparent,
          ),
          height: 50.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                color: _currentIndex == index
                    ? ColorConstant.white
                    : ColorConstant.subtext,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
