import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/constants/storage_keys.dart';
import '../../../core/storage/storage_service.dart';
import '../models/major_model.dart';
import '../widgets/major_selector_dialog.dart';

/// 测试选择专业功能页面
class TestMajorSelectorPage extends ConsumerWidget {
  const TestMajorSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    final majorJson = storage.getJson(StorageKeys.majorInfo);
    final currentMajor = majorJson != null ? CurrentMajor.fromJson(majorJson) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('测试选择专业'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '当前专业',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              currentMajor?.majorName ?? '未选择',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            if (currentMajor != null) ...[
              Text(
                'ID: ${currentMajor.majorId}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              if (currentMajor.majorPidLevel != null)
                Text(
                  'Level: ${currentMajor.majorPidLevel}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
            ],
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                showMajorSelector(
                  context,
                  onChanged: () {
                    print('✅ 专业已变更');
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E68FF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                  vertical: 16.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                '选择专业',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
