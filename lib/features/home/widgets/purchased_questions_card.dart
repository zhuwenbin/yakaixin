import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/question_bank_model.dart';

class PurchasedQuestionsCard extends StatelessWidget {
  final List<PurchasedGoodsModel> purchasedGoods;

  const PurchasedQuestionsCard({super.key, required this.purchasedGoods});

  @override
  Widget build(BuildContext context) {
    if (purchasedGoods.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('已购试题', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          ...purchasedGoods.map((goods) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                Expanded(child: Text(goods.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))),
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: CircularProgressIndicator(
                    value: goods.questionCount > 0 ? goods.doneCount / goods.questionCount : 0.0,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
