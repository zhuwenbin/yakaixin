import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_page.dart';
import '../../features/main/main_tab_page.dart';
import '../../features/auth/views/login_center_page.dart';
import '../../features/auth/views/h5_login_page.dart';
import '../../features/auth/views/select_major_page.dart';
import '../../features/home/views/home_page.dart';
import '../../features/question_bank/views/chapter_list_page.dart';
import '../../features/question_bank/views/make_question_page.dart';
import '../../features/question_bank/views/wrong_book_page.dart';
import '../../features/question_bank/views/collect_page.dart';
import '../../features/challenge/views/challenge_index_page.dart';
import '../../features/challenge/views/level_list_page.dart';
import '../../features/challenge/views/challenge_practise_page.dart';
import '../../features/challenge/views/challenge_report_page.dart';
import '../../features/intelligent/views/intelligent_index_page.dart';
import '../../features/intelligent/views/intelligent_practise_page.dart';
import '../../features/intelligent/views/intelligent_report_page.dart';
import '../../features/exam_entry/views/exam_entry_index_page.dart';
import '../../features/exam_entry/views/exam_entry_detail_page.dart';
import '../../features/exam_entry/views/exam_knack_page.dart';
import '../../features/model_exam/views/model_exam_index_page.dart';
import '../../features/model_exam/views/exam_info_page.dart';
import '../../features/exam/views/exam_notice_page.dart';
import '../../features/exam/views/examinationing_page.dart';
import '../../features/exam/views/submit_success_page.dart';
import '../../features/exam/views/test_exam_page.dart';
import '../../features/exam/views/exam_score_report_page.dart';
import '../../features/exam/views/rank_list_page.dart';
import '../../features/course/views/study_index_page.dart';
import '../../features/course/views/my_course_page.dart';
import '../../features/course/views/course_detail_page.dart';
import '../../features/course/views/live_index_page.dart';
import '../../features/course/views/video_index_page.dart';
import '../../features/course/views/data_download_page.dart';
import '../../features/course/views/pdf_index_page.dart';
import '../../features/goods/views/goods_detail_page.dart';
import '../../features/goods/views/secret_real_detail_page.dart';
import '../../features/goods/views/subject_mock_detail_page.dart';
import '../../features/goods/views/simulated_exam_room_page.dart';
import '../../features/goods/views/course_goods_detail_page.dart';
import '../../features/order/views/my_order_page.dart';
import '../../features/order/views/pay_success_page.dart';
import '../../features/profile/views/my_index_page.dart';
import '../../features/profile/views/person_edit_page.dart';
import '../../features/profile/views/settings_page.dart';
import '../../features/user/views/report_center_page.dart';
import '../../features/question_bank/views/wrong_book_page.dart';
import '../../features/question_bank/views/collect_page.dart';
import '../../features/activity/views/code_receive_page.dart';
import '../../features/activity/views/app_upload_page.dart';
import '../../features/activity/views/open_app_page.dart';
import 'app_routes.dart';

/// 应用路由配置
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // 启动页
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    
    // 主框架
    GoRoute(
      path: AppRoutes.mainTab,
      builder: (context, state) => const MainTabPage(),
    ),
    
    // ===== F1. 用户认证模块 =====
    GoRoute(
      path: AppRoutes.loginCenter,
      builder: (context, state) => const LoginCenterPage(),
    ),
    GoRoute(
      path: AppRoutes.h5Login,
      builder: (context, state) => const H5LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.selectMajor,
      builder: (context, state) => const SelectMajorPage(),
    ),
    
    // ===== F2. 题库练习模块 =====
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.chapterList,
      builder: (context, state) => const ChapterListPage(),
    ),
    GoRoute(
      path: AppRoutes.chapterDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        // TODO: 实现ChapterDetailPage
        return const Placeholder();
      },
    ),
    GoRoute(
      path: AppRoutes.makeQuestion,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MakeQuestionPage(extra: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.lookAnalysis,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        // TODO: 实现LookAnalysisPage（或与MakeQuestionPage合并）
        return const Placeholder();
      },
    ),
    GoRoute(
      path: AppRoutes.scoreReport,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        // TODO: 实现ScoreReportPage
        return const Placeholder();
      },
    ),
    GoRoute(
      path: AppRoutes.challengeIndex,
      builder: (context, state) => const ChallengeIndexPage(),
    ),
    GoRoute(
      path: AppRoutes.levelList,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LevelListPage(
          challengeId: extra?['challenge_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.challengePractise,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChallengePractisePage(
          levelId: extra?['level_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.challengeReport,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ChallengeReportPage(
          practiceId: extra?['practice_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.intelligentIndex,
      builder: (context, state) => const IntelligentIndexPage(),
    ),
    GoRoute(
      path: AppRoutes.intelligentPractise,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return IntelligentPractisePage(
          evaluationId: extra?['evaluation_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.intelligentReport,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return IntelligentReportPage(
          practiceId: extra?['practice_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.examEntryIndex,
      builder: (context, state) => const ExamEntryIndexPage(),
    ),
    GoRoute(
      path: AppRoutes.examEntryDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExamEntryDetailPage(
          entryId: extra?['entry_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.examKnack,
      builder: (context, state) => const ExamKnackPage(),
    ),
    
    // ===== F3. 模拟考试模块 =====
    GoRoute(
      path: AppRoutes.modelExamIndex,
      builder: (context, state) => const ModelExamIndexPage(),
    ),
    GoRoute(
      path: AppRoutes.examInfo,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExamInfoPage(
          examId: extra?['exam_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.examNotice,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExamNoticePage(
          examId: extra?['exam_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.examinationing,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExaminationingPage(
          paperVersionId: extra?['paper_version_id'] ?? '',
          goodsId: extra?['goods_id'] ?? '',
          orderId: extra?['order_id'] ?? '',
          title: extra?['title'] ?? '',
          professionalId: extra?['professional_id'] ?? '',
          type: extra?['type'] ?? '',
          timeLimit: extra?['time_limit'] ?? 7200,
          recitationQuestionModel: extra?['recitation_question_model'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.submitSuccess,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SubmitSuccessPage(
          sessionName: extra?['session_name'] ?? '',
          mockName: extra?['mock_name'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.testExam,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return TestExamPage(
          examId: extra?['exam_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.examScoreReport,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ExamScoreReportPage(
          paperVersionId: extra?['paper_version_id'] ?? '',
          orderId: extra?['order_id'] ?? '',
          goodsId: extra?['goods_id'] ?? '',
          title: extra?['title'] ?? '',
          professionalId: extra?['professional_id'] ?? '',
          recitationQuestionModel: extra?['recitation_question_model'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.rankList,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return RankListPage(
          examId: extra?['exam_id'],
        );
      },
    ),
    
    // ===== F4. 学习中心模块 =====
    GoRoute(
      path: AppRoutes.studyIndex,
      builder: (context, state) => const StudyIndexPage(),
    ),
    GoRoute(
      path: AppRoutes.myCourse,
      builder: (context, state) => const MyCoursePage(),
    ),
    GoRoute(
      path: AppRoutes.courseDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CourseDetailPage(
          goodsId: extra?['goods_id'] ?? '',
          orderId: extra?['order_id'] ?? '',
          goodsPid: extra?['goods_pid'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.liveIndex,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LiveIndexPage(
          lessonId: extra?['lesson_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.videoIndex,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return VideoIndexPage(
          lessonId: extra?['lesson_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.dataDownload,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return DataDownloadPage(
          lessonId: extra?['lesson_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.pdfIndex,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PdfIndexPage(
          pdfUrl: extra?['pdf_url'],
        );
      },
    ),
    
    // ===== F5. 商品订单模块 =====
    GoRoute(
      path: AppRoutes.goodsDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final type = extra?['type'];
        
        // 将type转换为字符串进行比较（兼容String和int）
        final typeStr = type?.toString() ?? '';
        
        // 调试日志
        print('📦 商品详情路由 - type: $type, typeStr: $typeStr, goodsId: ${extra?['goods_id']}');
        
        // 根据商品类型跳转不同的详情页
        // type: 2/3=课程, 8=试卷, 10=模考, 18=题库
        if (typeStr == '2' || typeStr == '3') {
          print('✅ 跳转到课程商品详情页');
          // 课程商品详情页
          return CourseGoodsDetailPage(
            goodsId: extra?['goods_id'],
            professionalId: extra?['professional_id'],
            type: int.tryParse(typeStr),
          );
        } else {
          print('✅ 跳转到题库/试卷/模考商品详情页');
          // 题库/试卷/模考商品详情页
          return GoodsDetailPage(
            goodsId: extra?['goods_id'],
            professionalId: extra?['professional_id'],
            active: extra?['active'],
          );
        }
      },
    ),
    GoRoute(
      path: AppRoutes.secretRealDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SecretRealDetailPage(
          productId: extra?['product_id'],
          professionalId: extra?['professional_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.subjectMockDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SubjectMockDetailPage(
          productId: extra?['product_id'],
          professionalId: extra?['professional_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.simulatedExamRoom,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SimulatedExamRoomPage(
          productId: extra?['product_id'],
          professionalId: extra?['professional_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.myOrder,
      builder: (context, state) => const MyOrderPage(),
    ),
    GoRoute(
      path: AppRoutes.paySuccess,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaySuccessPage(
          orderId: extra?['order_id'],
        );
      },
    ),
    
    // ===== F6. 我的中心模块 =====
    GoRoute(
      path: AppRoutes.myIndex,
      builder: (context, state) => const MyIndexPage(),
    ),
    GoRoute(
      path: AppRoutes.personEdit,
      builder: (context, state) => const PersonEditPage(),
    ),
    GoRoute(
      path: AppRoutes.reportCenter,
      builder: (context, state) => const ReportCenterPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    
    // ===== F7. 错题本模块 =====
    GoRoute(
      path: AppRoutes.wrongBookIndex,
      builder: (context, state) => const WrongBookPage(),
    ),
    GoRoute(
      path: AppRoutes.wrongBookDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        // TODO: 实现错题详情页（或直接使用MakeQuestionPage）
        return const Placeholder();
      },
    ),
    
    // ===== F8. 收藏管理模块 =====
    GoRoute(
      path: AppRoutes.collectIndex,
      builder: (context, state) => const CollectPage(),
    ),
    GoRoute(
      path: AppRoutes.collectDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        // TODO: 实现收藏详情页（或直接使用MakeQuestionPage）
        return const Placeholder();
      },
    ),
    GoRoute(
      path: AppRoutes.examEntryCollect,
      builder: (context, state) {
        // TODO: 实现考点收藏页
        return const Placeholder();
      },
    ),
    
    // ===== F9. H5活动模块 =====
    GoRoute(
      path: AppRoutes.codeReceive,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CodeReceivePage(
          code: extra?['code'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.appUpload,
      builder: (context, state) => const AppUploadPage(),
    ),
    GoRoute(
      path: AppRoutes.openApp,
      builder: (context, state) => const OpenAppPage(),
    ),
  ],
);
